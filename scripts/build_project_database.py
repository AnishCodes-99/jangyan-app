#!/usr/bin/env python3
"""
JanGyan Project Database Builder
Creates and updates the relational SQLite database `database/jangyan.db`
from the project assets and dumps, ensuring all data is permanently and properly
stored within the repository.
"""

import os
import sys
import json
import sqlite3
from datetime import datetime

# Configure UTF-8 output safe for Windows consoles
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_DIR = os.path.join(BASE_DIR, 'database')
DUMP_DIR = os.path.join(DB_DIR, 'mongodb_dump')
SQLITE_PATH = os.path.join(DB_DIR, 'jangyan.db')

os.makedirs(DB_DIR, exist_ok=True)
os.makedirs(DUMP_DIR, exist_ok=True)

def build_database():
    print("=" * 60)
    print("JanGyan - Building Project Local Database (SQLite & NoSQL)")
    print("=" * 60)
    
    conn = sqlite3.connect(SQLITE_PATH)
    cur = conn.cursor()
    
    # Enable WAL mode for high concurrency
    cur.execute("PRAGMA journal_mode=WAL;")
    
    # 1. Categories Table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS categories (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        icon TEXT,
        color TEXT,
        modules_count INTEGER DEFAULT 0,
        questions_count INTEGER DEFAULT 0
    );
    """)
    
    # 2. Handbooks Table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS handbooks (
        filename TEXT PRIMARY KEY,
        category_id TEXT,
        title TEXT,
        size_bytes INTEGER,
        size_mb REAL,
        stream_url TEXT,
        local_path TEXT
    );
    """)
    
    # 3. Questions Table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS questions (
        id TEXT PRIMARY KEY,
        category_id TEXT,
        category_title TEXT,
        question TEXT NOT NULL,
        options_json TEXT NOT NULL,
        correct_answer_index INTEGER NOT NULL,
        explanation TEXT,
        difficulty TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id)
    );
    """)
    
    # 4. Users Table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS users (
        uid TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        full_name TEXT NOT NULL,
        photo_url TEXT,
        password_hash TEXT,
        is_admin INTEGER DEFAULT 0,
        attempted_count INTEGER DEFAULT 0,
        correct_count INTEGER DEFAULT 0,
        incorrect_count INTEGER DEFAULT 0,
        created_at TEXT,
        updated_at TEXT
    );
    """)
    
    # 5. Quiz Progress Table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS quiz_progress (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        category_id TEXT NOT NULL,
        score INTEGER NOT NULL,
        total_questions INTEGER NOT NULL,
        percentage REAL NOT NULL,
        completed_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (uid)
    );
    """)
    
    # 6. Feedback Table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS feedback (
        id TEXT PRIMARY KEY,
        user_name TEXT,
        user_email TEXT,
        rating INTEGER,
        category TEXT,
        message TEXT,
        recipient TEXT,
        timestamp TEXT
    );
    """)
    
    # Populate Categories
    cat_file = os.path.join(DUMP_DIR, 'categories.json')
    if not os.path.exists(cat_file):
        cat_file = os.path.join(BASE_DIR, 'assets', 'data', 'modules_metadata.json')
        
    categories_data = []
    if os.path.exists(cat_file):
        with open(cat_file, 'r', encoding='utf-8') as f:
            categories_data = json.load(f)
            for c in categories_data:
                cur.execute("""
                INSERT OR REPLACE INTO categories (id, title, description, icon, color, modules_count, questions_count)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """, (
                    c.get('id', ''),
                    c.get('title', ''),
                    c.get('description', ''),
                    c.get('icon', ''),
                    c.get('color', ''),
                    len(c.get('modules', [])) if 'modules' in c else c.get('modulesCount', 0),
                    c.get('questionsCount', 500)
                ))
        print(f"[OK] Populated {len(categories_data)} categories in SQLite")

    # Populate Handbooks
    hb_file = os.path.join(DUMP_DIR, 'pdf_handbooks_metadata.json')
    if os.path.exists(hb_file):
        with open(hb_file, 'r', encoding='utf-8') as f:
            handbooks_data = json.load(f)
            for h in handbooks_data:
                cur.execute("""
                INSERT OR REPLACE INTO handbooks (filename, category_id, title, size_bytes, size_mb, stream_url, local_path)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """, (
                    h.get('filename', ''),
                    h.get('category_id', ''),
                    h.get('title', h.get('filename', '')),
                    h.get('size_bytes', 0),
                    h.get('size_mb', 0.0),
                    h.get('stream_url', f"/api/pdf/{h.get('filename', '')}"),
                    os.path.join('assets', 'pdfs', h.get('filename', ''))
                ))
        print(f"[OK] Populated {len(handbooks_data)} handbooks in SQLite")

    # Populate Questions
    q_file = os.path.join(DUMP_DIR, 'questions.json')
    if not os.path.exists(q_file):
        # Extract from all_extracted_mcqs.json
        mcq_source = os.path.join(BASE_DIR, 'assets', 'data', 'all_extracted_mcqs.json')
        if os.path.exists(mcq_source):
            with open(mcq_source, 'r', encoding='utf-8') as f:
                all_mcqs = json.load(f)
                questions_flat = []
                for cat_id, cat_data in all_mcqs.items():
                    for q in cat_data.get('questions', []):
                        item = dict(q)
                        item['category_id'] = cat_id
                        item['category_title'] = cat_data.get('title', cat_id)
                        questions_flat.append(item)
                with open(q_file, 'w', encoding='utf-8') as out_f:
                    json.dump(questions_flat, out_f, indent=2)

    if os.path.exists(q_file):
        with open(q_file, 'r', encoding='utf-8') as f:
            questions_data = json.load(f)
            for q in questions_data:
                q_id = str(q.get('id', ''))
                cat_id = q.get('category_id', '')
                unique_id = f"{cat_id}_{q_id}" if not q_id.startswith(cat_id) else q_id
                options_str = json.dumps(q.get('options', []))
                
                cur.execute("""
                INSERT OR REPLACE INTO questions (id, category_id, category_title, question, options_json, correct_answer_index, explanation, difficulty)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    unique_id,
                    cat_id,
                    q.get('category_title', ''),
                    q.get('question', ''),
                    options_str,
                    q.get('correct_answer_index', q.get('correctIndex', 0)),
                    q.get('explanation', ''),
                    q.get('difficulty', 'standard')
                ))
        print(f"[OK] Populated {len(questions_data)} MCQs in SQLite")

    # Populate Users
    u_file = os.path.join(DUMP_DIR, 'users.json')
    if os.path.exists(u_file):
        with open(u_file, 'r', encoding='utf-8') as f:
            users_map = json.load(f)
            for email, u in users_map.items():
                cur.execute("""
                INSERT OR REPLACE INTO users (uid, email, full_name, photo_url, password_hash, is_admin, attempted_count, correct_count, incorrect_count, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    u.get('uid', email),
                    email.lower(),
                    u.get('fullName', u.get('name', 'Citizen')),
                    u.get('photoUrl', ''),
                    u.get('passwordHash', ''),
                    1 if u.get('isAdmin', False) else 0,
                    u.get('attemptedCount', 0),
                    u.get('correctCount', 0),
                    u.get('incorrectCount', 0),
                    u.get('createdAt', datetime.utcnow().isoformat()),
                    u.get('updatedAt', datetime.utcnow().isoformat())
                ))
        print(f"[OK] Populated {len(users_map)} registered users in SQLite")

    # Populate Feedbacks
    fb_file = os.path.join(DUMP_DIR, 'feedbacks.json')
    if os.path.exists(fb_file):
        with open(fb_file, 'r', encoding='utf-8') as f:
            feedbacks_data = json.load(f)
            for fb in feedbacks_data:
                cur.execute("""
                INSERT OR REPLACE INTO feedback (id, user_name, user_email, rating, category, message, recipient, timestamp)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    fb.get('id', ''),
                    fb.get('userName', 'Citizen'),
                    fb.get('userEmail', ''),
                    fb.get('rating', 5),
                    fb.get('category', 'General'),
                    fb.get('message', ''),
                    fb.get('recipient', 'jangyan.admin@gmail.com'),
                    fb.get('timestamp', datetime.utcnow().isoformat())
                ))
        print(f"[OK] Populated {len(feedbacks_data)} feedback entries in SQLite")

    # Commit and close
    conn.commit()
    conn.close()
    
    db_size = os.path.getsize(SQLITE_PATH) / (1024 * 1024)
    print(f"[OK] Database successfully compiled and stored at: {SQLITE_PATH} ({db_size:.2f} MB)")
    print("=" * 60)

if __name__ == '__main__':
    build_database()
