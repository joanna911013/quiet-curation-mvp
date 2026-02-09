## Week 4 — v1 “Web MVP” Release Readiness
**Outcome:** QA complete, auth stable on iOS, mobile polish + dark‑mode decision locked, ops routine stable.

**DEV**
- Close all E2E QA scenarios and document pass/fail.
- Confirm auth + redirect stability on Vercel URL (iOS Safari + in‑app).
- Finalize prod config checklist (envs, secrets, cron).

**DESIGN**
- Mobile polish QA log completed.
- Dark‑mode decision documented (lock light or tuned palette) + spec update.

**OPS**
- Safe Pairing Set at 15–20 items.
- Daily Ops Routine executed 2+ consecutive days with timing.

**MKT**
- Opt‑in page verified live.
- Release note copy finalized for launch.

**Milestone**
- v1 go‑live readiness sign‑off.

## Day 1 — QA Completion + Auth Stability
### DEV
- [X] Complete remaining W03 Day 4 E2E scenarios and fill `docs/testing/W03_D4_E2E_QA_EXECUTION_NOTES.md` (pass/fail + notes per scenario).
- [X] Verify magic‑link flow on **Vercel URL** in iOS Safari + in‑app browser (record outcome in execution notes).
- [X] Confirm env + redirect consistency (Supabase Site URL, Redirect URLs, `SITE_URL`, `NEXT_PUBLIC_SITE_URL`) and log final values in `docs/testing/W03_D5_SECURITY_CONFIG_CHECKLIST.md`

### DESIGN
- [X] Run final mobile polish QA and fill `docs/testing/W03_D5_MOBILE_QA_EXECUTION_LOG.md` with device/browser versions + pass/fail.
- [X] Start dark‑mode audit (iOS + Android): list unintended theme shifts and affected screens — `docs/testing/W04_D1_DARK_MODE_AUDIT.md`

### OPS
- [X] Expand Safe Pairing Set to 15–20 items; log count + date in ops notes.
- [X] Run daily ops dry‑run (approve tomorrow, verify Today rendering, verify email preview) and note time to complete.

### MKT
- [ ] Verify Framer opt‑in page live state (copy/layout/CTA) and note issues.
- [ ] Update release‑notes draft if QA finds user‑visible changes.

---

## Day 2 — Mobile + Email QA Fixes
### DEV
- [ ] Fix issues from mobile QA log (safe‑area, overflow, spacing) and update log with “fixed in build X”.
- [ ] If iOS in‑app auth still fails, apply redirect/cookie fixes and re‑test.

### DESIGN
- [ ] Execute email template QA and record results in `docs/testing/W03_D4_EMAIL_TEMPLATE_QA.md`.
- [ ] Draft dark‑mode decision options: **lock light** vs **support dark**, with pros/cons and recommended choice.

### OPS
- [ ] Verify Safe Pairing Set health after additions (spot‑check 3 items).
- [ ] Spot‑check 3 pairings for attribution + verse correctness; record any fixes.

### MKT
- [ ] Finalize Week 4 send: subject + preheader (EN/KR).
- [ ] Align quiet‑tone copy with any UX changes (if needed).

---

## Day 3 — Dark Mode Decision + Spec Updates
### DEV
- [X] Implement dark‑mode handling per decision (lock light or tuned palette).
- [X] Re‑verify hydration + auth flows after change.

### DESIGN
- [X] Update design specs with dark‑mode decision + QA notes (add to `docs/design/specs_index.md` references if needed).
  - Updated: `docs/design/dark_mode_spec.md`, `docs/design/specs_index.md`
- [X] Re‑run quiet‑vibe checklist; note PASS/FAIL in `docs/design/day4_visual_hierarchy_spec.md` if changed.
  - Updated: PASS (2026-02-04)

### OPS
- [X] Run daily ops routine end‑to‑end and record total time.

### MKT
- [ ] Draft short “what’s new” note (only if UX changed).

---

## Day 4 — Regression + Sign‑off
### DEV
- [X] Regression sweep + deep‑link validated (see `docs/testing/W03_D4_E2E_QA_EXECUTION_NOTES.md`).

