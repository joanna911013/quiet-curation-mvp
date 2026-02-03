# W03_BRIEF — Week 3 (Day 1–Day 5)
Goal: Turn on real delivery, ship emotion logs, harden fallback + ops routine, and finish Week 3 with “must-pass” QA green.

## Week 3 Outcomes (Definition of Done)
- Quiet Invite cron runs reliably (KST 09:00), with dedupe + retries + delivery logs.
- Approved-only pairing is used for Today; safe fallback prevents “blank day.”
- Emotion logging is shipped (with today read-back state).
- End-to-end QA scenarios (must-pass) are executed and recorded.
- Daily Ops Routine (v1) is runnable by an operator (approve → verify → deliver).

## Carry-over (from Week 2 Day 5)
- Dev: add admin-wide select policy for profiles if needed later. (optional)
- DESIGN: Test out with mobile QA checklist (Today/Detail/Saved/Profile) and confirm emotion UI polish.
- OPS: Finalize daily runbook (≤15 min) and spot-check approved pairings for attribution compliance.
- MKT: release notes bullets, quiet invite copy final, and disclaimer trigger rule confirmation.
- MKT : Framer page redesign  (email opt-in web MVP experience)



# Day 1 — Real Delivery Readiness + QA Frame
## DEV
- [x] Choose email provider (Resend or SendGrid) and configure Vercel env vars (Resend selected)
  - `EMAIL_PROVIDER`, provider API key, `EMAIL_FROM` (or provider-specific FROM)
- [x] Validate `/api/cron/quiet-invite` in “real send” mode for 1 test recipient
- [x] Confirm `invite_deliveries` lifecycle: `pending → sent` or `failed (error_message)` (dry-run)
- [x] Verify deep link return works: `/login?redirect=/c/[id]` → login → correct detail page
- [x] Draft the Week 3 E2E QA checklist doc (based on Week2 Day5 “Must Pass”) — `docs/testing/W03_D1_E2E_QA_CHECKLIST.md`

## DESIGN
- [X] Define iOS safe-area/in-app browser QA checklist (Safari + in-app browsers) → `docs/testing/W03_D1_MOBILE_QA_CHECKLIST.md`
- [X] Identify overflow cases to test (long verse, long attribution, long rationale, long titles) → `docs/testing/W03_D1_MOBILE_QA_CHECKLIST.md`

## OPS
- [x] Verify approved pairing inventory for today + next 2–4 days (min 5)
- [x] Record Safe Pairing Set current size and the gap to target (15–20)
  - Safe Pairing Set size: 10 approved (gap: 5–10 to reach 15–20)
  - Inventory + SQL verification kept in DB queries (see `docs/ops/daily_ops_routine_v1.md`)

## MKT
- [x] Confirm Framer page scope for Email Opt-in Web MVP Experience (documented in `09_LANDING_WAITLIST.md`)
- [x] Lock messaging assumptions: “web app + daily email invite at 09:00 KST”

---

# Day 2 — Emotion Logs Ship + Mobile Polish Start
## DEV
- [x] Implement Emotion logging (ship it; feature-flag optional)
  - [x] Primary emotion required
  - [x] Memo optional + length cap (160)
  - [x] Skip policy: choose one
    - Option A: skip does not write
    - Option B: write `skipped=true` record
  - [x] Write + read-back:
    - if event exists for today → “logged today” state
  - [x] Link emotion event to `pairing_id` and/or `curation_id` (recommended)
- [x] Confirm RLS for user-scoped emotion tables (user A cannot see user B)
- [ ] Choose email provider (Resend or SendGrid) and configure Vercel env vars (Resend selected; Vercel envs pending verify)
  - `EMAIL_PROVIDER`, provider API key, `EMAIL_FROM` (or provider-specific FROM)

## DESIGN
- [X] Emotion UI polish: lightweight confirmation state
- [X] Update mobile spacing for long content (overflow + clamp behavior)

## OPS
- [X] Validate emotion taxonomy labels match UI usage (tone: calm, not preachy)

## MKT
- [x] Prepare 3–5 subject line variants for next iteration (EN/KR) — `docs/ops/quiet_invite_copy_variants_vNext.md`
- [x] Confirm pairing snippet rules for email (max 2 lines, calm tone)

---

# Day 3 — Fallback Hardening + Admin Ops Rehearsal
## DEV
- [x] Harden Safe fallback (no blank day)
  - [x] If today pairing missing/unapproved/join_failed → serve Safe Pairing Set item
  - [x] Add admin-only warning in `/admin` dashboard: “Today pairing missing”
- [x] Failure behavior hardening
  - [x] API fail → stable error state + retry (screen-level, not pairing-level)
- [x] Minimal join-failure logging (pairing join fail / today fetch fail)
- [X] Choose email provider (Resend or SendGrid) and configure Vercel env vars (Resend selected; Vercel envs pending verify)
  - `EMAIL_PROVIDER`, provider API key, `EMAIL_FROM` (or provider-specific FROM)

## DESIGN
- [x] Ensure fallback UI behavior is subtle (not an error, no banners) — `docs/design/day3_fallback_admin_ui_spec.md`
- [x] Admin warning styling: quiet/inline (no aggressive callout) — `docs/design/day3_fallback_admin_ui_spec.md`

## OPS
- [x] Run 1 rehearsal of Daily Ops Routine (draft v1)
  - [x] Approve tomorrow’s curation
  - [x] Approve pairing snapshot for date+locale
  - [x] Verify Today renders + attribution
  - [x] Verify email preview + deep link
  - [x] Trigger missing-today scenario and confirm safe fallback appears

