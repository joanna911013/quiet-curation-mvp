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
- [ ] Choose email provider (Resend or SendGrid) and configure Vercel env vars (Resend selected; Vercel envs pending verify)
  - `EMAIL_PROVIDER`, provider API key, `EMAIL_FROM` (or provider-specific FROM)
- [ ] Validate `/api/cron/quiet-invite` in “real send” mode for 1 test recipient (waiting on domain verification)
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
  - Inventory and SQL verification logged in `docs/ops/day3_pairing_inventory.md`

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

## DESIGN
- [x] Emotion UI polish: lightweight confirmation state (spec) → `docs/design/day5_emotion_ui_polish.md`
- [x] Update mobile spacing for long content (overflow + clamp behavior) (spec) → `docs/design/day5_mobile_polish_spec.md`
- [x] Apply UI polish in app (per specs): Emotion confirmation + mobile safe-area + overflow clamps

## OPS
- [x] Validate emotion taxonomy labels match UI usage (tone: calm, not preachy)
  - UI uses `lib/emotion.ts` labels that match `docs/ops/emotion_taxonomy.md` (Peace/Anxiety/etc.)

## MKT
- [x] Prepare 3–5 subject line variants for next iteration (EN/KR) — `docs/ops/quiet_invite_copy_variants_vNext.md`
- [x] Confirm pairing snippet rules for email (max 2 lines, calm tone)

---

# Day 3 — Fallback Hardening + Admin Ops Rehearsal
## DEV
- [x] Harden Safe fallback (no blank day)
  - [x] If today pairing missing/unapproved/join_failed → serve Safe Pairing Set item
  - [x] Add admin-only warning in `/admin` dashboard: “Today pairing missing”
- [ ] Failure behavior hardening
  - [ ] API fail → stable error state + retry (screen-level, not pairing-level)
- [x] Minimal join-failure logging (pairing join fail / today fetch fail)

## DESIGN
- [ ] Ensure fallback UI behavior is subtle (not an error, no banners)
- [ ] Admin warning styling: quiet/inline (no aggressive callout)

## OPS
- [ ] Run 1 rehearsal of Daily Ops Routine (draft v1)
  - [ ] Approve tomorrow’s curation
  - [ ] Approve pairing snapshot for date+locale
  - [ ] Verify Today renders + attribution
  - [ ] Verify email preview + deep link
  - [ ] Trigger missing-today scenario and confirm safe fallback appears

## MKT
- [x] Confirm disclaimer triggers + wording (only when needed) — `docs/ops/microcopy_keys_kr_en.md`
- [x] Start release-notes bullets draft (Week 3 wrap-up) — `docs/ops/release_notes_v0.1_user_facing.md`

---

# Day 4 — End-to-End QA “Must Pass” Execution
## DEV (Must Pass)
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
- [ ] Mobile QA pass after UI changes land (iOS safe-area, overflow, spacing)
- [ ] Email template QA (mobile mail clients: spacing + readability)

## OPS
- [ ] Expand Safe Pairing Set toward 15–20 items (target 20)
- [ ] Run daily review: sample 3 pairings and verify guardrails
  - tone + attribution + verse correctness

## MKT
- [x] Apply Framer page polish (copy + layout + FAQs) — `09_LANDING_WAITLIST.md`
- [x] Pick default subject line(s) for Week 3 sending (default: “Today’s reading” / “오늘의 읽기”)

---

# Day 5 — Stabilize + Week 3 Closeout (Docs/Notes)
## DEV
- [ ] Security/Config review
  - [ ] env secrets safe
  - [ ] server-only keys remain server-side
  - [ ] RLS policies correct for user-scoped tables (saved/emotion/etc.)
- [x] Observability (MVP)
  - [x] minimal logs for: delivery success/fail, today fetch fail, pairing join fail, emotion save fail
  - [x] cron response includes summary counts (sent/failed/skipped/retried)
- [ ] Record Week 3 notes + carry-overs into weekly docs

## DESIGN
- [ ] Consolidate specs (avoid duplication) and confirm “quiet vibe” checklist passes
- [ ] Final mobile polish checklist recorded