### DESIGN
- [X] Sign‑off on mobile polish + dark‑mode adjustments; update QA logs as PASS.

### OPS
- [X] Confirm next 3–5 days of pairings ready (approved + attribution ok).

### MKT
- [ ] Final review of opt‑in page + email copy; confirm send timing.
  - If blocked, carry over to Day 5.

---

## Day 5 — Release Readiness Wrap‑up
### DEV
- [X] Final config check (prod envs, Supabase URLs, cron secret) and update security checklist (only if not already logged).
- [X] Record any remaining carry‑overs into weekly notes (skip if none).
  - None identified on 2026-02-06.

### DESIGN
- [X] Mark mobile QA + dark‑mode QA as complete in the logs (if not already marked PASS).

### OPS
- [ ] Confirm Daily Ops Routine v1 stable (2 consecutive runs logged).

### MKT
- [ ] Approve final release note wording + launch timing.
- [ ] If Day 4 MKT review is still pending, complete it here.

---

# Week 5–Week 8 (Detailed Plan, iOS Wrapper Focus)
Decision: iOS wrapper (Capacitor) is the primary track; Android wrapper is optional later.

## Week 5 — iOS Wrapper Kickoff + Newsletter (Secondary)
**Outcome:** iOS wrapper boots, deep links work in TestFlight, newsletter spec drafted.

**DEV**
- Initialize Capacitor wrapper and iOS project (bundle id, app icon placeholders, build).
- Universal Links: configure associated domains + deep link routing (`/c/[id]`).
- Auth in wrapper: magic‑link → app → login → redirect to deep link.
- TestFlight internal build + basic install checklist.
- Newsletter: define data model + send pipeline (separate from daily invite).
- Add basic analytics events (open detail, save, emotion logged).

**DESIGN**
- iOS wrapper audit: status bar, safe areas, default fonts, in‑app browser fallback.
- Newsletter content card spec + email layout constraints.

**OPS**
- Inventory discipline: tomorrow + safe set always ready.
- Add iOS wrapper QA checklist to ops routine (install → login → Today → Detail).

**MKT**
- Update opt‑in copy to mention iOS TestFlight (if applicable).
- Newsletter onboarding copy (why it’s different, cadence, examples).

## Week 6 — iOS Wrapper MVP + QA
**Outcome:** Wrapper stable on iOS; deep links + auth reliable; QA log complete.

**DEV**
- Fix iOS wrapper issues from QA (auth edge cases, deep‑link fallbacks).
- Add offline‑safe empty states + retry behavior.
- Add app‑specific config toggles (web vs app) if needed.

**DESIGN**
- iOS UI tweaks (spacing, tap targets, safe‑area padding).
- Confirm wrapper‑specific empty/error states are calm.

**OPS**
- Run iOS wrapper QA on 2 devices; log pass/fail.

**MKT**
- Draft iOS TestFlight invite copy + troubleshooting FAQ.

## Week 7 — Store Prep (iOS Primary, Android Optional)
**Outcome:** App Store submission package ready; Android decision made.

**DEV**
- Finalize iOS signing, versioning, and App Store metadata fields.
- Add App Links on Android only if Android wrapper is approved.
- Decide push strategy (none vs later) and document.

**DESIGN**
- Store listing basics (icon + 3–5 screenshots + short copy).
- Finalize splash + app icon assets.

**OPS**
- Operational readiness for dual distribution (web + iOS app).

**MKT**
- Pre‑launch narrative draft for iOS wrapper.

## Week 8 — Submission + Stabilization
**Outcome:** App submitted, stabilization in place, v2 roadmap re‑prioritized.

**DEV**
- Bug bash + performance pass + final security/RLS audit (app + web).
- Submit iOS build; track review feedback and fixes.
- (Optional) Android submission if approved in Week 7.

**DESIGN**
- Final screenshot set + microcopy sweep (store + in‑app).

**OPS**
- Runbook updates for store + web operations.

**MKT**
- Launch sequence: iOS availability + newsletter cadence alignment.
```
