# AI & Medical Disclaimer

This document defines the medical and AI disclaimer policies for ARIELA. These rules are non-negotiable and apply throughout the application.

**Status:** v1 — locked
**Legal review:** Recommended before App Store submission

---

## Core principle

**ARIELA is not a medical device. The AI assistant is not a doctor.**

The application provides general educational information and tracking tools. It does not diagnose, treat, prevent, or cure any disease or medical condition. Users must always consult qualified healthcare professionals for medical concerns.

This principle is non-negotiable and enforced at every layer of the product.

---

## Apple App Store compliance

App Store Review Guideline 1.4.1 prohibits apps that:
- Provide inaccurate medical information that could cause harm
- Make medical claims without supporting evidence
- Use medical-grade categorization without proper certification

App Store Review Guideline 5.1.1 requires:
- Clear privacy policies
- Explicit consent for sensitive data collection
- Restrictions on collecting data from minors

ARIELA's compliance approach:
- All medical claims are general, educational, and reference standard medical knowledge
- No "diagnosis" language anywhere in the app
- No claim of medical-grade accuracy
- Every AI response includes a professional consultation reminder
- Privacy policy and terms of service are clearly accessible
- Minimum age requirement enforced at sign-up

---

## Google Play compliance

Google Play's Health Apps policy requires:
- Accurate health information
- Privacy disclosures
- No false health claims
- Special handling of menstrual and reproductive data

ARIELA's compliance approach mirrors Apple's, plus:
- Clear data handling disclosures during onboarding
- Granular permissions (only request what's needed)

---

## Mandatory disclaimers

### Disclaimer 1: General app disclaimer

Shown during onboarding (must be acknowledged) and accessible from settings.

**French version:**

> ARIELA est une application d'information et de suivi. Elle ne remplace pas l'avis d'un professionnel de santé qualifié. Les informations fournies sont générales et ne constituent pas un diagnostic médical. En cas de doute ou de symptôme préoccupant, consulte toujours un médecin, une sage-femme, ou un gynécologue.

**English version:**

> ARIELA is an informational and tracking application. It does not replace the advice of a qualified healthcare professional. The information provided is general and does not constitute a medical diagnosis. In case of doubt or concerning symptoms, always consult a doctor, midwife, or gynecologist.

### Disclaimer 2: AI assistant disclaimer

Shown before first AI interaction and persistently in the AI chat interface.

**French version:**

> L'assistante ARIELA fournit des informations générales basées sur des connaissances médicales standards. Elle ne pose pas de diagnostic et ne remplace pas une consultation médicale. Pour toute préoccupation, consulte un professionnel de santé. En cas d'urgence, contacte les services d'urgence (15, 112, ou ton service local).

**English version:**

> The ARIELA assistant provides general information based on standard medical knowledge. It does not diagnose and does not replace a medical consultation. For any concerns, please consult a healthcare professional. In an emergency, contact emergency services (911, 112, or your local equivalent).

### Disclaimer 3: Safe Mode (contraception) disclaimer

Permanently visible in Safe Mode interface.

**French version:**

> ⚠️ ARIELA n'est pas une méthode contraceptive. Les prédictions de jours fertiles ne sont pas fiables à 100 %. Utilise toujours une méthode contraceptive médicale (préservatif, pilule, DIU, etc.) si tu ne souhaites pas tomber enceinte.

**English version:**

> ⚠️ ARIELA is not a contraceptive method. Fertile day predictions are not 100% reliable. Always use a medical contraceptive method (condom, pill, IUD, etc.) if you do not wish to become pregnant.

### Disclaimer 4: Pregnancy mode disclaimer

Shown when entering Pregnancy Mode for the first time.

**French version:**

> Le suivi de grossesse dans ARIELA est informatif. Il ne remplace pas le suivi médical par un professionnel (gynécologue, sage-femme). Tous les rendez-vous prénataux recommandés doivent être respectés. En cas de symptôme inhabituel, contacte immédiatement ton soignant.

**English version:**

> Pregnancy tracking in ARIELA is informational. It does not replace medical follow-up by a professional (gynecologist, midwife). All recommended prenatal appointments must be attended. If you experience any unusual symptoms, contact your healthcare provider immediately.

---

## AI assistant safety rules

These rules are enforced via system prompts in the OpenAI integration.

### Rule 1: Always recommend professional consultation

Every response that touches on a health concern must end with a reminder to consult a healthcare professional.

### Rule 2: Never diagnose

The AI must never use diagnostic language ("you have X condition"). Instead, it should describe symptoms generally and recommend professional evaluation.

**Forbidden phrases:** "You have...", "This means you are pregnant", "You are experiencing X disease"

**Acceptable phrasing:** "These symptoms are sometimes associated with...", "It would be a good idea to discuss this with a doctor", "This could have various causes"

### Rule 3: Detect crisis indicators

The AI must detect specific crisis indicators and respond with immediate redirect to emergency resources.

**Crisis keywords (non-exhaustive):**
- Severe pain (sudden, intense)
- Heavy bleeding outside of period
- Suicidal ideation
- Severe pregnancy symptoms (preeclampsia signs, severe contractions before term)
- Signs of severe postpartum depression

**Crisis response template:**

> Tes symptômes méritent une attention médicale immédiate. Contacte ton médecin, va aux urgences, ou appelle le 15 (France) / 112 (Europe) / ton service d'urgence local. Je suis là pour t'aider à y voir plus clair, mais cette situation a besoin d'un professionnel maintenant.

### Rule 4: Never provide specific medical dosages

The AI must not recommend specific medication dosages, even for over-the-counter drugs. It can mention that medications exist but always defers to a healthcare professional or pharmacist for dosage.

### Rule 5: Respect privacy

The AI must never:
- Ask for identifying personal information beyond what's already in the user profile
- Encourage the user to share data outside the app
- Discuss other users' data

### Rule 6: Maintain language consistency

The AI must respond in the language the user is currently using in the app (FR or EN). It should not switch languages unprompted.

### Rule 7: Stay in scope

The AI must politely decline to discuss topics outside women's health (politics, current events, general knowledge unrelated to health). It should redirect: "I'm here to help with women's health questions. For that, I'd suggest [Google / a relevant resource]."

---

## Emergency resources (built into the app)

The app includes a quick-access emergency resources section, always available regardless of subscription status.

### France
- SAMU: 15
- Emergencies: 112
- SOS Médecins: 3624
- Suicide prevention: 3114

### Belgium
- Emergencies: 112
- Centre de prévention du suicide: 0800 32 123

### DRC (Kinshasa)
- Police: 122
- Pompiers: 118

### Canada
- Emergencies: 911
- Suicide crisis: 9-8-8

### General international
- Emergencies: 112 (works across most of Europe)
- 911 (US, Canada, parts of Africa)

---

## Data sensitivity

Per GDPR Article 9, the following data types are classified as "special category data" requiring extra protection:

- Menstrual cycle data
- Pregnancy data
- Sexual activity data (implicit through fertility tracking)
- Mental health data (mood logs, postpartum depression screening)

ARIELA's handling:
- All such data is encrypted at rest (device + Supabase)
- Never shared with third parties
- Never used for advertising
- Subject to user's right to deletion (Article 17)
- Subject to user's right to export (Article 20)
- Hosted in EU region (data residency)

---

## Periodic review

This disclaimer document must be reviewed:
- Before each major version release
- Whenever a new module is added
- Whenever AI capabilities are expanded
- Whenever regulations change in target markets

A legal review by a qualified attorney specializing in health-tech and GDPR is strongly recommended before App Store submission.
