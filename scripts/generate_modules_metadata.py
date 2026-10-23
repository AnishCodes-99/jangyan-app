import pymupdf
import glob
import os
import re
import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

category_configs = [
    {
        'id': 'cyber_safety',
        'title': 'Cyber Safety & Digital Security',
        'tagline': 'Phishing, OTP protection, Cyber Helpline 1930 & DPDP Act',
        'color': '#0284C7',
        'icon': 'security',
        'dir': r'E:\Desktop\Jangyan\1-Cyber Safety & Digital Security',
        'mcq_pdf': 'JanGyan_CyberSafety_MCQ_Handbook.pdf'
    },
    {
        'id': 'gov_services',
        'title': 'Government Services & Schemes',
        'tagline': 'Constitution, RTI, DigiLocker, CPGRAMS & Citizen Rights',
        'color': '#2563EB',
        'icon': 'account_balance',
        'dir': r'E:\Desktop\Jangyan\2-Government Services & Citizen Rights',
        'mcq_pdf': 'JanGyan_GovServices_MCQ_Handbook.pdf'
    },
    {
        'id': 'road_safety',
        'title': 'Traffic Rules & Road Safety',
        'tagline': 'Motor Vehicles Act, Good Samaritan Law & Golden Hour protocols',
        'color': '#D97706',
        'icon': 'traffic',
        'dir': r'E:\Desktop\Jangyan\3-Road Safety & Public Safety',
        'mcq_pdf': 'JanGyan_Category3_MCQ.pdf'
    },
    {
        'id': 'health_emergency',
        'title': 'Health & Emergency Awareness',
        'tagline': 'Emergency 112, First Aid, CPR, Ayushman Bharat & NCDs',
        'color': '#DC2626',
        'icon': 'local_hospital',
        'dir': r'E:\Desktop\Jangyan\4-Health & Emergency Awareness',
        'mcq_pdf': 'Jangyan_Catg 04_MCQ.pdf'
    },
    {
        'id': 'financial_literacy',
        'title': 'Financial Literacy & Digital Payments',
        'tagline': 'Safe UPI, 50-30-20 Rule, CIBIL, EPF/NPS & Fraud Prevention',
        'color': '#059669',
        'icon': 'payments',
        'dir': r'E:\Desktop\Jangyan\5-Financial Literacy & Digital Finance',
        'mcq_pdf': 'MCQ_Handbook_Financial_Literacy_Digital_Finance.pdf'
    },
    {
        'id': 'environment',
        'title': 'Environmental Responsibility',
        'tagline': 'Waste segregation, Plastic ban, AQI, Energy & Civic duties',
        'color': '#16A34A',
        'icon': 'eco',
        'dir': r'E:\Desktop\Jangyan\6-Environment & Civic Responsibility',
        'mcq_pdf': '6_mcq.pdf'
    }
]

def clean_text(s):
    if not s:
        return ""
    s = re.sub(r'[\t\r\n]+', ' ', s)
    s = re.sub(r' +', ' ', s)
    return s.strip()

def get_module_num(fname):
    m = re.search(r'(?:M|Module|module)[\s_]*(\d+)', fname, re.I)
    if m:
        return int(m.group(1))
    # fallback check for standalone numbers
    m2 = re.search(r'(\d+)', fname)
    if m2:
        return int(m2.group(1))
    return 99

all_categories = []

for cfg in category_configs:
    d = cfg['dir']
    pdf_files = [f for f in os.listdir(d) if f.lower().endswith('.pdf') and 'mcq' not in f.lower()]
    pdf_files.sort(key=lambda x: get_module_num(x))
    
    modules = []
    for f in pdf_files:
        mod_num = get_module_num(f)
        full_path = os.path.join(d, f)
        doc = pymupdf.open(full_path)
        pages_count = len(doc)
        
        # Extract title from first page
        first_page_text = doc[0].get_text()
        lines = [clean_text(line) for line in first_page_text.split('\n') if len(clean_text(line)) > 3]
        
        # Filter headers like JanGyan or module number
        candidate_titles = []
        for l in lines[:10]:
            if not re.search(r'JanGyan|Page|Handbook|Category|Module\s*\d+', l, re.I):
                candidate_titles.append(l)
                
        title = candidate_titles[0] if candidate_titles else f"Module {mod_num}"
        subtitle = candidate_titles[1] if len(candidate_titles) > 1 else f"Essential citizen learning module {mod_num}"
        
        modules.append({
            'module_number': mod_num,
            'title': title,
            'subtitle': subtitle,
            'file_name': f,
            'relative_path': os.path.join(os.path.basename(d), f).replace('\\', '/'),
            'pages': pages_count
        })
        
    all_categories.append({
        'id': cfg['id'],
        'title': cfg['title'],
        'tagline': cfg['tagline'],
        'color': cfg['color'],
        'icon': cfg['icon'],
        'folder': os.path.basename(d),
        'mcq_pdf': cfg['mcq_pdf'],
        'mcq_relative_path': os.path.join(os.path.basename(d), cfg['mcq_pdf']).replace('\\', '/'),
        'module_count': len(modules),
        'modules': modules
    })
    print(f"Generated metadata for {cfg['title']}: {len(modules)} modules")

output_file = r'E:\Desktop\Jangyan\modules_metadata.json'
with open(output_file, 'w', encoding='utf-8') as f:
    json.dump(all_categories, f, ensure_ascii=False, indent=2)

print(f"\nMetadata saved to {output_file}")
