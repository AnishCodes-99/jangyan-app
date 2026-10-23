import pypdf
import re
import json
import os
import sys

sys.stdout.reconfigure(encoding='utf-8')

categories = [
    {
        'id': 'cyber_safety',
        'title': 'Cyber Safety & Digital Security',
        'file': r'E:\Desktop\Jangyan\1-Cyber Safety & Digital Security\JanGyan_CyberSafety_MCQ_Handbook.pdf'
    },
    {
        'id': 'gov_services',
        'title': 'Government Services & Citizen Rights',
        'file': r'E:\Desktop\Jangyan\2-Government Services & Citizen Rights\JanGyan_GovServices_MCQ_Handbook.pdf'
    },
    {
        'id': 'road_safety',
        'title': 'Road Safety & Public Safety',
        'file': r'E:\Desktop\Jangyan\3-Road Safety & Public Safety\JanGyan_Category3_MCQ.pdf'
    },
    {
        'id': 'health_emergency',
        'title': 'Health & Emergency Awareness',
        'file': r'E:\Desktop\Jangyan\4-Health & Emergency Awareness\Jangyan_Catg 04_MCQ.pdf'
    },
    {
        'id': 'financial_literacy',
        'title': 'Financial Literacy & Digital Finance',
        'file': r'E:\Desktop\Jangyan\5-Financial Literacy & Digital Finance\MCQ_Handbook_Financial_Literacy_Digital_Finance.pdf'
    },
    {
        'id': 'environment',
        'title': 'Environment & Civic Responsibility',
        'file': r'E:\Desktop\Jangyan\6-Environment & Civic Responsibility\6_mcq.pdf'
    }
]

def clean_text(text):
    if not text:
        return ""
    text = re.sub(r'[\t\r]+', ' ', text)
    text = re.sub(r' +', ' ', text)
    return text.strip()

def extract_category_questions(pdf_path, max_q=30):
    reader = pypdf.PdfReader(pdf_path)
    all_text = ""
    # Extract from first 40 pages (sufficient for 30+ MCQs)
    num_pages = min(40, len(reader.pages))
    for i in range(num_pages):
        page_txt = reader.pages[i].extract_text(extraction_mode='layout') or ""
        all_text += "\n---PAGE---\n" + page_txt

    questions = []
    
    # Split text by "Question <number>"
    q_blocks = re.split(r'(?i)\bQuestion\s+(\d+)\b', all_text)
    
    for i in range(1, len(q_blocks), 2):
        q_num = q_blocks[i]
        block = q_blocks[i+1]
        
        # Check if block has options
        # Common options pattern: A. ... B. ... C. ... D. ...
        opt_match = re.search(
            r'A[\.\)]\s*(.*?)\n\s*B[\.\)]\s*(.*?)\n\s*C[\.\)]\s*(.*?)\n\s*D[\.\)]\s*(.*?)(?=\n\s*(?:Correct\s+Answer|✅|Answer|Short\s+Explanation)|$)',
            block,
            re.DOTALL
        )
        
        # Check answer pattern
        ans_match = re.search(
            r'(?:Correct\s*Answer|✅\s*Correct\s*Answer)[:\s]*Option\s*\(?([A-D])\)?',
            block,
            re.IGNORECASE
        )
        
        # Check explanation pattern
        exp_match = re.search(
            r'(?:Short\s*Explanation|Explanation|💡\s*Short\s*Explanation)[:\s]*([^\n].*?)(?=\n\s*Question|\n---PAGE---|$)',
            block,
            re.DOTALL | re.IGNORECASE
        )
        
        if opt_match and ans_match:
            q_text = block[:opt_match.start()]
            # clean question text: remove emoji ❓ or leading junk
            q_text = re.sub(r'^[❓\s\n]+', '', q_text).strip()
            # remove headers if any leaked in
            q_text = re.sub(r'JanGyan.*?\n', '', q_text, flags=re.I)
            
            opts = [clean_text(opt_match.group(k)) for k in range(1, 5)]
            ans_letter = ans_match.group(1).upper()
            ans_index = ord(ans_letter) - ord('A')
            
            exp_text = exp_match.group(1).strip() if exp_match else "Official JanGyan verified citizen concept."
            exp_text = clean_text(exp_text)
            
            if len(q_text) > 10 and all(len(o) > 0 for o in opts) and 0 <= ans_index <= 3:
                questions.append({
                    'id': int(q_num) if q_num.isdigit() else len(questions) + 1,
                    'question': clean_text(q_text),
                    'options': opts,
                    'answer': ans_index,
                    'explanation': exp_text
                })
                
        if len(questions) >= max_q:
            break
            
    return questions

results = {}
for cat in categories:
    print(f"Extracting for {cat['title']}...")
    qs = extract_category_questions(cat['file'], max_q=25)
    print(f" -> Found {len(qs)} questions")
    results[cat['title']] = qs

with open(r'E:\Desktop\Jangyan\parsed_questions.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)

print("Saved to E:\\Desktop\\Jangyan\\parsed_questions.json")