## OPS
- [ ] Finalize “Daily Ops Routine” (v1) doc for Week 2 system
  - approve tomorrow’s curation
  - generate/select verse pairing
  - approve pairing snapshot for date+locale
  - verify Today rendering + attribution
  - verify email preview + deep link
  - spot-check 3 pairings + check missing-today warnings

## MKT
- [x] Release notes (user-facing) bullets finalized — `docs/ops/release_notes_v0.1_user_facing.md`
  - “Today now includes a verse pairing”
  - “Optional emotion reflection”
- [x] Finalize email copy variants + subject lines for next iteration — `docs/ops/quiet_invite_copy_variants_vNext.md`

---

## Week 3 Deliverables (Artifacts)
- [ ] E2E QA checklist + execution notes (pass/fail + gaps)
- [ ] Updated Daily Ops Routine (v1)
- [x] Emotion logging shipped + verified
- [x] Safe fallback hardening verified (no blank day)
- [x] Minimal observability logging in place
- [ ] Framer email opt-in experience page polished (copy + structure)

---

# Week 4–Week 8 (High-level Plan, Web-first + Capacitor Wrapper Track)

## Week 4 — v1 “Web MVP” release readiness
**DEV**
- [ ] Hardening: safe fallback triggers (missing/unapproved/join_failed) + stable UI contract
- [ ] Security/config review: env separation, server-only keys, tighten service-only tables where appropriate
- [ ] Release notes + final regression sweep
**DESIGN**
- [ ] Apply hierarchy tokens in-app (Today/Detail pairing block) + mobile QA pass
**OPS**
- [ ] “Daily Ops Routine v1” finalized + run it end-to-end for 2–3 consecutive days
**MKT**
- [ ] User-facing release notes bullets + refine subject/copy variants for next iteration
**Milestone**
- [ ] v1 goes live (email opt-in → daily invite → web experience)

## Week 5 — Post‑v1 iteration + newsletter (separate from daily invite)
**DEV**
- [ ] Add newsletter track (separate send type/table or channel/type + opt-in + dedupe key)
- [ ] Add basic analytics events (open detail, save, emotion logged)
**DESIGN**
- [ ] Newsletter content card spec (email-first layout constraints)
**OPS**
- [ ] Content throughput: build inventory discipline (safe set healthy + tomorrow ready)
**MKT**
- [ ] Newsletter onboarding: why it’s different, frequency, samples

## Week 6 — v2 feature work (“For you” light personalization)
**DEV**
- [ ] Mini-spike: Capacitor feasibility + auth/deeplink flow check (1–2 days)
- [ ] Keep Today global; add “For you” 2–3 recs via emotion-based reranking
- [ ] Add minimal caching + guardrails (never blank day, never break send)
- [ ] DB performance check: slow query review + missing index audit (pre-v2)
**DESIGN**
- [ ] “For you” module design (quiet, secondary; no feed vibes)
**OPS**
- [ ] Define acceptance checks for “For you” quality + safety
**MKT**
- [ ] Messaging for v2: “2–3 quiet suggestions, based on what you felt.”

## Week 7 — Mobile packaging track (parallel, optional)
**DEV**
- [ ] Capacitor wrapper build: auth + deep link routing, offline/PWA basics, privacy manifest/app tracking declarations
- [ ] Push strategy decision: web push for PWA vs native push later
**DESIGN**
- [ ] Store listing basics: icon, screenshots, minimal brand pack
**OPS**
- [ ] Operational readiness for dual distribution (web + wrapper)
**MKT**
- [ ] Pre-launch narrative: “the quietest place on your phone” positioning (understated)

## Week 8 — v2 stabilization + store submissions (if wrapper ships)
**DEV**
- [ ] Bug bash, performance pass, final RLS/security audit
- [ ] DB/index final review (pre-store submissions)
- [ ] Submit iOS/Android wrapper builds; monitor review feedback
- [ ] Buffer for store review feedback + iteration (plan 1–2 weeks if needed)
**DESIGN**
- [ ] Final screenshot set + microcopy sweep
**OPS**
- [ ] Runbook updates for store + web
**MKT**
- [ ] Launch sequence: v2 announcement + newsletter cadence aligned
```
