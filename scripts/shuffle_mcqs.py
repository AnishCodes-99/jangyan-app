import json
import random
import sqlite3
import os

def shuffle_all_mcqs():
    # Load all_extracted_mcqs.json
    with open('assets/data/all_extracted_mcqs.json', 'r', encoding='utf-8') as f:
        all_data = json.load(f)

    # Use a deterministic seed so results are reproducible and clean
    rng = random.Random(42)

    total_shuffled = 0
    cat_stats = {}

    for cat_idx, (cat_key, cat_obj) in enumerate(all_data.items()):
        questions = cat_obj.get('questions', [])
        counts = {0: 0, 1: 0, 2: 0, 3: 0}

        for q_idx, q in enumerate(questions):
            orig_ans_idx = q['answer']
            options = list(q['options'])
            if orig_ans_idx < 0 or orig_ans_idx >= len(options):
                orig_ans_idx = 0
            correct_text = options[orig_ans_idx]

            # Collect the other 3 distractors
            distractors = [opt for i, opt in enumerate(options) if i != orig_ans_idx]
            rng.shuffle(distractors)

            # Balanced target distribution: 0, 1, 2, 3 across questions
            target_idx = (q_idx + cat_idx) % len(options)

            # Reconstruct options
            new_options = []
            distractor_iter = iter(distractors)
            for i in range(len(options)):
                if i == target_idx:
                    new_options.append(correct_text)
                else:
                    new_options.append(next(distractor_iter))

            # Verify
            assert new_options[target_idx] == correct_text, f"Mismatch in {q['id']}"

            q['options'] = new_options
            q['answer'] = target_idx
            counts[target_idx] += 1
            total_shuffled += 1

        cat_stats[cat_key] = counts
        print(f"Category {cat_key}: A={counts[0]}, B={counts[1]}, C={counts[2]}, D={counts[3]}")

    print(f"\nTotal questions successfully shuffled: {total_shuffled}")

    # 1. Save assets/data/all_extracted_mcqs.json
    with open('assets/data/all_extracted_mcqs.json', 'w', encoding='utf-8') as f:
        json.dump(all_data, f, indent=2, ensure_ascii=False)
    print("Saved assets/data/all_extracted_mcqs.json")

    # 2. Save root all_extracted_mcqs.json
    with open('all_extracted_mcqs.json', 'w', encoding='utf-8') as f:
        json.dump(all_data, f, indent=2, ensure_ascii=False)
    print("Saved all_extracted_mcqs.json")

    # 3. Save assets/data/mcqs/<cat>.json
    for cat_key, cat_obj in all_data.items():
        cat_file = f'assets/data/mcqs/{cat_key}.json'
        with open(cat_file, 'w', encoding='utf-8') as f:
            json.dump(cat_obj, f, indent=2, ensure_ascii=False)
        print(f"Saved {cat_file}")

    # 4. Save database/mongodb_dump/questions.json
    # Flatten questions list
    mongo_questions = []
    for cat_key, cat_obj in all_data.items():
        for q in cat_obj.get('questions', []):
            mongo_questions.append({
                'id': q['id'],
                'question': q['question'],
                'options': q['options'],
                'answer': q['answer'],
                'explanation': q.get('explanation', ''),
                'category_id': q.get('category_id', cat_key),
                'category_title': q.get('category_title', cat_obj.get('title', '')),
                'created_at': '2026-10-24T00:00:00.000Z'
            })
    with open('database/mongodb_dump/questions.json', 'w', encoding='utf-8') as f:
        json.dump(mongo_questions, f, indent=2, ensure_ascii=False)
    print("Saved database/mongodb_dump/questions.json")

    # 5. Update SQLite database/jangyan.db
    if os.path.exists('database/jangyan.db'):
        con = sqlite3.connect('database/jangyan.db')
        cur = con.cursor()
        for q in mongo_questions:
            cur.execute("""
                UPDATE questions
                SET options_json = ?, correct_answer_index = ?
                WHERE id = ? OR (category_id = ? AND question = ?)
            """, (json.dumps(q['options'], ensure_ascii=False), q['answer'], str(q['id']), q['category_id'], q['question']))
        con.commit()
        con.close()
        print("Updated database/jangyan.db SQLite table 'questions'")

    # 6. Update questions.js and website/questions.js
    # Map category title to questions
    js_cats = {}
    for cat_key, cat_obj in all_data.items():
        title = cat_obj.get('title', cat_key)
        js_cats[title] = cat_obj.get('questions', [])

    js_content = "/**\n * JanGyan Official Question Bank\n * Extracted from official category handbooks\n */\nconst jangyanQuestions = " + json.dumps(js_cats, indent=2, ensure_ascii=False) + ";\n\nif (typeof module !== 'undefined' && module.exports) {\n  module.exports = jangyanQuestions;\n}\n"
    with open('questions.js', 'w', encoding='utf-8') as f:
        f.write(js_content)
    with open('website/questions.js', 'w', encoding='utf-8') as f:
        f.write(js_content)
    print("Saved questions.js and website/questions.js")

    # 7. Update parsed_questions.json if present
    if os.path.exists('parsed_questions.json'):
        with open('parsed_questions.json', 'w', encoding='utf-8') as f:
            json.dump(all_data, f, indent=2, ensure_ascii=False)
        print("Saved parsed_questions.json")

if __name__ == '__main__':
    shuffle_all_mcqs()
