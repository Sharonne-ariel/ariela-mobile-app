# Roadmap

Phased plan for taking ARIELA from concept to App Store launch over 4-6 months.

**Status:** v1
**Total estimated effort:** ~400-500 hours
**Timeline:** 4-6 months at 20+ hours/week

---

## Phase 0 — Foundation (DONE ✅)

**Duration:** 1 week
**Status:** Complete

Deliverables:
- ✅ Brand identity (name, colors, typography, logo, tagline)
- ✅ Business model (freemium, 14-day trial, pricing)
- ✅ User personas (4 personas)
- ✅ Technical architecture
- ✅ Documentation foundation

---

## Phase 1 — Design & setup (Weeks 2-4)

**Duration:** 3 weeks
**Goal:** Have a complete Figma design system + GitHub repo + initialized Flutter project.

### Week 2: Project setup
- [ ] Create GitHub repo with full structure
- [ ] Create Trello board with all initial cards
- [ ] Set up Supabase project (EU region)
- [ ] Set up OpenAI account + API key
- [ ] Set up RevenueCat account
- [ ] Initialize Flutter project locally
- [ ] Configure branding tokens in Flutter (colors, typography)
- [ ] Set up basic project structure (lib/ folders)

### Week 3: Figma wireframes
- [ ] Create Figma project with brand tokens
- [ ] Design onboarding flow (8-10 screens)
- [ ] Design home screen (cycle tracker view)
- [ ] Design cycle calendar view
- [ ] Design symptom logging flow
- [ ] Design Profile / Settings screens
- [ ] Design First Period Mode screens
- [ ] Design AI assistant chat interface

### Week 4: Figma high-fidelity + premium screens
- [ ] Design paywall screen
- [ ] Design Premium feature previews
- [ ] Design Fertility Mode mockups
- [ ] Design Pregnancy Mode mockups
- [ ] Design Postpartum Mode mockups
- [ ] Component library (buttons, inputs, cards)
- [ ] Design system documentation in Figma

---

## Phase 2 — Core MVP (Weeks 5-10)

**Duration:** 6 weeks
**Goal:** Functional free-tier app with cycle tracking working end-to-end.

### Week 5: Authentication & onboarding
- [ ] Implement Supabase Auth integration
- [ ] Build sign-up screen (email)
- [ ] Build sign-in screen (email)
- [ ] Implement Google Sign In
- [ ] Implement Apple Sign In
- [ ] Build onboarding flow (welcome screens)
- [ ] Build initial cycle setup screen

### Week 6: Cycle tracker core
- [ ] Build calendar view component
- [ ] Implement period logging
- [ ] Implement symptom logging
- [ ] Set up Hive local database
- [ ] Implement Supabase sync logic
- [ ] Build cycle history view

### Week 7: Cycle predictions & home
- [ ] Implement basic cycle prediction algorithm
- [ ] Build home screen with cycle ring
- [ ] Implement quick-action chips
- [ ] Build settings screen
- [ ] Set up notifications (FCM)
- [ ] Implement period reminders

### Week 8: First Period Mode + Safe Mode
- [ ] Build First Period Mode educational screens
- [ ] Curate / write 15 educational articles (FR + EN)
- [ ] Build Safe Mode interface
- [ ] Implement fertile window calculation
- [ ] Add disclaimers

### Week 9: Bilingual support
- [ ] Set up flutter_localizations
- [ ] Extract all strings to ARB files
- [ ] Translate all strings to FR
- [ ] Translate all strings to EN
- [ ] Build language switcher
- [ ] Test full app in both languages

### Week 10: Polish & free-tier complete
- [ ] Implement dark mode
- [ ] Accessibility audit (semantic labels, contrast)
- [ ] Performance optimization
- [ ] Bug fixing
- [ ] Internal testing of free tier end-to-end

**Milestone:** Free-tier MVP complete, ready for premium implementation.

---

## Phase 3 — Premium features (Weeks 11-16)

**Duration:** 6 weeks
**Goal:** All premium modules working, paywall implemented, AI assistant functional.

### Week 11: Subscription infrastructure
- [ ] Integrate RevenueCat SDK
- [ ] Configure offerings (monthly, annual)
- [ ] Configure 14-day free trial
- [ ] Build paywall screen
- [ ] Implement subscription status sync
- [ ] Test trial flow end-to-end

