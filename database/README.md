# JanGyan Database Architecture & Storage Documentation

The JanGyan Civic Literacy & Digital Citizen Empowerment Platform utilizes a resilient **Multi-Tier Database Architecture** ensuring zero-downtime, offline-first reliability, and live cloud synchronization.

---

## 1. Multi-Tier Storage Overview

```
                      +-----------------------------------+
                      |        JanGyan Web & Mobile       |
                      +-----------------------------------+
                                        |
       +--------------------------------+--------------------------------+
       |                                |                                |
+------v------+                  +------v------+                  +------v------+
|   Tier 1    |                  |   Tier 2    |                  |   Tier 3    |
|  Firebase   |                  |   Project   |                  |   MongoDB   |
|  Firestore  |                  |   SQLite    |                  |   GridFS    |
| (Cloud DB)  |                  |  (Local DB) |                  | (Docs & PDF)|
+-------------+                  +-------------+                  +-------------+
  Project ID:                      File:                            Dump:
  jangyan-e2608                    database/jangyan.db              database/mongodb_dump/
  Region: asia-south1              Tables: 6                        Files: 66 Handbooks
```

---

## 2. Tier 1: Firebase Cloud Firestore

- **Project ID**: `jangyan-e2608`
- **Location**: `asia-south1` (Mumbai, India)
- **Status**: Live and verified
- **Web App ID**: `1:827728772517:web:adf8753a8793d6cd97fc4c`
- **Primary Collections**:
  - `users`: Citizen profiles (UID, Name, Email, photoUrl, test scores, admin role).
  - `quizProgress`: Exam attempts, domain performance, and completion records.
  - `feedback`: Citizen reviews and rating submissions dispatched to administrators.
  - `categories` & `questions`: Standardized civic learning syllabus.
- **Security Rules**: Deployed via `firestore.rules` allowing read/write operations across JanGyan collections.

---

## 3. Tier 2: Project SQLite Relational Database

Stored directly in the project repository at:
`database/jangyan.db` (1.73 MB, WAL Mode Enabled)

### Relational Tables & Schema:
1. `categories` (6 Primary Civic Domains):
   - `id` (TEXT PRIMARY KEY)
   - `title`, `description`, `icon`, `color`, `modules_count`, `questions_count`
2. `handbooks` (66 Official Civic Handbooks):
   - `filename` (TEXT PRIMARY KEY)
   - `category_id`, `title`, `size_bytes`, `size_mb`, `stream_url`, `local_path`
3. `questions` (3,000 Verified MCQs):
   - `id` (TEXT PRIMARY KEY, e.g. `catg_01_1`)
   - `category_id`, `category_title`, `question`, `options_json`, `correct_answer_index`, `explanation`, `difficulty`
4. `users` (Registered Citizens & Administrators):
   - `uid` (TEXT PRIMARY KEY), `email`, `full_name`, `photo_url`, `password_hash`, `is_admin`, `attempted_count`, `correct_count`, `incorrect_count`, `created_at`, `updated_at`
5. `quiz_progress` (Citizen Assessment Logs):
   - `id` (TEXT PRIMARY KEY), `user_id`, `category_id`, `score`, `total_questions`, `percentage`, `completed_at`
6. `feedback` (User Reviews):
   - `id` (TEXT PRIMARY KEY), `user_name`, `user_email`, `rating`, `category`, `message`, `recipient`, `timestamp`

---

## 4. Tier 3: MongoDB & GridFS Document Store

- **REST Service**: `backend/mongodb_api.py` running on port `5001`.
- **JSON Dumps** (`database/mongodb_dump/`):
  - `categories.json`
  - `questions.json` (3,000 questions, 2.1 MB)
  - `pdf_handbooks_metadata.json` (66 handbooks mapped)
  - `users.json` (Synced citizen accounts)
  - `feedbacks.json` (User feedback logs)
- **Connecting MongoDB Atlas (Cloud Cluster)**:
  Add your connection string to `.env`:
  ```env
  MONGODB_URI=mongodb+srv://<username>:<password>@cluster0.mongodb.net/?retryWrites=true&w=majority
  ```
  Then run:
  ```bash
  python scripts/mongodb_seed.py
  ```
  The script will automatically upload all 66 handbooks into MongoDB GridFS and populate collections.

---

## 5. Maintenance & Sync Scripts

- Rebuild project SQLite database:
  ```bash
  python scripts/build_project_database.py
  ```
- Seed MongoDB & Export NoSQL Dumps:
  ```bash
  python scripts/mongodb_seed.py
  ```
- Start MongoDB REST API:
  ```bash
  python backend/mongodb_api.py 5001
  ```
- Health Check:
  ```bash
  curl http://127.0.0.1:5001/api/health
  ```
