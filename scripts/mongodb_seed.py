#!/usr/bin/env python3
"""
JanGyan MongoDB Database Seeder & GridFS PDF Storage Script
- Populates Categories, Modules, and 3,000 Verified MCQs
- Uploads all 66 Official Civic Handbooks into MongoDB GridFS
- Exports JSON collections for standalone MongoDB import (mongoimport)
"""

import os
import sys
import json
import glob
from datetime import datetime

try:
    import pymongo
    import gridfs
except ImportError:
    print("Please install pymongo: python -m pip install pymongo")
    sys.exit(1)

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ENV_FILE = os.path.join(BASE_DIR, '.env')

# Default to localhost, or load from .env if MONGODB_URI is specified
MONGO_URI = os.environ.get('MONGODB_URI', 'mongodb://localhost:27017')

if os.path.exists(ENV_FILE):
    with open(ENV_FILE, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if line.startswith('MONGODB_URI='):
                MONGO_URI = line.split('=', 1)[1].strip()

DB_NAME = 'jangyan_db'

def export_json_dumps(categories, all_mcqs, pdf_meta):
    dump_dir = os.path.join(BASE_DIR, 'database', 'mongodb_dump')
    os.makedirs(dump_dir, exist_ok=True)
    
    # 1. Categories
    with open(os.path.join(dump_dir, 'categories.json'), 'w', encoding='utf-8') as f:
        json.dump(categories, f, indent=2, ensure_ascii=False)
        
    # 2. Questions list
    questions_flat = []
    for cat_id, cat_data in all_mcqs.items():
        cat_title = cat_data.get('category_title', cat_id)
        for q in cat_data.get('questions', []):
            item = dict(q)
            item['category_id'] = cat_id
            item['category_title'] = cat_title
            item['created_at'] = datetime.utcnow().isoformat()
            questions_flat.append(item)
            
    with open(os.path.join(dump_dir, 'questions.json'), 'w', encoding='utf-8') as f:
        json.dump(questions_flat, f, indent=2, ensure_ascii=False)
        
    # 3. PDF metadata
    with open(os.path.join(dump_dir, 'pdf_handbooks_metadata.json'), 'w', encoding='utf-8') as f:
        json.dump(pdf_meta, f, indent=2, ensure_ascii=False)
        
    print(f"[Export] Saved JSON dumps in: {dump_dir}")
    print(f"  - categories.json ({len(categories)} records)")
    print(f"  - questions.json ({len(questions_flat)} MCQs)")
    print(f"  - pdf_handbooks_metadata.json ({len(pdf_meta)} handbooks)")

def seed_mongodb():
    print("=" * 60)
    print("JanGyan Citizen Literacy - MongoDB Seeder & GridFS Storage")
    print("=" * 60)
    print(f"Connecting to MongoDB: {MONGO_URI} ...")

    
    # Load metadata and MCQs
    meta_path = os.path.join(BASE_DIR, 'assets', 'data', 'modules_metadata.json')
    mcqs_path = os.path.join(BASE_DIR, 'assets', 'data', 'all_extracted_mcqs.json')
    
    with open(meta_path, 'r', encoding='utf-8') as f:
        categories = json.load(f)
        
    with open(mcqs_path, 'r', encoding='utf-8') as f:
        all_mcqs = json.load(f)
        
    pdf_dir = os.path.join(BASE_DIR, 'assets', 'pdfs')
    pdf_files = [
        os.path.join(pdf_dir, f)
        for f in os.listdir(pdf_dir)
        if f.lower().endswith('.pdf')
    ]
    pdf_metadata = []
    
    for p in pdf_files:
        fn = os.path.basename(p)
        size = os.path.getsize(p)
        pdf_metadata.append({
            'filename': fn,
            'size_bytes': size,
            'size_mb': round(size / (1024 * 1024), 2),
            'local_path': p,
            'stream_url': f'/api/pdf/{fn}',
            'uploaded_at': datetime.utcnow().isoformat()
        })
        
    # Always generate the JSON export dumps
    export_json_dumps(categories, all_mcqs, pdf_metadata)
    
    # Attempt live MongoDB connection
    try:
        client = pymongo.MongoClient(MONGO_URI, serverSelectionTimeoutMS=4000)
        # Test connection
        client.admin.command('ping')
        print(f"✓ Connected to MongoDB successfully!")
    except Exception as e:
        print(f"[Notice] Could not connect to MongoDB server at {MONGO_URI}")
        print(f"   Reason: {e}")
        print(f"   Note: Complete JSON dumps are ready in 'database/mongodb_dump/' for instant import.")
        print(f"   To connect to a live MongoDB instance or free MongoDB Atlas:")
        print(f"   1. Set MONGODB_URI=mongodb+srv://<user>:<password>@cluster.mongodb.net/ in your .env")
        print(f"   2. Run: python scripts/mongodb_seed.py")
        return False

    db = client[DB_NAME]
    fs = gridfs.GridFS(db)
    
    # 1. Seed Categories & Modules
    print("\n1. Seeding Categories & Modules...")
    db.categories.drop()
    db.categories.insert_many(categories)
    db.categories.create_index("id", unique=True)
    print(f"✓ Inserted {db.categories.count_documents({})} categories.")
    
    # 2. Seed Questions
    print("\n2. Seeding 3,000 Authentic MCQs...")
    db.questions.drop()
    questions_to_insert = []
    
    for cat_id, cat_data in all_mcqs.items():
        cat_title = cat_data.get('category_title', cat_id)
        for q in cat_data.get('questions', []):
            doc = {
                'id': q.get('id'),
                'category_id': cat_id,
                'category_title': cat_title,
                'question': q.get('question'),
                'options': q.get('options', []),
                'answer': q.get('answer'),
                'explanation': q.get('explanation', ''),
                'difficulty': q.get('difficulty', 'standard'),
                'source': 'Official Curriculum Handbook',
                'created_at': datetime.utcnow()
            }
            questions_to_insert.append(doc)
            
    if questions_to_insert:
        db.questions.insert_many(questions_to_insert)
        db.questions.create_index("category_id")
        db.questions.create_index("id")
        print(f"✓ Inserted {len(questions_to_insert)} questions across 6 domains.")
        
    # 3. Seed PDFs to GridFS and handbooks collection
    print("\n3. Uploading 66 Handbooks into MongoDB GridFS...")
    # Clear existing GridFS files and handbooks collection
    db.handbooks.drop()
    for f in db['fs.files'].find():
        fs.delete(f['_id'])
        
    uploaded_count = 0
    total_bytes = 0
    handbook_docs = []
    
    for meta in pdf_metadata:
        fn = meta['filename']
        lp = meta['local_path']
        with open(lp, 'rb') as f:
            data = f.read()
            grid_id = fs.put(
                data,
                filename=fn,
                content_type='application/pdf',
                upload_date=datetime.utcnow(),
                size_bytes=len(data)
            )
            uploaded_count += 1
            total_bytes += len(data)
            handbook_docs.append({
                'filename': fn,
                'gridfs_id': str(grid_id),
                'size_bytes': len(data),
                'size_mb': round(len(data) / (1024 * 1024), 2),
                'stream_url': f'/api/pdf/{fn}',
                'uploaded_at': datetime.utcnow()
            })
            
    if handbook_docs:
        db.handbooks.insert_many(handbook_docs)
        db.handbooks.create_index("filename", unique=True)
        
    print(f"✓ Stored {uploaded_count} PDFs in MongoDB GridFS ({total_bytes / (1024*1024):.2f} MB) & created 'handbooks' collection.")
    print("\n" + "=" * 60)
    print("🎉 MongoDB Database Setup Complete for JanGyan!")
    print("=" * 60)
    return True

if __name__ == '__main__':
    seed_mongodb()
