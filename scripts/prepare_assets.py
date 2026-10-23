import os
import shutil
import json

os.makedirs(r'E:\Desktop\Jangyan\assets\images', exist_ok=True)
os.makedirs(r'E:\Desktop\Jangyan\assets\data\mcqs', exist_ok=True)

# Copy logo
shutil.copyfile(r'E:\Desktop\Jangyan\JanGyan Logo.png', r'E:\Desktop\Jangyan\assets\images\logo.png')
print("Copied JanGyan Logo.png to assets/images/logo.png")

# Copy all extracted mcqs
shutil.copyfile(r'E:\Desktop\Jangyan\all_extracted_mcqs.json', r'E:\Desktop\Jangyan\assets\data\all_extracted_mcqs.json')
print("Copied all_extracted_mcqs.json to assets/data/all_extracted_mcqs.json")

# Split by category
with open(r'E:\Desktop\Jangyan\all_extracted_mcqs.json', encoding='utf-8') as f:
    data = json.load(f)

for cat_id, cat_obj in data.items():
    cat_path = os.path.join(r'E:\Desktop\Jangyan\assets\data\mcqs', f"{cat_id}.json")
    with open(cat_path, 'w', encoding='utf-8') as cf:
        json.dump(cat_obj, cf, ensure_ascii=False, indent=2)
    print(f"Saved {cat_obj['count']} MCQs for {cat_id} to {cat_path}")

print("Assets preparation completed!")