### Week 12: AI assistant
- [ ] Set up Supabase Edge Function for OpenAI proxy
- [ ] Implement system prompts (FR + EN)
- [ ] Build chat interface
- [ ] Implement model routing (gpt-4o-mini default, gpt-4o for complex)
- [ ] Implement crisis detection
- [ ] Implement disclaimers in every response
- [ ] Save conversation history

### Week 13: Fertility Mode
- [ ] Build Fertility Mode home screen
- [ ] Implement ovulation prediction
- [ ] Build BBT tracking interface
- [ ] Build cervical mucus tracking
- [ ] Build pre-conception checklist
- [ ] Implement appointment reminders

### Week 14: Pregnancy Mode
- [ ] Build Pregnancy Mode home screen
- [ ] Implement week-by-week content (FR + EN)
- [ ] Build pregnancy symptom tracker
- [ ] Build appointment manager
- [ ] Build hospital bag checklist
- [ ] Build birth plan template
- [ ] Build contraction timer

### Week 15: Postpartum Mode
- [ ] Build Postpartum Mode home screen
- [ ] Build recovery tracker
- [ ] Build breastfeeding tracker
- [ ] Build baby sleep tracker
- [ ] Build mood / mental health tracker
- [ ] Implement postpartum depression screening
- [ ] Build crisis resources screen

### Week 16: Advanced insights & polish
- [ ] Implement advanced cycle insights
- [ ] Build symptom pattern detection
- [ ] Build PDF export functionality
- [ ] Polish all premium screens
- [ ] Internal testing of premium tier end-to-end

**Milestone:** Full app feature-complete.

---

## Phase 4 — Testing & launch prep (Weeks 17-20)

**Duration:** 4 weeks
**Goal:** App Store and Google Play submission ready.

### Week 17: QA & bug fixing
- [ ] Comprehensive manual testing on iOS
- [ ] Comprehensive manual testing on Android
- [ ] Test on multiple device sizes
- [ ] Test offline / poor connection scenarios
- [ ] Fix all P0 and P1 bugs

### Week 18: Beta testing
- [ ] Recruit 10-20 beta testers
- [ ] Set up TestFlight (iOS)
- [ ] Set up Google Play internal testing
- [ ] Distribute beta builds
- [ ] Collect feedback
- [ ] Iterate on critical issues

### Week 19: Store preparation
- [ ] Create Apple Developer account
- [ ] Create Google Play Console account
- [ ] Write App Store listing (FR + EN)
- [ ] Write Google Play listing (FR + EN)
- [ ] Create screenshots (iOS + Android, multiple sizes)
- [ ] Create marketing video
- [ ] Write Privacy Policy
- [ ] Write Terms of Service
- [ ] Legal review

### Week 20: Submission
- [ ] Submit to Apple App Store
- [ ] Submit to Google Play Store
- [ ] Respond to review feedback
- [ ] Final pre-launch checks
- [ ] **🚀 LAUNCH**

---

## Phase 5 — Post-launch (Months 5-6+)

**Duration:** Ongoing
**Goal:** User feedback, analytics, v1.1 planning.

- Monitor crash reports daily
- Respond to App Store and Play Store reviews
- Track conversion funnel
- Track AI cost per user
- Plan v1.1 features based on feedback

---

## Risks & mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| App Store rejection (medical app guidelines) | Medium | Strict disclaimers, no diagnostic language, legal review pre-submission |
| Scope creep | High | This roadmap is the contract — features outside it go to v2 |
| OpenAI API cost overrun | Medium | Edge Function rate limiting, default to gpt-4o-mini |
| Slow Supabase EU region for African users | Low | Cache aggressively, offline-first architecture |
| Solo developer burnout | Medium | 20h/week is realistic, take breaks, ship imperfectly |
| Translation gaps | Medium | All strings in ARB files from day 1, no hardcoded text |
| RevenueCat integration delays | Low | Start in week 11, leave buffer |

---

## Definition of "Done" for v1

ARIELA v1 is shipped when:

- ✅ Available on App Store
- ✅ Available on Google Play
- ✅ All 6 modules functional
- ✅ AI assistant working with proper disclaimers
- ✅ FR and EN fully supported, no missing translations
- ✅ Subscription flow tested end-to-end
- ✅ 14-day trial works correctly
- ✅ Privacy policy + Terms of service published
- ✅ Onboarding flow polished
- ✅ Beta testers report no critical issues
- ✅ App Store and Play Store ratings prompt configured
