# JanGyan – Learn Without Limits 🇮🇳
**The Definitive Civic Literacy & E-Learning Mobile Application for Indian Citizens**

---

## 🏛️ Executive Overview
JanGyan is a production-grade, Material Design 3 mobile application engineered in Flutter & Dart. It delivers structured civic education across six critical domains of everyday Indian life, backed by 60 official learning handbooks and an authentic question bank of 3,000 verified multiple-choice questions (exactly 500 per domain) extracted directly from official state and national curricula.

### 🌟 Official Tagline
> **Learn Without Limits.**

---

## 📚 Educational Domains & Handbooks
JanGyan encapsulates 60 modular learning handbooks (10 modules per domain) and 6 category-level examination handbooks:

| # | Domain Title | Tagline / Key Focus | Handbooks | MCQs Verified |
|---|---|---|---|---|
| 1 | **Cyber Safety & Digital Security** | Phishing, OTP fraud, 1930 Helpline & DPDP Act 2023 | 10 Modules + 1 MCQ | 500 |
| 2 | **Government Services & Citizen Rights** | DigiLocker, UMANG, RTI Act, Aadhaar & Direct Benefit Transfer | 10 Modules + 1 MCQ | 500 |
| 3 | **Traffic Rules & Road Safety** | Motor Vehicles Act 2019, Golden Hour, Good Samaritan Law | 10 Modules + 1 MCQ | 500 |
| 4 | **Health & Emergency Awareness** | Ayushman Bharat (PM-JAY), CPR, 112 & 108 Emergency Systems | 10 Modules + 1 MCQ | 500 |
| 5 | **Financial Literacy & Digital Payments** | UPI Security, RBI Ombudsman, PMJDY, NPCI fraud prevention | 10 Modules + 1 MCQ | 500 |
| 6 | **Environmental Responsibility** | Mission LiFE, Solid Waste Rules, E-Waste Management & Solar | 10 Modules + 1 MCQ | 500 |
| **Total** | **6 Domains** | **Official National Curriculum** | **66 PDFs** | **3,000 MCQs** |

---

## 🛡️ Architecture & Security
- **Frontend Engine**: Flutter 3.47.7 & Dart 3.13.5 (Sound Null Safety, Material Design 3).
- **Typography & Theme**: Google Fonts (Plus Jakarta Sans) with curated Civic Blue palette (`#0D47A1`, `#1565C0`, `#F8FAFD`).
- **Resilient Dual-Mode Backend**:
  - **Cloud Mode**: Live Firebase Authentication, Cloud Firestore real-time sync, and Firebase Storage.
  - **Offline/Resilient Mode**: High-performance local persistence (`SharedPreferences`) supporting instant user profiles, quiz attempt history, and progress retention when credentials or network connectivity are not yet provisioned.
- **Civic Question Engine**: Evaluates 20 randomized questions per assessment with answer verification, immediate explanations, and official citizen certificate generation.
- **Gemini AI Civic Assistant**: Real-time civic guidance assistant with built-in knowledge retrieval for Indian citizen inquiries.
- **In-App Handbook Reader**: Built-in document viewer with citizen watermark overlay and page-by-page caching.

---

## 📱 14 Production Screens
1. **Splash Screen** – Civic branding animation with session restoration.
2. **Login Screen** – Email/password authentication, validation, and demo mode.
3. **Registration Screen** – Citizen profile creation and validation.
4. **Forgot Password Screen** – Password reset flow.
5. **Home Screen** – National civic helpline carousel, domain progress cards, quick action hubs, and quick quiz launcher.
6. **Category Selection Screen** – Overview of all 6 educational categories.
7. **Knowledge Hub Screen** – Module browser displaying all 10 modules per category with metadata and reading status.
8. **PDF Viewer Screen** – Document reader with citizen watermark protection.
9. **Quiz Screen** – Interactive 20-question randomized examination with real-time timer and progress telemetry.
10. **Quiz Results Screen** – Score analytics, accuracy breakdown, full answer review, and downloadable Civic Certificate.
11. **AI Assistant Screen** – Interactive AI chat interface for civic and governmental queries.
12. **Feedback Screen** – Citizen feedback submission with category selection and ratings.
13. **Profile Screen** – Citizen credentials, total attempted questions, accuracy percentage, and proficiency badges.
14. **Admin Interface** – Management portal for category oversight, question integrity verification, and citizen feedback review.

---

## 🔒 Security Rules
- `firestore.rules`: Strict UID-bound security rules protecting answers and user scores.
- `storage.rules`: Read-only access to official educational assets and write restrictions for admin roles.

---

## 🗄️ Multi-Tier Database Architecture

1. **Firebase Cloud Firestore (`jangyan-e2608`)**:
   - Live cloud sync for citizen profiles, quiz progress, and administrative feedback.
   - Hosted in region `asia-south1` (Mumbai).
2. **Project SQLite Database (`database/jangyan.db`)**:
   - 1.73 MB embedded relational database stored directly in the repository with full schema and WAL mode.
3. **MongoDB GridFS & NoSQL Collections (`database/mongodb_dump/`)**:
   - Full JSON dumps of all 3,000 MCQs, 66 handbook metadata entries, categories, and users.
   - MongoDB Atlas ready via `.env` (`MONGODB_URI`).

---

## 🚀 Live Deployment & Quick Start

### 🌐 GitHub Repository & Continuous Deployment
- **Repository**: [https://github.com/AnishCodes-99/jangyan-app](https://github.com/AnishCodes-99/jangyan-app)
- **GitHub Pages**: Automated workflow in `.github/workflows/deploy.yml` deploys the web app on every push to `main`.

### 💻 Running Locally

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Launch Database API (MongoDB + SQLite)**:
   ```bash
   python backend/mongodb_api.py 5001
   ```

3. **Run Flutter Web App**:
   ```bash
   flutter run -d chrome
   ```
   Or serve the compiled release build:
   ```bash
   python -m http.server 8080 --directory build/web
   ```

