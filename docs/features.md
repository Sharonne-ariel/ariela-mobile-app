# Features

This document is the canonical list of every feature in ARIELA, organized by module, with the free/premium distinction made explicit.

**Status:** v1 — locked for MVP

---

## Feature legend

- 🆓 **Free** — Available to all users, no subscription needed
- ⭐ **Premium** — Requires active subscription (or trial)
- 🔒 **Premium-locked with preview** — Free users see the feature exists but cannot use it fully
- 🚀 **Post-MVP** — Planned for v2 or later, not in initial launch

---

## Cross-cutting features (apply across the app)

| Feature | Tier | Description |
|---|---|---|
| Bilingual UI (FR + EN) | 🆓 | Full app available in both languages, switchable in settings |
| Email + Google + Apple sign-in | 🆓 | Multiple authentication methods |
| Light + dark mode | 🆓 | Auto-follows system, manual override available |
| Offline mode | 🆓 | Core tracking works without internet, syncs when connected |
| Local data encryption | 🆓 | All data encrypted at rest on device |
| Privacy-first defaults | 🆓 | No tracking, no analytics without consent |
| Data export (PDF) | ⭐ | Export cycle history as PDF for doctor visits |
| Account deletion | 🆓 | One-tap full account and data deletion (GDPR) |

---

## Module 1 — First Period Mode

**Target user:** Léa (13)

| Feature | Tier | Description |
|---|---|---|
| Welcome onboarding for teens | 🆓 | Age-appropriate introduction to periods |
| Educational articles | 🆓 | Curated, age-appropriate content (~15 articles for MVP) |
| Hygiene guide | 🆓 | How to use pads, tampons, period underwear |
| First period checklist | 🆓 | What to keep in your bag, what to do at school |
| Pain management tips | 🆓 | Non-medical advice (heat, hydration, rest) |
| When to see a doctor | 🆓 | Clear warning signs that need professional attention |
| Parent notification mode (optional) | 🚀 | Optional: notify a parent on first period (off by default) |

---

## Module 2 — Cycle Tracker

**Target users:** Naomi, Aïcha, all users

| Feature | Tier | Description |
|---|---|---|
| Calendar view | 🆓 | Monthly view with period and predicted days |
| Period logging | 🆓 | Mark start/end of period, flow intensity |
| Symptom tracking | 🆓 | Pain, mood, fatigue, acne, discharge, etc. (20+ symptoms) |
| Basic predictions | 🆓 | Next period prediction based on cycle average |
| Cycle history (3 months) | 🆓 | View last 3 months of data |
| Reminders | 🆓 | Customizable notifications for upcoming periods |
| Cycle history (unlimited) | ⭐ | View entire cycle history forever |
| AI-powered predictions | ⭐ | More accurate predictions using cycle pattern analysis |
| Symptom pattern detection | ⭐ | "Your headaches occur 2 days before your period 80% of the time" |
| Cycle insights & reports | ⭐ | Monthly insights with personalized observations |
| Apple Health / Google Fit sync | 🚀 | Sync with health platforms (post-MVP) |

---

## Module 3 — Safe Mode (Fertility Awareness)

**Target user:** Naomi (and any user not currently trying to conceive)

| Feature | Tier | Description |
|---|---|---|
| Fertile / non-fertile day display | 🆓 | Visual calendar of estimated fertile window |
| Late period alert | 🆓 | Notification if period is X days late |
| Contraception reminders | 🆓 | Reminders for pill, patch, ring, etc. |
| Disclaimer & education | 🆓 | Clear messaging that the app is not a contraceptive method |
| Advanced fertility window prediction | ⭐ | More precise window using symptoms + temperature |
| Risk-day color coding | ⭐ | Visual risk levels for each day |

⚠️ **Important:** Safe Mode includes a permanent, prominent disclaimer that ARIELA is not a contraceptive method and should not replace medical contraception.

---

## Module 4 — Fertility Mode (Trying to Conceive)

**Target user:** Aïcha (31)