## MKT
- [x] Confirm disclaimer triggers + wording (only when needed) — `docs/ops/microcopy_keys_kr_en.md`
- [x] Start release-notes bullets draft (Week 3 wrap-up) — `docs/ops/release_notes_v0.1_user_facing.md`

---

# Day 4 — End-to-End QA “Must Pass” Execution
## DEV (Must Pass)
- Execution notes: `docs/testing/W03_D4_E2E_QA_EXECUTION_NOTES.md`
- [ ] New user flow: `/login → / → open detail → save → /saved`
- [ ] Email deep link: open email → login (if needed) → correct `/c/[id]`
- [ ] Admin operation:
  - [ ] create curation → approve → set today
  - [ ] create pairing → approve for today
  - [ ] Today shows both
- [ ] Permissions:
  - [ ] user A cannot see user B saved/emotion
- [ ] Data integrity:
  - [ ] verse shown exists in `verses`
  - [ ] if today pairing removed → safe fallback appears
- [ ] Failure behavior:
  - [ ] simulate API fail → stable error state + retry works

## DESIGN
- [X] Mobile QA pass after UI changes land (iOS safe-area, overflow, spacing) - `docs/testing/W03_D1_MOBILE_QA_CHECKLIST.md`

## OPS
- [X] Run daily review: sample 3 pairings and verify guardrails
  - tone + attribution + verse correctness

## MKT
- [x] Apply Framer page polish (copy + layout + FAQs) — `09_LANDING_WAITLIST.md`
- [x] Pick default subject line(s) for Week 3 sending (default: “Today’s reading” / “오늘의 읽기”)

---

# Day 5 — Stabilize + Week 3 Closeout (Docs/Notes)
## DEV
- [x] Security/Config review
  - [x] env secrets safe
  - [x] server-only keys remain server-side
  - [x] RLS policies correct for user-scoped tables (saved/emotion/etc.)
- [x] Observability (MVP)
  - [x] minimal logs for: delivery success/fail, today fetch fail, pairing join fail, emotion save fail
  - [x] cron response includes summary counts (sent/failed/skipped/retried)
- [x] Record Week 3 notes + carry-overs into weekly docs

## DESIGN
- [x] Consolidate specs (avoid duplication) and confirm “quiet vibe” checklist passes
- [ ] Final mobile polish checklist recorded — `docs/testing/W03_D5_MOBILE_QA_EXECUTION_LOG.md`
- [ ] iOS/Android dark mode QA + adjustments (ensure no unintended theme shift)
- [ ] Email template QA (mobile mail clients: spacing + readability) — `docs/testing/W03_D4_EMAIL_TEMPLATE_QA.md`

## OPS
- [x] Finalize “Daily Ops Routine” (v1) doc for Week 2 system
  - approve tomorrow’s curation
  - generate/select verse pairing
  - approve pairing snapshot for date+locale
  - verify Today rendering + attribution
  - verify email preview + deep link
  - spot-check 3 pairings + check missing-today warnings
- [ ] Expand Safe Pairing Set toward 15–20 items (target 20)

## MKT
- [x] Release notes (user-facing) bullets finalized — `docs/ops/release_notes_v0.1_user_facing.md`
  - “Today now includes a verse pairing”
  - “Optional emotion reflection”
- [x] Finalize email copy variants + subject lines for next iteration — `docs/ops/quiet_invite_copy_variants_vNext.md`

---

## Week 3 Notes + Carry-overs (recorded 2026-01-30)
- DEV: Resend real sending verified; cron summary output confirmed; domain + Vercel envs verified.
- DEV: Pairings schema update shipped (rename `rationale_short` -> `rationale`, add `explanations`, remove word/char limits); detail page now shows full rationale + explanations.
- DEV: Failure retry UI added for Today/Detail; observability logs in place.
- DEV: Security/config checklist added (`docs/testing/W03_D5_SECURITY_CONFIG_CHECKLIST.md`); profiles role escalation blocked via policy.
- DEV carry-over: iOS webview auth cookie persistence QA (pending in security checklist).
- DEV carry-over: Finish Day4 E2E QA execution notes for remaining scenarios.
- OPS carry-over: Expand Safe Pairing Set toward 15–20 items (target 20).

## Week 4 Carry-over (Not Done in Week 3)
- DEV: Complete Day 4 E2E QA scenarios + fill execution notes (`docs/testing/W03_D4_E2E_QA_EXECUTION_NOTES.md`).
- DEV: Stabilize iOS in-app auth flow (magic link + redirect consistency).
- DESIGN: Final mobile polish checklist log (`docs/testing/W03_D5_MOBILE_QA_EXECUTION_LOG.md`).
- DESIGN: Email template QA log (`docs/testing/W03_D4_EMAIL_TEMPLATE_QA.md`).
- DESIGN: iOS/Android dark mode QA + adjustment notes.
- OPS: Expand Safe Pairing Set to 15–20 items.
- MKT: Confirm email opt-in page live + release notes final review (if not already verified).

---

## Week 3 Deliverables (Artifacts)
- [ ] E2E QA checklist + execution notes (pass/fail + gaps)
- [x] Updated Daily Ops Routine (v1)
- [x] Emotion logging shipped + verified
- [x] Safe fallback hardening verified (no blank day)
- [x] Minimal observability logging in place
- [ ] Framer email opt-in experience page polished (copy + structure)

---

