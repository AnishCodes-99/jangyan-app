import os
import json

module_titles = {
    'cyber_safety': [
        ('Introduction to Cyber Security', 'Core principles, cyber threats, and digital safety for Indian citizens'),
        ('Digital Identity & Privacy', 'Protecting personal data, Aadhaar security, and the DPDP Act 2023'),
        ('Password & Authentication', 'Strong password formulas, 2FA/MFA, and biometric safety'),
        ('Banking & Payment Security', 'Safe UPI practices, PIN confidentiality, and debit/credit card protection'),
        ('Online Scams & Social Engineering', 'Detecting phishing, lottery scams, deepfakes, and sextortion traps'),
        ('Social Media Safety', 'Privacy settings, impersonation defense, and cyberbullying prevention'),
        ('Device Security', 'Securing smartphones, computers, public Wi-Fi risks, and malware avoidance'),
        ('Safe Internet Usage', 'Safe browsing, encrypted websites (HTTPS), and secure downloads'),
        ('Reporting Cyber Crime', 'National Helpline 1930, cybercrime.gov.in, and the golden hour recovery'),
        ('Daily Cyber Safety Checklist', 'Actionable morning-to-night security habits for every citizen')
    ],
    'gov_services': [
        ('Understanding the Indian Government', 'Constitution, democratic pillars, executive, legislature, and judiciary'),
        ('Citizen Identity & Essential Documents', 'Aadhaar, PAN card, Voter ID, Passport, and Ration card issuance'),
        ('Digital Government Services', 'DigiLocker legal validity (Rule 9A), UMANG portal, and mAadhaar'),
        ('Citizen Rights & Responsibilities', 'Fundamental Rights (Part III), RTI Act 2005, and Fundamental Duties'),
        ('Government Welfare Schemes', 'DBT benefits, PM Kisan, PMAY, and social welfare subsidies'),
        ('Public Services & Utilities', 'Electricity, water, municipal corporations, and online bill payments'),
        ('Emergency & Public Support Services', 'National helplines, disaster relief portals, and legal aid services'),
        ('Government Grievance Systems', 'CPGRAMS (pgportal.gov.in) and citizen charter dispute escalation'),
        ('Elections & Democratic Participation', 'Voter registration (NVSP/Voter Helpline app) and polling etiquette'),
        ('Smart Citizen Guide', 'Checklist of citizen entitlements, civil rights, and public duties')
    ],
    'road_safety': [
        ('Fundamentals of Road Safety', 'Global road safety principles, Vision Zero, and safe system design'),
        ('Traffic Rules & Regulations', 'Right-of-way, lane discipline, overtaking norms, and zebra crossings'),
        ('Traffic Signs & Road Symbols', 'Mandatory, cautionary, and informatory signboards in India'),
        ('Safe Driving Practices', 'Speed management, defensive driving, safe following distances, and night driving'),
        ('Two-Wheeler & Four-Wheeler Safety', 'ISI-certified helmet mandates, seatbelt science, and vehicle maintenance'),
        ('Pedestrian & Public Transport Safety', 'Sidewalk safety, boarding precautions, and vulnerable road users'),
        ('Emergency Response & Accident Management', 'The Good Samaritan Law (Sec 134A) and the Golden Hour survival protocols'),
        ('Traffic Laws & Legal Awareness', 'Motor Vehicles (Amendment) Act 2019, compoundable offences, and e-Challan'),
        ('Modern Road Safety & Smart Mobility', 'Intelligent traffic systems, dashcams, and electronic enforcement cameras'),
        ('Responsible Road Citizen Checklist', 'Pre-trip safety routine, emergency kit checklist, and driver pledge')
    ],
    'health_emergency': [
        ('Fundamentals of Health & Well-Being', 'Preventive healthcare, sanitation, clean drinking water, and immunization'),
        ('First Aid Essentials', 'Bleeding control, burn treatment, fracture stabilization, and the recovery position'),
        ('Medical Emergencies & CPR', 'Hands-only Cardiopulmonary Resuscitation (30:2 ratio) and choking relief'),
        ('Disaster & Emergency Preparedness', 'Dial 112 unified response, earthquake drills, and household emergency kits'),
        ('Communicable & Lifestyle Diseases', 'Screening for silent NCDs (hypertension, diabetes) and vector-borne diseases'),
        ('Mental Health & Emotional Well-Being', 'Stress management, destigmatizing therapy, and Tele-MANAS helpline 14416'),
        ('Nutrition & Healthy Living', 'Eat Right India, balanced regional diets, and physical exercise routines'),
        ('Women, Child & Senior Citizen Health', 'Maternal health (Janani Suraksha), Poshan Abhiyaan, and geriatric care'),
        ('Healthcare Services & Medical Rights', 'Ayushman Bharat PM-JAY (₹5 Lakh cover) and patient rights charters'),
        ('Healthy Citizen Checklist', 'Annual health checkup timetable, medicine storage, and emergency medical contacts')
    ],
    'financial_literacy': [
        ('Fundamentals of Financial Literacy', 'Understanding money, inflation, compounding interest, and financial goals'),
        ('Banking & Financial Services', 'Savings vs current accounts, PM Jan Dhan Yojana, and fixed/recurring deposits'),
        ('Digital Payments & Cashless Economy', 'UPI QR mechanics, BHIM app, AEPS, and safe online payment workflows'),
        ('Saving, Budgeting & Money Management', 'The 50-30-20 budgeting rule, emergency funds, and expense tracking'),
        ('Investment Fundamentals', 'Mutual funds, SIPs, gold bonds, index funds, and stock market basics'),
        ('Insurance & Retirement Planning', 'Term life insurance, health policies, NPS, and Atal Pension Yojana (APY)'),
        ('Loans, Credit & Taxation', 'Credit score (CIBIL > 750), home/education loans, and basic income tax slabs'),
        ('Financial Fraud Prevention', 'Detecting Ponzi schemes, unauthorized loan apps, and SEBI/RBI investor safeguards'),
        ('Government Financial Schemes', 'Sukanya Samriddhi Yojana, Stand-Up India, Mudra loans, and PMJJBY/PMSBY'),
        ('Smart Financial Citizen Checklist', 'Financial health score card, annual insurance review, and retirement roadmap')
    ],
    'environment': [
        ('Fundamentals of Environment & Sustainability', 'Ecosystem balance, carbon footprint, and Article 51A(g) environmental duties'),
        ('Waste Management & Cleanliness', 'Three-bin segregation (Green Wet, Blue Dry, Red Hazardous) and Swachh Bharat'),
        ('Water Conservation & Management', 'Rainwater harvesting, tap aeration, Jal Jeevan Mission, and greywater reuse'),
        ('Air Quality & Pollution Control', 'Air Quality Index (AQI categories), smog protection, and vehicular emission norms'),
        ('Energy Conservation & Renewable Energy', 'LED adoption, star rating appliances, PM Surya Ghar (Rooftop Solar)'),
        ('Climate Change & Disaster Awareness', 'Extreme weather readiness, urban flooding response, and heatwave survival'),
        ('Biodiversity & Wildlife Conservation', 'Native trees, urban birds, Wildlife Protection Act, and preventing cruelty to animals'),
        ('Civic Responsibility & Public Property', 'Protecting heritage, public transport ethics, and anti-littering civic laws'),
        ('Green Lifestyle & Sustainable Living', 'Single-use plastic alternatives, composting kitchen waste, and circular economy'),
        ('Smart Green Citizen Checklist', 'Eco-friendly household audit, tree plantation pledge, and community cleanliness action')
    ]
}