| Feature | Tier | Description |
|---|---|---|
| Mode availability | 🔒 | Free users see the mode exists; full features require premium |
| Ovulation prediction | ⭐ | AI-powered ovulation day estimation |
| Basal body temperature (BBT) tracking | ⭐ | Daily temperature logging with trend chart |
| Cervical mucus tracking | ⭐ | Daily logging with educational content |
| Conception calendar | ⭐ | Best days highlighted for conception attempts |
| Pre-conception health checklist | ⭐ | Folic acid, vitamins, lifestyle factors |
| Doctor appointment reminders | ⭐ | Custom reminders for appointments and tests |
| AI fertility coach | ⭐ | Personalized guidance ("It's been X months — here's what doctors say") |
| Partner sharing (optional) | 🚀 | Share fertility window with partner |

---

## Module 5 — Pregnancy Mode

**Target user:** Camille (28)

| Feature | Tier | Description |
|---|---|---|
| Mode availability | 🔒 | Free users see the mode; full features require premium |
| Week-by-week pregnancy tracker | ⭐ | Each week: baby development, body changes, what to expect |
| Pregnancy symptom tracker | ⭐ | Track nausea, fatigue, kicks, etc. with normal/concerning indicators |
| Appointment manager | ⭐ | Schedule prenatal visits, ultrasounds, tests |
| Hospital bag checklist | ⭐ | Customizable checklist for delivery day |
| Birth plan template | ⭐ | Editable template for birth preferences |
| Nutrition guidance | ⭐ | What to eat, what to avoid (per trimester) |
| Pregnancy AI assistant | ⭐ | "Is X symptom normal at week Y?" with proper disclaimers |
| Contraction timer | ⭐ | Track contractions in early labor |
| Weight tracking | ⭐ | Log weight with healthy-range guidance |

---

## Module 6 — Postpartum Mode

**Target user:** Camille (after birth)

| Feature | Tier | Description |
|---|---|---|
| Mode availability | 🔒 | Auto-unlocks after delivery date for premium users |
| Recovery tracker | ⭐ | Physical recovery milestones |
| Breastfeeding tracker | ⭐ | Feed logs, durations, sides, pumping |
| Baby sleep tracker | ⭐ | Sleep cycles for newborn |
| Mood & mental health tracker | ⭐ | Daily check-ins with screening for postpartum depression |
| Return-of-period tracking | ⭐ | When and how cycles resume |
| Postpartum AI assistant | ⭐ | Guidance on common postpartum questions |
| Resources for partners | 🚀 | Educational content for partners (post-MVP) |
| Crisis resources | 🆓 | Mental health hotlines and emergency info — always free |

---

## Module 7 — AI Health Assistant

**Target users:** All premium users

| Feature | Tier | Description |
|---|---|---|
| Conversational interface | ⭐ | Chat-style interface in user's preferred language |
| GPT-4o-mini for general questions | ⭐ | Fast, affordable model for routine queries |
| GPT-4o for complex questions | ⭐ | Higher-quality model for medical-context questions |
| Context-aware responses | ⭐ | AI knows user's current cycle phase, mode, history |
| Disclaimer on every response | ⭐ | Each AI response ends with "consult a healthcare professional" |
| Crisis detection | ⭐ | Auto-redirect to emergency resources for urgent symptoms |
| Conversation history | ⭐ | Past conversations saved for reference |
| Free preview (3 questions/month) | 🔒 | Free users get 3 AI questions per month as a teaser |

---

## Onboarding flow

| Feature | Tier | Description |
|---|---|---|
| Welcome screens (3-4 screens) | 🆓 | Brand intro, value proposition |
| Goal selection | 🆓 | "Which mode fits you best?" — selects primary persona |
| Account creation | 🆓 | Email/Google/Apple |
| Initial cycle setup | 🆓 | Last period date, average cycle length |
| Permission requests | 🆓 | Notifications, optional health data |
| Tour of free features | 🆓 | Brief walkthrough of what's available |

⚠️ **No paywall during onboarding.** First paywall appears only when user attempts a premium feature.

---

## Out of scope for MVP

These features are explicitly NOT in MVP and should not be added without re-scoping:

- 🚀 Apple HealthKit / Google Fit deep integration
- 🚀 Wearable device integration (Oura, Apple Watch, etc.)
- 🚀 Community / forum features
- 🚀 Social sharing of cycle data
- 🚀 Telehealth integration (book a doctor)
- 🚀 Pharmacy integration (order pills)
- 🚀 Multi-language beyond FR + EN
- 🚀 Web app version
- 🚀 Tablet-optimized layouts
- 🚀 Smartwatch companion app

These are **future versions**, not MVP.
