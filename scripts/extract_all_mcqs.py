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

def parse_pdf(cat):
    pdf_path = cat['file']
    print(f"Reading {cat['title']} ({os.path.basename(pdf_path)})...")
    reader = pypdf.PdfReader(pdf_path)
    all_text = ""
    for idx, page in enumerate(reader.pages):
        txt = page.extract_text(extraction_mode='layout') or ""
        all_text += f"\n---PAGE_{idx+1}---\n" + txt

    # Split by Question <number>
    # Note: Question can be 'Question 1', 'Question\t1', etc.
    q_blocks = re.split(r'(?i)\bQuestion[\s\t]+(\d+)\b', all_text)
    
    questions = []
    skipped = []

    for i in range(1, len(q_blocks), 2):
        q_num = int(q_blocks[i])
        block = q_blocks[i+1]
        
        # Stop block if page footer or next question
        # Options matching: A. ... B. ... C. ... D. ...
        # Sometimes options have 'A.' or 'A)' or '(A)'
        # Also option letters can have tab or spaces
        opt_match = re.search(
            r'(?:^|\n)\s*(?:\(?A[\.\)]|\bA[\.\)])\s*(.*?)\n\s*(?:\(?B[\.\)]|\bB[\.\)])\s*(.*?)\n\s*(?:\(?C[\.\)]|\bC[\.\)])\s*(.*?)\n\s*(?:\(?D[\.\)]|\bD[\.\)])\s*(.*?)(?=\n\s*(?:Correct\s+Answer|✅\s*Correct\s*Answer|Answer|Short\s+Explanation|💡|Explanation)|$)',
            block,
            re.DOTALL
        )
        
        ans_match = re.search(
            r'(?:Correct\s*Answer|✅\s*Correct\s*Answer|Answer)[:\s\t]*(?:Option[\s\t]*)?\(?([A-D])\)?',
            block,
            re.IGNORECASE
        )
        
        exp_match = re.search(
            r'(?:Short\s*Explanation|Explanation|💡\s*Short\s*Explanation)[:\s\t]*([^\n].*?)(?=\n\s*(?:---PAGE_|Question|\Z))',
            block,
            re.DOTALL | re.IGNORECASE
        )
        
        if opt_match and ans_match:
            q_text = block[:opt_match.start()]
            q_text = re.sub(r'^[❓\s\n\t]+', '', q_text)
            q_text = re.sub(r'JanGyan.*?(?=\n|$)', '', q_text, flags=re.I)
            q_text = clean_text(q_text)
            
            opts = [clean_text(opt_match.group(k)) for k in range(1, 5)]
            ans_letter = ans_match.group(1).upper()
            ans_index = ord(ans_letter) - ord('A')
            
            exp_text = clean_text(exp_match.group(1)) if exp_match else "Official JanGyan verified citizen concept."
            
            # Clean options: remove any trailing page markers
            opts = [re.sub(r'---PAGE_\d+---', '', o).strip() for o in opts]
            
            if q_text and all(len(o) > 0 for o in opts) and 0 <= ans_index <= 3:
                questions.append({
                    'id': q_num,
                    'question': q_text,
                    'options': opts,
                    'answer': ans_index,
                    'explanation': exp_text,
                    'category_id': cat['id'],
                    'category_title': cat['title']
                })
            else:
                skipped.append((q_num, "validation failed", block[:150]))
        else:
            skipped.append((q_num, f"opt={bool(opt_match)}, ans={bool(ans_match)}", block[:150]))
            
    print(f" -> Found {len(questions)} valid questions. Skipped: {len(skipped)}")
    if skipped[:5]:
        print(f"   First skipped examples: {skipped[:3]}")
    return questions

all_parsed = {}
total_count = 0
for cat in categories:
    qs = parse_pdf(cat)
    all_parsed[cat['id']] = qs
    total_count += len(qs)

print(f"\n==========================================")
print(f"TOTAL QUESTIONS EXTRACTED: {total_count}")
print(f"==========================================")
