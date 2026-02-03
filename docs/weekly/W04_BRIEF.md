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
- [ ] Expand Safe Pairing Set to 15–20 items; log count + date in ops notes.
- [X] Run daily ops dry‑run (approve tomorrow, verify Today rendering, verify email preview) and note time to complete.

### MKT
- [ ] Verify Framer opt‑in page live state (copy/layout/CTA) and note issues.
- [ ] Update release‑notes draft if QA finds user‑visible changes.
- Note: Live page verification blocked in tooling (fetch failed). Needs manual check.

---

## Day 2 — Mobile + Email QA Fixes
### DEV
- [X] Fix issues from mobile QA log (safe‑area, overflow, spacing) and update log with “fixed in build X”.
- [X] If iOS in‑app auth still fails, apply redirect/cookie fixes and re‑test.

### DESIGN
- [ ] Execute email template QA and record results in `docs/testing/W03_D4_EMAIL_TEMPLATE_QA.md`.
- [ ] Draft dark‑mode decision options: **lock light** vs **support dark**, with pros/cons and recommended choice.

### OPS
- [ ] Verify Safe Pairing Set health after additions (spot‑check 3 items).
- [ ] Spot‑check 3 pairings for attribution + verse correctness; record any fixes.

### MKT
- [ ] (Carry-over) Verify Framer opt‑in page live state (copy/layout/CTA) and note issues.
- [ ] (Carry-over) Update release‑notes draft if QA finds user‑visible changes.
- [ ] Finalize Week 4 send: subject + preheader (EN/KR).
- [ ] Align quiet‑tone copy with any UX changes (if needed).

---

## Day 3 — Dark Mode Decision + Spec Updates
### DEV
- [ ] Implement dark‑mode handling per decision (lock light or tuned palette).
- [ ] Re‑verify hydration + auth flows after change.

### DESIGN
- [ ] Update design specs with dark‑mode decision + QA notes (add to `docs/design/specs_index.md` references if needed).
- [ ] Re‑run quiet‑vibe checklist; note PASS/FAIL in `docs/design/day4_visual_hierarchy_spec.md` if changed.

### OPS
- [ ] Run daily ops routine end‑to‑end and record total time.

### MKT
- [ ] Draft short “what’s new” note (only if UX changed).

---

## Day 4 — Regression + Sign‑off
### DEV
- [ ] Regression sweep (login, Today, Detail, Saved, Emotion); update `docs/testing/W03_D4_E2E_QA_EXECUTION_NOTES.md`.
- [ ] Validate email deep‑link → login → detail on Vercel URL.

### DESIGN
- [ ] Sign‑off on mobile polish + dark‑mode adjustments; update QA logs as PASS.

### OPS
- [ ] Confirm next 3–5 days of pairings ready (approved + attribution ok).

### MKT
- [ ] Final review of opt‑in page + email copy; confirm send timing.

---

## Day 5 — Release Readiness Wrap‑up
### DEV
- [ ] Final config check (prod envs, Supabase URLs, cron secret) and update security checklist.
- [ ] Record remaining carry‑overs into weekly notes.

### DESIGN
- [ ] Mark mobile QA + dark‑mode QA as complete in the logs.

### OPS
- [ ] Confirm Daily Ops Routine v1 stable (2 consecutive runs logged).

### MKT
- [ ] Approve final release note wording + launch timing.

---

# Week 5–Week 8 (High-level Plan, clarified)


## Week 5 — Post‑v1 Iteration + Newsletter Track
**Outcome:** Newsletter infrastructure + first content spec ready.

**DEV**
- Define newsletter data model + send pipeline (separate from daily invite).
- Add basic analytics events (open detail, save, emotion logged).

**DESIGN**
- Newsletter content card spec + email layout constraints.

**OPS**
- Inventory discipline: tomorrow + safe set always ready.

**MKT**
- Newsletter onboarding copy (why it’s different, cadence, examples).

## Week 6 — v2 “For You” Light Personalization
**Outcome:** Small personalization module with guardrails.

**DEV**
- Implement 2–3 “For you” recommendations (emotion‑based rerank).
- Add caching + guardrails (never blank day, never break send).

**DESIGN**
- “For you” module design (quiet, secondary, no feed vibe).

**OPS**
- Define quality/safety acceptance checks for “For you.”

**MKT**
- Messaging for v2: “2–3 quiet suggestions, based on what you felt.”

## Week 7 — Mobile Packaging Track (Optional)
**Outcome:** Capacitor prototype ready for review.

**DEV**
- Capacitor wrapper with auth + deep‑link routing + offline basics.
- Add Universal Links (iOS) / App Links (Android) so email magic‑links open the app directly (avoid in‑app browser auth failures).
- Decide push strategy (web push vs native later).

**DESIGN**
- Store listing basics (icon + 3–5 screenshots + short copy).

**OPS**
- Operational readiness for dual distribution (web + wrapper).

**MKT**
- Pre‑launch narrative draft for mobile packaging.

## Week 8 — v2 Stabilization + Store Submission (if wrapper ships)
**Outcome:** Store submission and stabilization complete.

**DEV**
- Bug bash + performance pass + final security/RLS audit.
- Submit iOS/Android builds; track review feedback.

**DESIGN**
- Final screenshot set + microcopy sweep.

**OPS**
- Runbook updates for store + web operations.

**MKT**
- Launch sequence: v2 announcement + newsletter cadence alignment.
```
