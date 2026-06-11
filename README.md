# 🌸 ARIELA

> **Comprendre ton corps, à chaque étape.**
> _Understand your body, at every stage._

A bilingual (French / English) women's health companion mobile app, powered by a custom Retrieval-Augmented Generation (RAG) AI assistant.

[![Flutter](https://img.shields.io/badge/Flutter-3.29-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5-0175C2?logo=dart)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-3FCF8E?logo=supabase)](https://supabase.com)
[![Tests](https://img.shields.io/badge/tests-75%2B%20passing-success)](#testing)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📱 About

ARIELA is a bilingual mobile application focused on women's health across every life stage — from a teenager's first period to postpartum recovery. It combines local-first tracking, intelligent personalized predictions, and a custom AI assistant grounded on a curated medical knowledge base.

Built with a strong focus on privacy, accessibility, and inclusivity — designed to serve women in Europe and French-speaking Africa equally.

🌐 **Live AI API**: [https://shariel-ariela-ai.hf.space](https://shariel-ariela-ai.hf.space)
🧠 **AI source code**: [Sharonne-ariel/ariela-ai](https://github.com/Sharonne-ariel/ariela-ai)

---

## ✨ Features (21 shipped)

### Free
- **First Period Mode** — 6 educational articles for young girls (10-16)
- **Cycle Tracker** — Calendar, predictions, animated progress ring
- **Symptom Logging** — 12 symptom types with intensity 1-5
- **Daily Journal** — Free-form notes for each day
- **History & Stats** — Average cycle/period length, total cycles

### Premium (14-day free trial)
- **Fertility Mode** — Phase-based predictions (menstrual, follicular, fertile, ovulation, luteal)
- **Pregnancy Mode** — Week-by-week tracker, trimester breakdown, due date
- **Postpartum Mode** — 4-phase recovery (acute / subacute / delayed / long-term) + mental health awareness
- **AI Assistant** — RAG-powered Q&A grounded on 235 medical Q/A pairs from Mayo Clinic, ACOG, NHS, WHO
- **Personalized predictions** — Learns from your tracked history (regularity detection, custom cycle length)

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Mobile framework | Flutter 3.29 (Dart 3.5) |
| State management | Riverpod 2.5 |
| Local database | Hive 2.2 (offline-first) |
| Backend | Supabase (PostgreSQL + Auth + RLS) |
| Authentication | Email + password, email confirmation |
| AI | Custom RAG — sentence-transformers + ChromaDB + FastAPI |
| AI deployment | Hugging Face Spaces (Docker) |
| Internationalization | flutter_localizations (FR + EN) |

---

## 🏗 Architecture

ARIELA follows a **local-first** architecture: every interaction is instant because data is written to Hive on the device first, then synchronized to Supabase in the background. The app remains fully functional offline.

┌─────────────────────────┐
│   Flutter App (iOS+And) │
│   - Riverpod state      │
│   - Hive local DB       │
│   - 5 modes + AI chat   │
└─────────────┬───────────┘
│
┌──────┴──────┐
│             │
▼             ▼
┌──────────────┐  ┌──────────────────────┐
│   Supabase   │  │  Hugging Face Spaces │
│  (EU region) │  │   FastAPI + RAG      │
│  PostgreSQL  │  │   235 medical Q/A    │
│  Row-Level   │  │   ChromaDB embeds    │
│  Security    │  │   sentence-transf.   │
└──────────────┘  └──────────────────────┘
---

## 🧪 Testing

75+ unit tests with 100% pass rate covering all business-logic modules:

| Module | Tests |
|---|---|
| CycleMath | 15 |
| CyclePredictor | 8 |
| PregnancyMath | 18 |
| FertilityMath | 14 |
| PostpartumMath | 14 |
| CycleStats | 6 |

Run them with:
```bash
flutter test
```

---

## 🚀 Getting started

### Prerequisites
- Flutter 3.29+
- Dart 3.5+
- Xcode 16+ (iOS) / Android Studio (Android)

### Setup
```bash
git clone https://github.com/Sharonne-ariel/ariela-mobile-app.git
cd ariela-mobile-app
flutter pub get
flutter gen-l10n
```

### Configuration
Create a `.env` file at the project root:
```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### Run
```bash
flutter run
```

---

## 🎨 Brand identity

- **Colors**: Lavender (`#6B5DD3`) and Pink (`#E5739A`) on warm neutrals
- **Typography**: DM Sans 400/500
- **Voice**: Warm, informal "tu" in French

---

## 📊 AI Evaluation

The RAG system was benchmarked on a held-out golden set of 20 reformulated questions:

| Metric | Score |
|---|---|
| Top-1 accuracy | **65%** |
| Top-3 accuracy | **90%** |
| Mean top-1 similarity | 0.642 |
| Crisis question (mental health) | ✅ Top-1 |

See the [ariela-ai repo](https://github.com/Sharonne-ariel/ariela-ai) for full evaluation methodology.

---

## ⚠️ Privacy & Medical Disclaimer

ARIELA handles sensitive health data with the highest privacy standards: EU-hosted Supabase, Row-Level Security on every table, no third-party trackers. Health data never leaves the user's device + EU servers.

**ARIELA is not a medical device** and does not provide medical diagnosis. The AI assistant provides general information sourced from authoritative medical references (Mayo Clinic, ACOG, NHS, WHO) and always recommends consulting a qualified healthcare professional. Crisis support resources are surfaced for mental health emergencies.

---

## 🗺 Roadmap

- ✅ Phase 1: Cycle Tracker, Symptoms, History (free tier)
- ✅ Phase 2: Fertility, Pregnancy, Postpartum modes (premium)
- ✅ Phase 3: AI Assistant with custom RAG service
- 🚧 Phase 4: Similarity threshold filter, insights dashboard
- 🚧 Phase 5: App Store + Play Store launch (Q4 2026)

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 👤 Author

**Sharonne Kabamba Muadi** 
Software Engineering student 
Final-year project, Spring 2026

Built as part of the İME workplace application training course under the supervision of PR.Ersin Aslan.
