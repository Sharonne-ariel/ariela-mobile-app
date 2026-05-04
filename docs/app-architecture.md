# App Architecture

This document describes ARIELA's complete technical architecture. It is the reference for every implementation decision.

**Status:** v1 — locked

---

## High-level architecture

ARIELA is a **client-heavy mobile app** with a managed backend (BaaS) and several specialized third-party services. There is no custom server to maintain.

```
┌─────────────────────────────────────────────────────────────┐
│                  Flutter app (iOS + Android)                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │
│  │ UI       │  │ State    │  │ Local DB │  │ i18n     │    │
│  │ screens  │  │ Riverpod │  │ Hive     │  │ FR + EN  │    │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘    │
└─────┬────────────────┬─────────────┬──────────────┬─────────┘
      │                │             │              │
      ▼                ▼             ▼              ▼
┌───────────┐    ┌──────────┐  ┌──────────┐   ┌──────────┐
│ Supabase  │    │ OpenAI   │  │RevenueCat│   │ Firebase │
│ Auth + DB │    │ GPT-4o   │  │ Subs     │   │ FCM push │
│ EU region │    │ API      │  │          │   │          │
└───────────┘    └──────────┘  └──────────┘   └──────────┘
```

---

## Layer 1: Mobile application

### Framework & language
- **Flutter** 3.x+
- **Dart** 3.x+
- **Target platforms:** iOS 13+ and Android 8+ (API 26+)

### Project structure (Flutter)

```
lib/
├── main.dart
├── app/
│   ├── app.dart                  # Root app widget
│   ├── router.dart               # Navigation routes (go_router)
│   └── theme.dart                # Theme using brand-guidelines tokens
├── core/
│   ├── constants/                # App-wide constants
│   ├── extensions/               # Dart extensions
│   ├── utils/                    # Helpers, formatters
│   └── errors/                   # Error handling
├── data/
│   ├── models/                   # Data models (User, Cycle, Symptom, etc.)
│   ├── repositories/             # Repository interfaces
│   └── sources/
│       ├── local/                # Hive boxes
│       └── remote/               # Supabase, OpenAI, RevenueCat clients
├── features/
│   ├── auth/                     # Sign in, sign up, password reset
│   ├── onboarding/               # Welcome flow, persona selection
│   ├── cycle_tracker/            # Module 2
│   ├── first_period/             # Module 1
│   ├── safe_mode/                # Module 3
│   ├── fertility/                # Module 4 (premium)
│   ├── pregnancy/                # Module 5 (premium)
│   ├── postpartum/               # Module 6 (premium)
│   ├── ai_assistant/             # Module 7 (premium)
│   ├── premium/                  # Paywall, subscription management
│   └── settings/                 # Account, language, privacy
├── l10n/
│   ├── arb/
│   │   ├── app_en.arb            # English strings
│   │   └── app_fr.arb            # French strings
│   └── l10n.dart                 # Generated localization
└── ui/
    ├── components/               # Shared UI components (buttons, cards)
    ├── widgets/                  # Smaller reusable widgets
    └── illustrations/            # SVG illustrations
```

### State management

- **Riverpod** (latest stable, code generation enabled)
- One provider per feature, organized in `features/<feature>/providers/`
- Async state via `AsyncValue`
- Global state (current user, premium status) at app root level

### Local database

- **Hive** for fast key-value storage
- Used for:
  - Cycle entries (offline-first, synced to Supabase)
  - Symptom logs
  - User preferences
  - Cached AI conversations
- Encrypted boxes for sensitive data

### Routing

- **go_router** for declarative routing
- Deep linking support for marketing campaigns
- Protected routes for premium features

### Internationalization

- **flutter_localizations** with ARB files
- Two locales at MVP: `en` and `fr`
- All user-facing strings extracted to ARB files (zero hardcoded strings)
- Fallback locale: `en`

---

## Layer 2: Backend services

### Supabase (primary backend)

**Region:** EU (Ireland) — for GDPR compliance and European user latency.

**Components used:**

| Component | Purpose |
|---|---|
| Auth | Email/password, Google OAuth, Apple Sign In |
| PostgreSQL | All persistent user data |
| Row Level Security (RLS) | Per-user data isolation |
| Edge Functions | Server-side logic (e.g., AI proxy with rate limiting) |
| Storage | User-uploaded images (post-MVP) |
| Realtime | Not used in MVP (avoid complexity) |

### Database schema (initial)

```sql
-- Users (managed by Supabase Auth, extended via profile table)
profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  display_name text,
  language text DEFAULT 'fr',
  birth_year int,
  primary_mode text, -- 'first_period', 'cycle', 'safe', 'fertility', 'pregnancy', 'postpartum'
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Cycles
cycles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  start_date date NOT NULL,
  end_date date,
  cycle_length_days int,
  notes text,
  created_at timestamptz DEFAULT now()
);

-- Symptoms
symptoms (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  date date NOT NULL,
  symptom_type text NOT NULL, -- 'pain', 'mood', 'fatigue', etc.
  intensity int CHECK (intensity BETWEEN 1 AND 5),
  notes text,
  created_at timestamptz DEFAULT now()
);

-- AI conversations
ai_conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  messages jsonb NOT NULL, -- [{role, content, timestamp}, ...]
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Pregnancy data (premium users)
pregnancies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  due_date date NOT NULL,
  start_date date NOT NULL,
  delivery_date date,
  notes text,
  created_at timestamptz DEFAULT now()
);

-- Subscription status (synced from RevenueCat)
subscriptions (
  user_id uuid PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  is_premium boolean DEFAULT false,
  trial_ends_at timestamptz,
  subscription_ends_at timestamptz,
  product_id text,
  updated_at timestamptz DEFAULT now()
);
```

