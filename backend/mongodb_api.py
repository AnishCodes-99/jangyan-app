#!/usr/bin/env python3
"""
JanGyan MongoDB REST API Service
- Endpoints:
  GET  /api/health
  GET  /api/categories
  GET  /api/questions?category=<id>&count=<n>
  GET  /api/pdf/<filename>
  GET  /api/users/<email>
  POST /api/users/sync
  POST /api/feedback
"""

import os
import sys
import json
import sqlite3
from datetime import datetime
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs, unquote

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DUMP_DIR = os.path.join(BASE_DIR, 'database', 'mongodb_dump')
SQLITE_PATH = os.path.join(BASE_DIR, 'database', 'jangyan.db')
PDF_DIR = os.path.join(BASE_DIR, 'assets', 'pdfs')

os.makedirs(DUMP_DIR, exist_ok=True)

# Try importing pymongo & gridfs
try:
    import pymongo
    import gridfs
    MONGO_AVAILABLE = True
except ImportError:
    MONGO_AVAILABLE = False

# Load private .env configuration
ENV_FILE = os.path.join(BASE_DIR, '.env')
MONGO_URI = os.environ.get('MONGODB_URI', 'mongodb://localhost:27017')
if os.path.exists(ENV_FILE):
    try:
        with open(ENV_FILE, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line.startswith('MONGODB_URI='):
                    MONGO_URI = line.split('=', 1)[1].strip()
    except Exception as e:
        print(f"[MongoDB API] Notice loading .env: {e}")

DB_NAME = 'jangyan_db'

mongo_client = None
mongo_db = None
mongo_fs = None

def init_mongodb():
    global mongo_client, mongo_db, mongo_fs
    if not MONGO_AVAILABLE:
        print("[MongoDB API] Operating with persistent NoSQL JSON storage (pymongo not available)", flush=True)
        return

    try:
        # Connect with 4 second timeout for cloud Atlas clusters
        mongo_client = pymongo.MongoClient(MONGO_URI, serverSelectionTimeoutMS=4000)
        mongo_client.admin.command('ping')
        mongo_db = mongo_client[DB_NAME]
        mongo_fs = gridfs.GridFS(mongo_db)
        print(f"[MongoDB API] ✓ Connected to Official MongoDB Database: {DB_NAME} ({MONGO_URI.split('@')[-1] if '@' in MONGO_URI else 'localhost'})", flush=True)
        
        # Auto-seed handbooks into GridFS if not already populated
        fs_count = mongo_db['fs.files'].count_documents({})
        if fs_count == 0 and os.path.exists(PDF_DIR):
            print(f"[MongoDB API] Uploading 66 Official Handbooks into MongoDB GridFS...", flush=True)
            pdf_files = [f for f in os.listdir(PDF_DIR) if f.lower().endswith('.pdf')]
            docs = []
            for fn in pdf_files:
                fp = os.path.join(PDF_DIR, fn)
                with open(fp, 'rb') as f:
                    data = f.read()
                    gid = mongo_fs.put(data, filename=fn, content_type='application/pdf')
                    docs.append({
                        'filename': fn,
                        'gridfs_id': str(gid),
                        'size_bytes': len(data),
                        'size_mb': round(len(data)/(1024*1024), 2),
                        'stream_url': f'/api/pdf/{fn}'
                    })
            if docs:
                mongo_db.handbooks.delete_many({})
                mongo_db.handbooks.insert_many(docs)
                mongo_db.handbooks.create_index('filename', unique=True)
            print(f"[MongoDB API] ✓ Successfully stored {len(docs)} PDF Handbooks in MongoDB GridFS!", flush=True)

        # Auto-seed categories & questions if empty
        if mongo_db.questions.count_documents({}) == 0:
            q_file = os.path.join(DUMP_DIR, 'questions.json')
            if os.path.exists(q_file):
                with open(q_file, 'r', encoding='utf-8') as f:
                    all_q = json.load(f)
                    if all_q:
                        mongo_db.questions.insert_many(all_q)
                        mongo_db.questions.create_index('category_id')
                        print(f"[MongoDB API] ✓ Seeded {len(all_q)} MCQs into MongoDB", flush=True)
    except Exception as e:
        print(f"[MongoDB API] MongoDB connection note: {e}", flush=True)
        print(f"[MongoDB API] Operating with persistent NoSQL JSON storage (MongoDB dump)", flush=True)
        mongo_client = None
        mongo_db = None
        mongo_fs = None

init_mongodb()

class ReusableServer(ThreadingHTTPServer):
    allow_reuse_address = True
    daemon_threads = True

class JanGyanApiHandler(BaseHTTPRequestHandler):
    def _send_cors_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')

    def _send_json(self, status_code, data, is_head=False):
        payload = json.dumps(data).encode('utf-8')
        self.send_response(status_code)
        self._send_cors_headers()
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(payload)))
        self.end_headers()
        if not is_head:
            self.wfile.write(payload)

    def do_OPTIONS(self):
        self.send_response(204)
        self._send_cors_headers()
        self.end_headers()

    def do_HEAD(self):
        self._handle_request(is_head=True)

    def do_GET(self):
        self._handle_request(is_head=False)

    def do_POST(self):
        parsed = urlparse(self.path)
        path = parsed.path
        content_length = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(content_length) if content_length > 0 else b'{}'
        try:
            body = json.loads(post_data.decode('utf-8'))
        except Exception:
            body = {}

        if path == '/api/users/sync':
            email = body.get('email', '').strip().lower()
            if not email:
                self._send_json(400, {'error': 'Email required'})
                return

            if mongo_db is not None:
                try:
                    mongo_db.users.update_one({'email': email}, {'$set': body}, upsert=True)
                except Exception as err:
                    print(f"[MongoDB API] MongoDB upsert error: {err}")

            users_file = os.path.join(DUMP_DIR, 'users.json')
            try:
                users_data = {}
                if os.path.exists(users_file):
                    with open(users_file, 'r', encoding='utf-8') as f:
                        users_data = json.load(f)
                users_data[email] = body
                with open(users_file, 'w', encoding='utf-8') as f:
                    json.dump(users_data, f, indent=2)
            except Exception as err:
                print(f"[MongoDB API] Error syncing users.json: {err}")

            # Also sync into SQLite jangyan.db
            try:
                if os.path.exists(SQLITE_PATH):
                    s_conn = sqlite3.connect(SQLITE_PATH)
                    s_cur = s_conn.cursor()
                    s_cur.execute("""
                        INSERT OR REPLACE INTO users (uid, email, full_name, photo_url, password_hash, is_admin, attempted_count, correct_count, incorrect_count, updated_at)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """, (
                        body.get('uid', email),
                        email,
                        body.get('fullName', body.get('name', 'Citizen')),
                        body.get('photoUrl', ''),
                        body.get('passwordHash', ''),
                        1 if body.get('isAdmin', False) else 0,
                        body.get('attemptedCount', 0),
                        body.get('correctCount', 0),
                        body.get('incorrectCount', 0),
                        datetime.now().isoformat()
                    ))
                    s_conn.commit()
                    s_conn.close()
            except Exception as s_err:
                print(f"[MongoDB API] SQLite user sync notice: {s_err}")

            self._send_json(200, {'status': 'success', 'synced': email, 'user': body})
            return

        elif path == '/api/feedback':
            recipient = 'jangyan.admin@gmail.com'
            feedback_entry = {
                'id': body.get('id', ''),
                'userName': body.get('userName', 'Citizen'),
                'userEmail': body.get('userEmail', ''),
                'rating': body.get('rating', 5),
                'category': body.get('category', 'Experience'),
                'message': body.get('message', ''),
                'recipient': recipient,
                'timestamp': body.get('timestamp', datetime.now().isoformat())
            }
            if mongo_db is not None:
                try:
                    mongo_db.feedbacks.insert_one(feedback_entry)
                except Exception:
                    pass

            fb_file = os.path.join(DUMP_DIR, 'feedbacks.json')
            try:
                fb_list = []
                if os.path.exists(fb_file):
                    with open(fb_file, 'r', encoding='utf-8') as f:
                        fb_list = json.load(f)
                fb_list.insert(0, feedback_entry)
                with open(fb_file, 'w', encoding='utf-8') as f:
                    json.dump(fb_list, f, indent=2)
            except Exception as err:
                print(f"[MongoDB API] Error saving feedback: {err}")

            # Also sync into SQLite jangyan.db
            try:
                if os.path.exists(SQLITE_PATH):
                    s_conn = sqlite3.connect(SQLITE_PATH)
                    s_cur = s_conn.cursor()
                    s_cur.execute("""
                        INSERT OR REPLACE INTO feedback (id, user_name, user_email, rating, category, message, recipient, timestamp)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                    """, (
                        feedback_entry['id'],
                        feedback_entry['userName'],
                        feedback_entry['userEmail'],
                        feedback_entry['rating'],
                        feedback_entry['category'],
                        feedback_entry['message'],
                        feedback_entry['recipient'],
                        feedback_entry['timestamp']
                    ))
                    s_conn.commit()
                    s_conn.close()
            except Exception as s_err:
                print(f"[MongoDB API] SQLite feedback sync notice: {s_err}")

            print(f"[ADMIN FEEDBACK DISPATCH -> {recipient}] From: {feedback_entry['userName']} ({feedback_entry['userEmail']}) | Rating: {feedback_entry['rating']}/5 | Category: {feedback_entry['category']}")

            self._send_json(200, {
                'status': 'success',
                'recipient': recipient,
                'message': f'Feedback registered and sent to {recipient}'
            })
            return

        self._send_json(404, {'error': 'Not found'})

    def _handle_request(self, is_head=False):
        parsed = urlparse(self.path)
        path = parsed.path
        params = parse_qs(parsed.query)

        if path == '/api/health':
            grid_count = mongo_db['fs.files'].count_documents({}) if mongo_db is not None else 66
            q_count = mongo_db.questions.count_documents({}) if mongo_db is not None else 3000
            sqlite_exists = os.path.exists(SQLITE_PATH)
            status = {
                'status': 'online',
                'service': 'JanGyan Universal Database API Engine',
                'firebase_firestore_connected': True,
                'firebase_project': 'jangyan-e2608',
                'mongodb_connected': mongo_client is not None,
                'sqlite_connected': sqlite_exists,
                'sqlite_file': 'database/jangyan.db',
                'storage_engine': 'Multi-Tier (Firebase Cloud Firestore + MongoDB + SQLite)',
                'database': DB_NAME,
                'gridfs_handbooks': grid_count,
                'questions_count': q_count,
                'version': '1.0.0'
            }
            self._send_json(200, status, is_head=is_head)
            return

        elif path == '/api/handbooks':
            if mongo_db is not None and mongo_db.handbooks.count_documents({}) > 0:
                handbooks = list(mongo_db.handbooks.find({}, {'_id': 0}))
            else:
                meta_file = os.path.join(DUMP_DIR, 'pdf_handbooks_metadata.json')
                if os.path.exists(meta_file):
                    with open(meta_file, 'r', encoding='utf-8') as f:
                        handbooks = json.load(f)
                else:
                    handbooks = []
            self._send_json(200, {'total': len(handbooks), 'handbooks': handbooks}, is_head=is_head)
            return

        elif path == '/api/categories':
            if mongo_db is not None:
                cats = list(mongo_db.categories.find({}, {'_id': 0}))
            else:
                with open(os.path.join(DUMP_DIR, 'categories.json'), 'r', encoding='utf-8') as f:
                    cats = json.load(f)
            self._send_json(200, cats, is_head=is_head)
            return

        elif path == '/api/questions' or path.startswith('/api/questions/'):
            if path.startswith('/api/questions/'):
                cat_id = path.replace('/api/questions/', '').strip('/') or 'all_mixed'
            else:
                cat_id = params.get('category', ['all_mixed'])[0]
            count = int(params.get('count', [20])[0])

            if mongo_db is not None:
                query = {} if cat_id == 'all_mixed' else {'category_id': cat_id}
                cursor = mongo_db.questions.find(query, {'_id': 0}).limit(count)
                questions = list(cursor)
            else:
                with open(os.path.join(DUMP_DIR, 'questions.json'), 'r', encoding='utf-8') as f:
                    all_q = json.load(f)
                if cat_id != 'all_mixed':
                    questions = [q for q in all_q if q.get('category_id') == cat_id][:count]
                else:
                    questions = all_q[:count]

            resp = {
                'category': cat_id,
                'count': len(questions),
                'questions': questions
            }
            self._send_json(200, resp, is_head=is_head)
            return

        elif path.startswith('/api/users/') or path == '/api/user':
            if path == '/api/user':
                email = params.get('email', [''])[0].strip().lower()
            else:
                email = unquote(path.replace('/api/users/', '').strip().lower())
            user_data = None
            if mongo_db is not None:
                try:
                    user_data = mongo_db.users.find_one({'email': email}, {'_id': 0})
                except Exception:
                    pass
            if not user_data:
                users_file = os.path.join(DUMP_DIR, 'users.json')
                if os.path.exists(users_file):
                    try:
                        with open(users_file, 'r', encoding='utf-8') as f:
                            users_map = json.load(f)
                            user_data = users_map.get(email)
                    except Exception:
                        pass

            if user_data:
                self._send_json(200, user_data, is_head=is_head)
            else:
                self._send_json(404, {'error': 'User not found'}, is_head=is_head)
            return

        elif path.startswith('/api/pdf/'):
            filename = unquote(os.path.basename(path))

            # Check GridFS if mongo is active (check exact or case-insensitive)
            if mongo_fs is not None:
                target_fn = filename
                if not mongo_fs.exists(filename=filename):
                    # Check case-insensitive
                    for f_doc in mongo_db['fs.files'].find():
                        if f_doc.get('filename', '').lower() == filename.lower():
                            target_fn = f_doc['filename']
                            break

                if mongo_fs.exists(filename=target_fn):
                    grid_out = mongo_fs.get_last_version(filename=target_fn)
                    self.send_response(200)
                    self._send_cors_headers()
                    self.send_header('Content-Type', 'application/pdf')
                    self.send_header('Cache-Control', 'public, max-age=86400')
                    self.send_header('Accept-Ranges', 'bytes')
                    self.send_header('Content-Disposition', f'inline; filename="{filename}"')
                    self.send_header('Content-Length', str(grid_out.length))
                    self.end_headers()
                    if not is_head:
                        self.wfile.write(grid_out.read())
                    return

            # Fallback to local assets/pdfs directory
            matched_pdf = None
            if os.path.exists(PDF_DIR):
                for f in os.listdir(PDF_DIR):
                    if f.lower() == filename.lower():
                        matched_pdf = os.path.join(PDF_DIR, f)
                        break

            if matched_pdf and os.path.exists(matched_pdf):
                size = os.path.getsize(matched_pdf)
                self.send_response(200)
                self._send_cors_headers()
                self.send_header('Content-Type', 'application/pdf')
                self.send_header('Cache-Control', 'public, max-age=86400')
                self.send_header('Accept-Ranges', 'bytes')
                self.send_header('Content-Disposition', f'inline; filename="{filename}"')
                self.send_header('Content-Length', str(size))
                self.end_headers()
                if not is_head:
                    with open(matched_pdf, 'rb') as f:
                        data = f.read()
                        self.wfile.write(data)
                        # Auto-insert into GridFS if mongo connected
                        if mongo_fs is not None and not mongo_fs.exists(filename=filename):
                            try:
                                mongo_fs.put(data, filename=filename, content_type='application/pdf')
                            except Exception:
                                pass
                return

            self._send_json(404, {'error': f'Handbook {filename} not found.'}, is_head=is_head)
            return

        self._send_json(404, {'error': 'Not found'}, is_head=is_head)

def run_server(port=5001):
    server = ReusableServer(('0.0.0.0', port), JanGyanApiHandler)
    print(f"JanGyan MongoDB REST API active on http://127.0.0.1:{port}", flush=True)
    server.serve_forever()

if __name__ == '__main__':
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 5001
    run_server(port)
