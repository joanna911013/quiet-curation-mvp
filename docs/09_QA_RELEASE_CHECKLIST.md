# 09 QA Release Checklist
Last updated: 2026-01-22

Release checklist and QA gate references for the MVP. This doc summarizes the current gates and archives prior gate reviews.

## Current Release Gates (Week 2)
- Approved-only pairings visible to users.
- Today join returns verse text + canonical_ref + translation, or clean fallback.
- No blank day: safe set fallback verified.
- Quiet invite delivery dedupe verified (1 send per user per day).
- Save/Unsave regression check after Today join changes.
- Admin can set pairing in <= 3 minutes (Day 4 gate).

## Links
- Execution plan gates: `weekly/W02_EXECUTION_PLAN.md`
- Decisions log: `weekly/W02_DECISIONS_LOG.md`

## Appendix: Week 1 Friday Gate Review (2026-01-17)
### DEV Acceptance (12:00)
- Navigation (Today -> Emotion -> Done -> back): PASS
- l10n (/ko, /en): PASS
- Platform check:
  - Chrome mobile emulation: PASS
  - iOS/Android device/simulator: PASS

### Gate Checklist
- App flow works (S1->S4) without crashes: PASS
- i18n exists + core strings localized: PASS
- Supabase DEV exists + schema created + RLS defined: PASS
- Design system MD exists (fonts/spacing/microcopy): PASS
- Prompts library MD exists (Curator + Critic): PASS
- Next week brief drafted (W02): PASS

### Notes
- No blockers found during DEV acceptance checks.

### Decision
- Gate: PASS

### Week 2 Starts With
- Continue building on top of the stable foundation (no urgent fixes).
