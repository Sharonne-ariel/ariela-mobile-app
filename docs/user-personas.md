# User Personas

This document defines the four user personas ARIELA is designed for. Every product decision should be tested against these personas: *Would Léa understand this? Could Naomi use this with limited data? Would Aïcha take this seriously? Would Camille use this in both her languages?*

**Status:** v1 — locked

---

## Persona 1 — Léa, 13

| Attribute | Value |
|---|---|
| Age | 13 |
| Location | Lyon, France |
| Occupation | Middle school student |
| Living situation | Lives with parents |
| Primary module | First Period Mode |
| Tier | Free (long-term retention play) |

### Her situation

Léa has been waiting for her first period for a few months. Her mother spoke to her about it but "not in detail." She's embarrassed to talk about it at school. She searches for information on TikTok and Google but finds adult or unreliable content.

### Her goals with ARIELA

- Understand what's happening to her body without embarrassment
- Know what to do when her period arrives
- Not panic when it happens

### Her current frustrations

- Existing apps treat her like an adult
- Online content is either condescending or sexualized
- No one talks to her in plain, age-appropriate language

### Her usage in ARIELA

- **Free:** First Period Mode (educational videos, hygiene guidance, "what to do the first time"), Cycle Tracker once her period starts
- **Premium:** None for now — possibly later in life

### Quote

> "At least the app talks to me like a real person, not like a baby."

---

## Persona 2 — Naomi, 22

| Attribute | Value |
|---|---|
| Age | 22 |
| Location | Kinshasa, DRC |
| Occupation | Computer science student |
| Living situation | Shares an apartment with roommates |
| Primary modules | Cycle Tracker + Safe Mode + AI Assistant |
| Tier | Free → Trial → likely Premium monthly |

### Her situation

Naomi is in a relationship and sexually active. She does not want children right now. Her cycle is irregular and she doesn't always understand her pain. Access to a gynecologist is limited (expensive, long waits). She figures things out with Google.

### Her goals with ARIELA

- Track her cycle to understand what's normal for her body
- Know her fertile days to avoid pregnancy
- Have a place to ask intimate questions without shame

### Her current frustrations

- US apps are expensive and English-only
- French forums give contradictory advice
- Asking her mother or aunts means judgment
- Mobile data is limited — the app must work offline

### Her usage in ARIELA

- **Free:** Daily Cycle Tracker, Safe Mode for fertile days
- **Premium (14-day trial):** Tries asking the AI a question → starts the trial → likely converts to 4,99 €/month if she values it

### Quote

> "Finally, an app where I can ask my questions without being judged or lectured."

---

## Persona 3 — Aïcha, 31

| Attribute | Value |
|---|---|
| Age | 31 |
| Location | Brussels, Belgium |
| Occupation | Accountant |
| Living situation | Married, has been trying to conceive for 8 months |
| Primary modules | Fertility Mode + AI Assistant |
| Tier | Premium annual (immediate conversion) |

### Her situation

Aïcha and her husband have been trying for 8 months. She's starting to worry. She tracks her basal body temperature, follows her cycles, reads forums. Social pressure from family is high. She wants to optimize her chances.

### Her goals with ARIELA

- Identify her fertile window precisely
- Understand if something might be wrong
- Have reminders (vitamins, doctor appointments)
- Stay hopeful without becoming obsessive

### Her current frustrations

- Existing fertility apps are either too clinical (incomprehensible BBT charts) or too "wellness" (incense and moon cycles)
- She wants seriousness AND warmth

### Her usage in ARIELA

- **Free:** Cycle Tracker
- **Premium (immediate conversion):** Full Fertility Mode, AI for her questions ("is this normal after 8 months?"), advanced insights. Takes the annual plan at 39,99 €.

### Quote

> "40 € a year for peace of mind during this period of my life? Obviously."

---

## Persona 4 — Camille, 28

| Attribute | Value |
|---|---|
| Age | 28 |
| Location | Montreal, Canada |
| Occupation | Freelance designer |
| Living situation | 16 weeks pregnant with first child |
| Primary modules | Pregnancy Mode + Postpartum Mode |
| Tier | Premium annual (converts day 2) |

### Her situation

Camille recently learned she's pregnant. First baby, many questions. Her gynecologist is great but appointments are spaced out. Between visits, she has 1,000 questions. Bilingual FR/EN, reads in both languages.

### Her goals with ARIELA

- Track week-by-week pregnancy progress
- Distinguish normal symptoms from concerning ones
- Prepare for the baby's arrival (checklists, appointments)
- Later: postpartum recovery, breastfeeding support

### Her current frustrations

- Existing pregnancy apps (BabyCenter, What to Expect) are full of ads and anxiety-inducing forums
- French content is limited
- She wants one quality app, not five different ones

### Her usage in ARIELA

- **Premium (converts on day 2):** Full Pregnancy Mode, AI for daily questions, checklists, appointment reminders. Continues with Postpartum Mode after birth. Annual plan at 39,99 € — "the price of two coffees a month."

### Quote

> "It's the only app that speaks to me in both my languages without bugs. I use it every day."

---

## Implications for product design

### Free tier must be genuinely useful (Léa, Naomi)
Without a strong free tier, we lose Léa entirely (she'll never pay) and we lose Naomi's potential conversion (she needs to trust the app first).

### Premium modes must be exceptional (Aïcha, Camille)
The Fertility, Pregnancy, and Postpartum modes are what generate revenue. They must be best-in-class.

### Offline mode is non-negotiable (Naomi)
The DRC market and similar markets have limited connectivity. Hive local DB + sync is mandatory, not optional.

### Bilingual quality must be perfect (Camille)
Half-translated screens or French that sounds machine-translated will lose Camille — and she's the persona who pays the most.

### Cultural sensitivity in imagery (all)
Using diverse names and locations in our personas reflects in our content choices. Illustrations, examples, and educational content should reflect global diversity.
