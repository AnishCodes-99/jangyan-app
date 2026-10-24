import json, os, re, sqlite3

leak_regex = re.compile(
    r'[\s\u2705\u2714\u2611\u2704]*Correct\s*(?:Answer|Option)\s*:\s*Option\s*\(?[A-D]\)?[\s\S]*$',
    re.IGNORECASE
)

def clean_text(s):
    if not isinstance(s, str):
        return s
    return leak_regex.sub('', s).strip()

def clean_question_obj(q):
    options = q.get('options', [])
    new_options = [clean_text(opt) for opt in options]
    q['options'] = new_options
    return q

# 1. Clean assets/data/all_extracted_mcqs.json
p1 = 'assets/data/all_extracted_mcqs.json'
if os.path.exists(p1):
    with open(p1, 'r', encoding='utf-8') as f:
        data = json.load(f)
    cleaned_count = 0
    for cat_id, cat_data in data.items():
        for q in cat_data.get('questions', []):
            clean_question_obj(q)
            cleaned_count += 1
    with open(p1, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"Cleaned {cleaned_count} questions in {p1}")

# 2. Clean all_extracted_mcqs.json (root)
p2 = 'all_extracted_mcqs.json'
if os.path.exists(p2):
    with open(p2, 'r', encoding='utf-8') as f:
        data = json.load(f)
    cleaned_count = 0
    for cat_id, cat_data in data.items():
        for q in cat_data.get('questions', []):
            clean_question_obj(q)
            cleaned_count += 1
    with open(p2, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"Cleaned {cleaned_count} questions in {p2}")

# 3. Clean assets/data/mcqs/*.json
mcqs_dir = 'assets/data/mcqs'
if os.path.exists(mcqs_dir):
    for fn in os.listdir(mcqs_dir):
        if fn.endswith('.json'):
            fp = os.path.join(mcqs_dir, fn)
            with open(fp, 'r', encoding='utf-8') as f:
                cat_data = json.load(f)
            for q in cat_data.get('questions', []):
                clean_question_obj(q)
            with open(fp, 'w', encoding='utf-8') as f:
                json.dump(cat_data, f, ensure_ascii=False, indent=2)
            print(f"Cleaned {fp}")

# 4. Clean database/mongodb_dump/questions.json
p4 = 'database/mongodb_dump/questions.json'
if os.path.exists(p4):
    with open(p4, 'r', encoding='utf-8') as f:
        data = json.load(f)
    cleaned_count = 0
    for q in data:
        clean_question_obj(q)
        cleaned_count += 1
    with open(p4, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"Cleaned {cleaned_count} questions in {p4}")

# 5. Clean parsed_questions.json if exists
p5 = 'parsed_questions.json'
if os.path.exists(p5):
    with open(p5, 'r', encoding='utf-8') as f:
        data = json.load(f)
    if isinstance(data, list):
        for q in data:
            clean_question_obj(q)
    elif isinstance(data, dict):
        for k, v in data.items():
            if isinstance(v, list):
                for q in v: clean_question_obj(q)
            elif isinstance(v, dict):
                for q in v.get('questions', []): clean_question_obj(q)
    with open(p5, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"Cleaned {p5}")

# 6. Clean questions.js and website/questions.js
for js_path in ['questions.js', 'website/questions.js']:
    if os.path.exists(js_path):
        with open(js_path, 'r', encoding='utf-8') as f:
            content = f.read()
        start_idx = content.find('{')
        end_idx = content.rfind('};')
        if start_idx != -1 and end_idx != -1:
            json_str = content[start_idx : end_idx + 1]
            try:
                js_data = json.loads(json_str)
                for cat_title, q_list in js_data.items():
                    for q in q_list:
                        clean_question_obj(q)
                new_content = content[:start_idx] + json.dumps(js_data, ensure_ascii=False, indent=2) + content[end_idx+1:]
                with open(js_path, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print(f"Cleaned {js_path}")
            except Exception as e:
                print(f"Error parsing JSON in {js_path}: {e}")

# 7. Clean SQLite database database/jangyan.db
db_path = 'database/jangyan.db'
if os.path.exists(db_path):
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    cur.execute("SELECT id, options_json, correct_answer_index FROM questions")
    rows = cur.fetchall()
    updated = 0
    for q_id, opt_json, ans in rows:
        try:
            opts = json.loads(opt_json)
            cleaned_opts = [clean_text(opt) for opt in opts]
            if cleaned_opts != opts:
                cur.execute(
                    "UPDATE questions SET options_json = ? WHERE id = ?",
                    (json.dumps(cleaned_opts, ensure_ascii=False), q_id)
                )
                updated += 1
        except Exception as e:
            pass
    conn.commit()
    conn.close()
    print(f"Cleaned {updated} records in SQLite {db_path}")

print("ALL FILES AND DATABASES CLEANED!")
