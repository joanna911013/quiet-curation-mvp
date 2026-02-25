# Quiet Curation - MVP Finish Schedule (Week 5-6)
Last updated: 2026-02-24
Owner: Yoanna
Repos: `quiet-curation-web`, `quiet-curation-mvp`

## 1) Current Snapshot

### Overall P0 Status (as of 2026-02-24)
- [x] P0-1 Subscribe flow decision + implementation
- [ ] P0-2 Release QA gate full close (run 1 done, final full rerun pending)
- [x] P0-3 Stability baseline cleanup
- [x] P0-4 Final docs sync (phase-level source-of-truth updated)

### Completed (confirmed)
- [x] Landing page story and visual structure are implemented (`/landing`).
- [x] Screen-loop section is implemented and refined.
- [x] Sample section is updated with real pairing content.
- [x] Emotion record preview section is added to landing.
- [x] Marketing CTA tracking is wired:
  - `lp_view`, `lp_cta_subscribe_click`, `lp_cta_secondary_click`, `sub_view`, `sub_cta_request_click`.
- [x] Localized marketing routes exist:
  - `/ko/landing`, `/ko/subscribe` (EN canonical routes remain `/landing`, `/subscribe`).
- [x] Localized marketing runtime mismatch fixed:
  - `/ko/landing`, `/ko/subscribe` resolve in production start smoke.
- [x] Subscribe page placeholder removed; request flow now sends magic link via Supabase Auth (`/subscribe`).
- [x] Lint blocker in `quiet-curation-web/app/login-client.tsx` resolved.
- [x] P0-2 release QA gate run 1 executed and logged:
  - `docs/testing/W05_D1_RELEASE_QA_GATE_LOG.md`.

### Remaining (blocking MVP finish)
- [ ] Release gate still has open FAIL/BLOCKED items (admin runtime actions, sign-out/mobile QA).
- [ ] Internationalization is partial (many app strings still EN-first).
- [ ] Final launch docs need one more pass after remaining QA blockers are closed.

---

## 2) MVP Finish Definition (Done Criteria)
MVP is considered finish-ready only when all below are true:

1. Conversion flow is real and testable:
   - `/landing` -> `/subscribe` -> persisted opt-in (or explicit external form handoff with success signal).
2. Daily product loop is stable:
   - `Today -> Detail -> Emotion (or Skip) -> Done` works without blockers.
3. Content safety and ops are verified:
   - approved-only display, fallback behavior, and cron invite path validated.
4. Core release QA passes with evidence logs.
5. Launch docs and links are up to date and consistent.

---

## 3) Priority Plan (P0 / P1)

## P0 - Must finish before MVP close

### P0-1. Subscribe flow decision + implementation
- Decision to lock (same day):
  - Option A: Keep external form handoff (fastest), or
  - Option B: Persist directly in Supabase (`profiles.notification_opt_in` or dedicated table).
- Required output:
  - No placeholder CTA behavior.
  - Clear success/failure state.
  - Event tracking from click to completion.

### P0-2. Release QA gate execution
- Run and record pass/fail for:
  - Auth/login flow
  - Today/Detail data completeness
  - Save/Unsave and RLS isolation
  - Emotion log constraints
  - Cron dedupe and fallback behavior
- Required output:
  - One checklist file with explicit pass/fail + issue owner.

### P0-3. Stability baseline cleanup
- Fix at least blocking lint/runtime issues before close:
  - `quiet-curation-web/app/login-client.tsx` effect/setState lint error.
- Required output:
  - Build green, no new regressions.

### P0-4. Final docs sync
- Update source-of-truth docs to current phase and links.
- Required output:
  - `00_MASTER_BRAIN.md` and weekly index reflect Week 5-6 closeout state.

## P1 - Nice to have (if P0 complete early)
- KO copy parity for marketing text.
- OG image / social preview polish.
- Small mobile polish pass from latest QA notes.

---

## 4) Execution Schedule (Revised)

## Day 1 - Lock decisions and remove placeholders
- DEV:
  - Implement chosen subscribe path (A or B).
  - Keep event tracking intact.
- MKT:
  - Finalize subscribe microcopy (success, privacy, unsubscribe expectation).
- OPS:
  - Confirm operational truth (send cadence, opt-out handling).
- Exit:
  - Subscribe CTA is no longer placeholder behavior.

## Day 2 - QA Gate Run 1 (core flows)
- QA + DEV:
  - Execute core user flow and content/data checks.
  - Log issues with severity and owner.
- Exit:
  - P0 blockers list is explicit and prioritized.

## Day 3 - Fix blockers and re-test
- DEV:
  - Fix P0 defects from Day 2.
  - Resolve lint blocker in `login-client.tsx`.
- QA:
  - Re-test only affected scenarios plus smoke.
- Exit:
  - Core flows pass and build remains green.

## Day 4 - Ops and launch readiness
- OPS:
  - Validate cron path, dedupe, fallback, and delivery logs.
- MKT:
  - Final landing/subscription copy lock.
- Exit:
  - Ops readiness confirmed with brief evidence.

## Day 5 - Freeze and close MVP
- Final regression smoke.
- Update master docs and release summary.
- Tag MVP close candidate.
- Exit:
  - MVP close checklist fully checked.

---

## 5) Owners and Accountability
- DEV owner: implement flow, fix blockers, keep build green.
- QA owner: execute release gates and maintain pass/fail log.
- OPS owner: validate invite operations and claims.
- MKT owner: lock conversion copy and distribution-ready messaging.

---

## 6) Immediate Next Actions (This Week)
- [x] Decide subscribe path (B: in-app persistence via magic-link confirmation and `profiles`).
- [x] Remove `/subscribe` placeholder behavior.
- [x] Run first full release QA pass and produce issue list.
- [x] Fix lint blocker in `app/login-client.tsx`.
- [x] Refresh master docs after QA pass (Week 5-6 source-of-truth updated).
- [x] Fix `/search-check` SQL mismatch and rerun targeted QA check.
- [ ] Re-run full QA gate log after `/search-check` fix.
- [ ] Complete remaining manual QA:
  - magic-link callback/sign-out, admin approve/set-today timing, mobile viewport checks.

## Notes
- This schedule replaces narrative-heavy planning with finish-oriented execution.
- Any new scope must be marked P1 and cannot delay P0 close.