categories_config = [
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
        'title': 'Government Services & Citizen Rights',
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

def get_module_num(fname):
    import re
    m = re.search(r'(?:M|Module|module)[\s_]*(\d+)', fname, re.I)
    if m:
        return int(m.group(1))
    m2 = re.search(r'(\d+)', fname)
    if m2:
        return int(m2.group(1))
    return 99

full_metadata = []

for cfg in categories_config:
    cid = cfg['id']
    d = cfg['dir']
    pdf_files = [f for f in os.listdir(d) if f.lower().endswith('.pdf') and 'mcq' not in f.lower()]
    pdf_files.sort(key=lambda x: get_module_num(x))
    
    modules = []
    titles_list = module_titles[cid]
    
    for idx, f in enumerate(pdf_files):
        mod_num = get_module_num(f)
        title, subtitle = titles_list[idx] if idx < len(titles_list) else (f"Module {mod_num}", "Learning module")
        
        modules.append({
            'module_number': mod_num,
            'title': title,
            'subtitle': subtitle,
            'file_name': f,
            'relative_path': f"{os.path.basename(d)}/{f}",
            'category_id': cid,
            'category_title': cfg['title']
        })
        
    full_metadata.append({
        'id': cid,
        'title': cfg['title'],
        'tagline': cfg['tagline'],
        'color': cfg['color'],
        'icon': cfg['icon'],
        'folder': os.path.basename(d),
        'mcq_pdf': cfg['mcq_pdf'],
        'mcq_relative_path': f"{os.path.basename(d)}/{cfg['mcq_pdf']}",
        'module_count': len(modules),
        'modules': modules
    })

os.makedirs(r'E:\Desktop\Jangyan\assets\data', exist_ok=True)
with open(r'E:\Desktop\Jangyan\modules_metadata.json', 'w', encoding='utf-8') as f:
    json.dump(full_metadata, f, ensure_ascii=False, indent=2)

with open(r'E:\Desktop\Jangyan\assets\data\modules_metadata.json', 'w', encoding='utf-8') as f:
    json.dump(full_metadata, f, ensure_ascii=False, indent=2)

print("Saved verified modules_metadata.json to root and assets/data!")
