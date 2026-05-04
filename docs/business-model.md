# Business Model

This document defines ARIELA's monetization strategy and pricing. All product decisions related to free vs paid features must reference this document.

**Status:** v1 — locked

---

## Strategy: Freemium with 14-day premium trial

ARIELA uses a **freemium model** where the core experience is free forever, and life-stage-specific advanced features are unlocked via a paid subscription. New users get a **14-day free trial** of premium when they first interact with a premium feature.

### Why freemium and not paid-only

1. **The core value (cycle tracking) must be free** — otherwise teens and young women won't adopt it
2. **Free users are word-of-mouth marketing** — they recommend the app to friends
3. **Apple/Google store algorithms favor freemium apps** — better discoverability
4. **Real conversions happen at life-stage moments** (trying to conceive, pregnancy) when users naturally need premium features

### Why a 14-day trial (not 7, not 30)

- 7 days is too short for users to integrate the app into their cycle (which is ~28 days)
- 30 days feels excessive and increases free-rider abuse
- 14 days lets users experience at least one significant cycle moment (mid-cycle for fertility, ovulation, etc.) — creating real value attachment

---

## Free tier — "ARIELA Basic"

Free forever. No time limit. No ads.

| Feature | Details |
|---|---|
| **First Period Mode** | Full educational content for first periods |
| **Cycle Tracker** | Calendar, basic predictions, symptom logging |
| **Safe Mode (basic)** | Fertile/non-fertile days, contraception reminders |
| **Profile & reminders** | Account, basic notifications |
| **History** | 3 months of cycle history retained |
| **Languages** | Full FR + EN support |

### Limitations of the free tier

- Cycle history limited to last 3 months (premium = unlimited)
- No AI assistant access
- No specialized modes (Fertility, Pregnancy, Postpartum)
- No data export
- No advanced predictions or insights

---

## Premium tier — "ARIELA Premium"

| Feature | Details |
|---|---|
| **AI Health Assistant** | Unlimited personalized questions, GPT-4o-mini + GPT-4o |
| **Full Fertility Mode** | Ovulation tracking, BBT charting, conception guidance |
| **Full Pregnancy Mode** | Week-by-week tracking, checklists, appointment management |
| **Full Postpartum Mode** | Recovery tracking, breastfeeding, mental health support |
| **Advanced insights** | AI-powered cycle analysis, pattern detection |
| **Unlimited history** | All cycle data retained forever |
| **Data export** | PDF reports for doctor visits |
| **Priority support** | Faster response times for support requests |

---

## Pricing

| Plan | Price | Effective monthly | Notes |
|---|---|---|---|
| **Monthly** | 4,99 € | 4,99 € | Standard subscription |
| **Annual** | 39,99 € | 3,33 € | **Best value** — 33% savings |

### Free trial terms

- **Duration:** 14 days
- **Eligibility:** Once per user account (Apple/Google verifies via account)
- **Payment method required:** Yes (handled by Apple/Google)
- **Cancellation:** Anytime during trial = no charge
- **Auto-conversion:** On day 14, automatically converts to chosen plan unless cancelled
- **Reminder notifications:** Sent on day 11 and day 13

### Pricing rationale

- **Below psychological 5 € threshold** for monthly
- **Just under 40 € for annual** to maximize perceived value
- **33% discount on annual** is industry-standard incentive to lock in users
- **Aligned with competitors:** Flo Premium (~4,99 €), Clue Plus (~5,99 €), Stardust (~6,99 €)

---

## Conversion expectations

Based on industry benchmarks for women's health apps with a strong free tier:

| Funnel stage | Expected rate |
|---|---|
| App download → registration | 60-70% |
| Free user → premium trial start | 15-25% |
| Trial start → paid conversion | 40-60% |
| Free user → paid (overall) | **5-10%** |

### Annual plan adoption target

Target: **60% of paying users on annual plan** (vs 40% monthly).

Reasons annual is favored:
- Better cash flow for ARIELA
- Higher LTV (lifetime value) per user
- Lower churn (annual users forget to cancel less often)
- Industry standard: most successful apps see 50-65% annual share

---

## Persona-mapped revenue model

| Persona | Tier | Expected behavior | Annual revenue |
|---|---|---|---|
| Léa (13, teen) | Free | Stays free for years; potential future conversion | 0 € |
| Naomi (22, student) | Free → Premium monthly | Converts after trial, may cancel after a few months | ~30 € |
| Aïcha (31, TTC) | Premium annual immediate | Active 1-2 years during conception | ~40-80 € |
| Camille (28, pregnant) | Premium annual immediate | Active 2 years (pregnancy + postpartum) | ~80 € |

**Top revenue drivers:** Aïcha and Camille personas (Fertility + Pregnancy + Postpartum modes).

---

## Future monetization (post-MVP)

Potential additions in v2 and beyond:

- **Family / Couples plan** — Shared access for partners during conception/pregnancy
- **Healthcare professional partnerships** — Sponsored content from verified gynecologists
- **In-app purchases** — One-time educational courses (e.g., "Preparing for childbirth")
- **B2B licensing** — License the platform to clinics or insurance providers
- **Premium content packs** — Specialized content (PCOS, endometriosis support)

**None of these are in scope for MVP.**

---

## What we will NOT do

To preserve trust and align with brand values:

- ❌ **No advertisements** — ARIELA never shows ads, period
- ❌ **No data selling** — User data is never sold to third parties
- ❌ **No dark patterns** — No fake countdowns, no "limited offers" that aren't, no impossible-to-cancel flows
- ❌ **No paywall on safety information** — Critical health warnings are always free, even for non-premium users
- ❌ **No paywall during emergencies** — If a user's symptoms suggest an urgent issue, the app helps regardless of subscription status
