# Brand Guidelines

This document is the single source of truth for ARIELA's visual identity. Every screen, component, and marketing asset must follow these specifications.

**Status:** v1 — locked

---

## 1. Brand identity

### Name
**ARIELA**

Always written in lowercase in product UI (`ariela`), always uppercase in formal contexts and headings (ARIELA).

### Tagline

| Language | Tagline |
|---|---|
| 🇫🇷 French | Comprendre ton corps, à chaque étape. |
| 🇬🇧 English | Understand your body, at every stage. |

### Voice & tone

- **Warm, not clinical** — written like a knowledgeable friend, not a doctor
- **Informal address in French** — uses "tu", never "vous"
- **Inclusive** — speaks to women across all life stages, cultures, and backgrounds
- **Educational without being condescending** — assumes intelligence, explains gently
- **Honest about uncertainty** — never pretends to be a medical authority

---

## 2. Color system

### Primary — Lavender (the brand color)

| Token | Hex | Usage |
|---|---|---|
| `lavender.50` | `#F3F1FB` | Background tints, hover states |
| `lavender.200` | `#D9D3F5` | Borders, dividers, soft backgrounds |
| `lavender.400` | `#9B8FE5` | Secondary buttons, accents |
| `lavender.600` ★ | `#6B5DD3` | **Primary brand color.** Buttons, links, key UI |
| `lavender.900` | `#2D1B69` | Headings, high-contrast text on light backgrounds |

### Accent — Soft pink (warmth)

| Token | Hex | Usage |
|---|---|---|
| `pink.50` | `#FDF2F6` | Period day backgrounds, soft highlights |
| `pink.200` | `#F9D4E1` | Card borders, soft accents |
| `pink.400` | `#F2A6BF` | Period day markers, gentle highlights |
| `pink.600` ★ | `#E5739A` | **Accent color.** Fertility highlights, key emotional moments |
| `pink.900` | `#6B1F3F` | Dark accent text |

### Neutrals — Warm grays

| Token | Hex | Usage |
|---|---|---|
| `surface.bg` | `#FAFAF9` | App background |
| `surface.card` | `#FFFFFF` | Card backgrounds |
| `surface.muted` | `#F4F2EE` | Subtle dividers, disabled states |
| `text.muted` | `#A8A29E` | Secondary text, captions |
| `text.body` | `#57534E` | Body text |
| `text.heading` | `#1C1B1A` | Heading text |

### Semantic colors (for status)

| Token | Hex | Usage |
|---|---|---|
| `success` | `#16A34A` | Confirmation, positive states |
| `warning` | `#EAB308` | Cautions, soft alerts |
| `error` | `#DC2626` | Errors, critical alerts (use sparingly) |
| `info` | `#0EA5E9` | Informational messages |

---

## 3. Typography

**Font family:** DM Sans

DM Sans is loaded via Google Fonts. Only two weights are used in ARIELA: **400 (regular)** and **500 (medium)**. We never use 600+ — it gets too heavy for our soft, approachable tone.

### Type scale

| Style | Size | Weight | Line height | Usage |
|---|---|---|---|---|
| H1 | 32px | 500 | 1.2 | Screen titles, greeting |
| H2 | 22px | 500 | 1.3 | Section headers |
| H3 | 18px | 500 | 1.4 | Card titles |
| Body large | 16px | 400 | 1.6 | Primary body text |
| Body | 14px | 400 | 1.5 | Standard body |
| Caption | 12px | 400 | 1.4 | Labels, metadata |
| Tiny | 11px | 400 | 1.3 | Timestamps, fine print |

### Letter spacing

- Headings: `-0.01em` (slightly tight)
- Body: `0` (default)
- All caps labels: `0.08em` (loose)

---

## 4. Logo

### Primary mark

The ARIELA logo is a **soft teardrop petal mark** — three teardrop-shaped petals meeting at a center point.

- Petal 1 (top): `#6B5DD3` (lavender.600)
- Petal 2 (bottom-left): `#9B8FE5` (lavender.400)
- Petal 3 (bottom-right): `#E5739A` (pink.600)
- Center dot: matches background color (white on light, brand color on dark)

### Logo variants

1. **Full logo** — petal mark + wordmark (use in marketing, splash screen, README)
2. **Symbol only** — petal mark alone (use as app icon, favicon, small contexts)
3. **Wordmark only** — "ariela" in DM Sans Medium (use in tight horizontal spaces)
4. **Reverse** — white version on lavender 900 background (use on dark backgrounds)

### Clear space

Always maintain a minimum clear space around the logo equal to the height of the petal mark.

### Minimum sizes

- Full logo: 80px wide minimum
- Symbol only: 24px minimum
- Below 24px, use a simplified single-color version

---

## 5. Spacing & layout

### Spacing scale (multiples of 4px)

`4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 48 · 64`

### Border radius

| Token | Value | Usage |
|---|---|---|
| `radius.sm` | 8px | Chips, small buttons |
| `radius.md` | 14px | Cards, inputs |
| `radius.lg` | 20px | Hero cards, modal sheets |
| `radius.xl` | 26px | Phone-frame contexts |
| `radius.full` | 9999px | Pills, circular buttons |

### Shadows

ARIELA uses very subtle shadows — softness is more important than depth.

```
shadow-card: 0 1px 2px rgba(28, 27, 26, 0.04)
shadow-elevated: 0 4px 12px rgba(28, 27, 26, 0.08)
shadow-overlay: 0 12px 32px rgba(28, 27, 26, 0.16)
```

---

## 6. Iconography

- **Source:** Lucide Icons (or Phosphor Icons as alternative)
- **Stroke weight:** 1.5px
- **Default size:** 20px
- **Default color:** `text.body` (`#57534E`)
- Never use multicolored or filled icons — outline style only

---

## 7. Photography & illustration

For the MVP, ARIELA uses **abstract illustrations**, not photography. Reasons:

- Illustrations work for all skin tones, body types, and ages
- More inclusive than stock photography
- Visually coherent with the soft, modern brand
- Easier to iterate and update

**Illustration style:**

- Soft, rounded shapes
- Lavender + pink palette (matching brand colors)
- No human faces — abstract bodies, organic shapes, nature motifs
- Always non-clinical, never medical-illustration style

---

## 8. Don'ts

- ❌ Don't use heavy bolds (700+) anywhere in the app
- ❌ Don't use pure black `#000000` — always warm `#1C1B1A`
- ❌ Don't use cool grays — only warm grays (slight brown undertone)
- ❌ Don't put pink and lavender in equal proportion — lavender dominates
- ❌ Don't use medical iconography (pills, syringes, hearts with EKG lines)
- ❌ Don't use pure red `#FF0000` — soft red `#DC2626` only, sparingly
- ❌ Don't infantilize the design (no cartoon characters, no excessive emoji)
