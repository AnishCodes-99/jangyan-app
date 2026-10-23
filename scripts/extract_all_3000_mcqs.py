import pymupdf
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

def extract_from_category(cat):
    doc = pymupdf.open(cat['file'])
    print(f"\nProcessing {cat['title']} ({len(doc)} pages)...", flush=True)
    
    # Collect all text in visual y-sorted order
    full_text = ""
    for page_idx, page in enumerate(doc):
        blocks = page.get_text('blocks')
        # Filter top headers and bottom footers
        body_blocks = [b for b in blocks if 40 <= b[1] <= 795]
        body_blocks.sort(key=lambda b: b[1])
        page_str = "\n".join(b[4].strip() for b in body_blocks if b[4].strip())
        full_text += f"\n---PAGE_{page_idx+1}---\n" + page_str

    # Split by Question headers
    # Matches 'Question 1', 'Question\n1', etc.
    q_splits = re.split(r'(?i)\bQuestion[\s\n\t]+(\d+)\b', full_text)
    
    questions = []
    skipped = []

    for i in range(1, len(q_splits), 2):
        q_num = int(q_splits[i])
        block = q_splits[i+1]
        
        # In Road Safety and others, option letter might be on line before or after option text
        # e.g.:
        # Option text\nA. or A.\nOption text or A. Option text
        # Let's find answer first
        ans_match = re.search(
            r'(?:Correct\s*Answer|✅\s*Correct\s*Answer|Answer)[:\s\t]*(?:Option[\s\t]*)?\(?([A-D])\)?',
            block,
            re.IGNORECASE
        )
        
        # Explanation
        exp_match = re.search(
            r'(?:Short\s*Explanation|Explanation|💡\s*Short\s*Explanation)[:\s\t]*([^\n].*?)(?=\n\s*(?:---PAGE_|\Z))',
            block,
            re.DOTALL | re.IGNORECASE
        )
        exp_text = clean_text(exp_match.group(1)) if exp_match else "Official JanGyan verified citizen concept."

        # Find Options: A, B, C, D
        # Case 1: Standard 'A. ... B. ... C. ... D. ...'
        opt_match = re.search(
            r'(?:^|\n)\s*(?:\(?A[\.\)]|\bA[\.\)])\s*(.*?)\n\s*(?:\(?B[\.\)]|\bB[\.\)])\s*(.*?)\n\s*(?:\(?C[\.\)]|\bC[\.\)])\s*(.*?)\n\s*(?:\(?D[\.\)]|\bD[\.\)])\s*(.*?)(?=\n\s*(?:Correct\s+Answer|✅|Answer|Short\s+Explanation|💡|Explanation)|$)',
            block,
            re.DOTALL
        )
        
        # Case 2: In some blocks (like Category 3), option text is followed by line with 'A.', etc.
        # e.g.:
        # The Right of Way principle\nA.\nThe Safe System...\nB.
        if not opt_match:
            opt_match2 = re.search(
                r'(.*?)\n\s*A[\.\)]\s*\n\s*(.*?)\n\s*B[\.\)]\s*\n\s*(.*?)\n\s*C[\.\)]\s*\n\s*(.*?)\n\s*D[\.\)]',
                block,
                re.DOTALL
            )
            if opt_match2:
                opts = [clean_text(opt_match2.group(k)) for k in range(1, 5)]
                q_text = block[:opt_match2.start()]
            else:
                opts = None
                q_text = ""
        else:
            opts = [clean_text(opt_match.group(k)) for k in range(1, 5)]
            q_text = block[:opt_match.start()]

        if opts and ans_match:
            # Clean q_text
            q_text = re.sub(r'^[❓\s\n\t]+', '', q_text)
            q_text = re.sub(r'JanGyan.*?(?=\n|$)', '', q_text, flags=re.I)
            q_text = re.sub(r'---PAGE_\d+---', '', q_text)
            q_text = clean_text(q_text)
            
            ans_letter = ans_match.group(1).upper()
            ans_index = ord(ans_letter) - ord('A')
            
            # Clean opts
            opts = [re.sub(r'---PAGE_\d+---', '', o).strip() for o in opts]
            
            if q_text and len(opts) == 4 and all(len(o) > 0 for o in opts) and 0 <= ans_index <= 3:
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
                skipped.append((q_num, "validation", block[:100]))
        else:
            skipped.append((q_num, f"opt={bool(opts)}, ans={bool(ans_match)}", block[:100]))

    print(f" -> Successfully extracted {len(questions)} MCQs. (Skipped: {len(skipped)})", flush=True)
    if skipped:
        print(f"    Sample skipped: {skipped[:3]}", flush=True)
    return questions

all_categories_data = {}
total_mcqs = 0

for cat in categories:
    qs = extract_from_category(cat)
    all_categories_data[cat['id']] = {
        'id': cat['id'],
        'title': cat['title'],
        'count': len(qs),
        'questions': qs
    }
    total_mcqs += len(qs)

output_path = r'E:\Desktop\Jangyan\all_extracted_mcqs.json'
with open(output_path, 'w', encoding='utf-8') as f:
    json.dump(all_categories_data, f, ensure_ascii=False, indent=2)

print(f"\n==========================================")
print(f"FINISHED: Extracted {total_mcqs} total MCQs!")
print(f"Saved to {output_path}")
print(f"==========================================")