### Row Level Security policies

Every table enforces strict RLS — users can only read/write their own data.

```sql
-- Example for cycles table
ALTER TABLE cycles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own cycles"
  ON cycles FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own cycles"
  ON cycles FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own cycles"
  ON cycles FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own cycles"
  ON cycles FOR DELETE
  USING (auth.uid() = user_id);
```

---

## Layer 3: Third-party services

### OpenAI API

**Models used:**
- `gpt-4o-mini` — default for routine questions (~$0.15/1M input tokens)
- `gpt-4o` — for complex medical-context questions (~$2.50/1M input tokens)

**Routing logic:**
- Default to `gpt-4o-mini` for cost efficiency
- Use `gpt-4o` when:
  - User asks about pregnancy symptoms
  - User mentions concerning keywords ("pain", "bleeding", "emergency")
  - Conversation context is complex (multi-turn medical discussion)

**System prompts:**
- All system prompts include strict medical disclaimers
- All system prompts instruct the model to recommend professional consultation for any concerning symptom
- All system prompts enforce response in user's selected language

**Implementation:**
- API calls go through a Supabase Edge Function (not directly from the app)
- Edge Function adds authentication, rate limiting, abuse detection
- API keys are never exposed to the client

### RevenueCat

**Purpose:** Cross-platform subscription management.

**Configuration:**
- Two offerings: `monthly` (4,99 €) and `annual` (39,99 €)
- 14-day free trial on both offerings (first-time users only)
- Webhooks configured to sync subscription status to Supabase `subscriptions` table

**Why RevenueCat over native StoreKit/BillingClient:**
- Eliminates ~3 weeks of cross-platform subscription handling
- Provides analytics dashboard out of the box
- Free tier covers up to $2,500/month in revenue

### Firebase Cloud Messaging

**Purpose:** Push notifications for cycle reminders, trial expiration, AI alerts.

**Why FCM:** Industry standard, free, works on both iOS and Android with one SDK.

**Topics & subscriptions:**
- `cycle_reminders` — period predictions
- `pregnancy_milestones` — weekly pregnancy updates (premium only)
- `trial_expiration` — trial ending soon notifications
- Custom user-level topics for personalized reminders

---

## Cross-cutting concerns

### Security

- **Encryption at rest:** Hive encrypted boxes for sensitive data
- **Encryption in transit:** HTTPS everywhere (enforced by Supabase, OpenAI, etc.)
- **Authentication:** JWT-based via Supabase Auth
- **Authorization:** RLS at the database level, never client-side checks alone
- **API key management:** Server-side only via Edge Functions (never in app bundle)
- **Sensitive data:** Health data treated as sensitive per GDPR Article 9

### Privacy

- **Data minimization:** Only collect what's needed
- **Consent:** Explicit opt-in for analytics and notifications
- **Right to deletion:** One-tap account + data deletion (GDPR Article 17)
- **Right to export:** PDF export of all user data (GDPR Article 20)
- **No third-party tracking:** No Google Analytics, no Facebook SDK, no advertising IDs

### Performance targets

| Metric | Target |
|---|---|
| App cold start | < 2 seconds |
| Screen transition | < 300 ms |
| AI response (gpt-4o-mini) | < 3 seconds |
| AI response (gpt-4o) | < 5 seconds |
| Cycle prediction calculation | < 100 ms |
| Offline mode availability | 100% for tracking features |

### Accessibility

- All interactive elements have semantic labels
- Color contrast meets WCAG AA standards (4.5:1 minimum for body text)
- Font size scales with system settings
- Screen reader support (VoiceOver + TalkBack)
- No critical info conveyed by color alone

---

## Development tooling

| Tool | Purpose |
|---|---|
| VS Code | Primary IDE |
| Flutter SDK | Mobile framework |
| Supabase CLI | Local development, migrations |
| Git + GitHub | Version control |
| Trello | Task management |
| Figma | UI/UX design |
| Postman / Bruno | API testing |
| Firebase Console | Push notification testing |
| RevenueCat Dashboard | Subscription monitoring |

---

## CI/CD (planned for v1.1)

For MVP, builds and deployments are manual. Post-MVP, we plan:

- GitHub Actions for automated testing on PR
- Codemagic or Bitrise for automated builds
- Automatic TestFlight + Play Store internal testing uploads
- Automated translation linting (no missing keys)

---

## Monitoring & observability (planned)

For MVP, basic monitoring only:

- Supabase dashboard for backend errors
- RevenueCat dashboard for subscription analytics
- Apple App Store Connect + Google Play Console for crash reports

Post-MVP additions:
- Sentry for error tracking (with privacy-respecting config)
- PostHog for self-hosted product analytics (consent required)
