# W05 Day1 Release QA Gate Log
Date: 2026-02-23
Last updated: 2026-02-26
Owner: Yoanna + Codex
Target repo: `quiet-curation-web`
Environment: local `next start` (`http://localhost:3210`) with `.env.local`

## Scope
Checklist source: `docs/09_QA_RELEASE_CHECKLIST.md`
Execution mode: production build + local smoke + Supabase API policy checks (temporary QA users, auto-cleanup).

## Command Evidence
1. `npm run lint` -> PASS (0 errors, 0 warnings)
2. `npm run build` -> PASS
3. Local route smoke (unauth):
   - `/landing` 200
   - `/subscribe` 200
   - `/ko/landing` 200
   - `/ko/subscribe` 200
   - `/en/landing` 307 -> `/landing`
   - `/en/subscribe` 307 -> `/subscribe`
   - `/today` 307 -> `/`
   - `/saved` 307 -> `/`
4. Cron endpoint checks:
   - `/api/cron/quiet-invite` (no token) -> 401
   - `/api/cron/quiet-invite` (Bearer `CRON_SECRET`) -> 200
   - two authenticated runs both showed dedupe state (`inserted: 0`, `skipped: 2`)
5. Authenticated app smoke (temporary QA user + Supabase SSR cookie):
   - `/whoami`, `/today`, `/c/[id]`, `/saved`, `/profile`, `/emotion` -> all 200
   - `/profile` response contained authenticated email
6. Save flow check (temporary QA user):
   - `saved_items` insert -> 201
   - `/saved` rendered inserted pairing id
   - `saved_items` delete -> 204
7. RLS checks (temporary QA users A/B):
   - `saved_items` spoof insert (`user B` writing `user A`) -> 403 (`42501`)
   - `emotion_events` spoof insert (`user B` writing `user A`) -> 403 (`42501`)
   - `invite_deliveries` user/anon read -> empty, service role read -> row exists
8. Check routes with authenticated user:
   - `/pairings-check` -> approved-only rows visible, no error
   - `/verse-check` -> verse row visible, no error
   - `/search-check` -> FAIL in run 1 (`column v.text does not exist`)
9. Admin gating checks:
   - non-admin authenticated user: `/admin`, `/admin/pairings` show `Not authorized`
   - temporary admin user: `/admin` rendered and showed `Today pairing missing` warning; `/admin/pairings` rendered dashboard
10. Targeted re-test (2026-02-24):
   - `/search-check` -> PASS after `searchVerses` fallback fix (no `column v.text does not exist` error)
11. Full rerun (2026-02-25):
   - lint/build re-run -> PASS
   - unauth and auth smoke routes re-run -> PASS
   - `/search-check` -> 200 and no legacy SQL error
   - save/unsave + RLS spoof + cron dedupe + admin/non-admin gating re-run -> PASS
12. Admin runtime UI QA (2026-02-25, Playwright):
   - approve + set-today on `/admin/pairings/[id]` completed in `2235ms` (`0.04 min`) -> within 3 minutes
   - DB verification after action: `status=approved`, `pairing_date=today`
   - approval validation UI surfaced expected error for invalid draft (`Literature source is required.`)
13. Logout runtime QA (2026-02-25, Playwright):
   - `/profile` -> click `Logout` -> redirected to `/login`
14. Magic-link callback E2E re-run (2026-02-25):
   - generated `hashed_token` via Supabase Admin `generate_link` for confirmed user
   - opened `/auth/callback?token_hash=...&type=magiclink&redirect=/c/24a4a110-66d5-4785-afba-30dbc0dd7fa3`
   - redirect landed on `/c/24a4a110-66d5-4785-afba-30dbc0dd7fa3`
   - authenticated `/profile` shows user email + logout control
   - public `/auth/v1/otp` probe with valid email returned `200` (rapid repeat can return `429` rate-limit)
15. Mobile viewport QA run (2026-02-25, iPhone 13 emulation):
   - Today card height measured `565px` (fails compact target `80-96px`)
   - Detail verse/rationale render fully (no clamp, no clipping)
   - No horizontal overflow on Today/Detail
   - safe-area evidence: Today CTA visible with `44px` bottom gap, Detail `.readingBody` padding-bottom `80px`
   - result artifact: `/tmp/magic_mobile_qa_result.json`
16. Emotion memo DB guard readiness (2026-02-25):
   - `emotion_events` check: `rows=4`, `maxMemoShortLength=84`, `over160=0`
   - SQL guard added: `quiet-curation-web/scripts/sql/emotion_events_memo_length_guard.sql`
17. Mobile viewport QA re-run after Today card compact fix (2026-02-25, iPhone 13 emulation):
   - Today card height `92px` (target `80-96px`) -> PASS
   - Detail verse/rationale render fully (no clamp, no clipping) -> PASS
   - No horizontal overflow on Today/Detail -> PASS
   - safe-area evidence remains PASS (Today CTA visible, Detail bottom padding retained)
   - result artifact: `/tmp/magic_mobile_qa_result.json`
18. Emotion memo DB guard apply + verification (2026-02-25):
   - SQL applied in Supabase: `scripts/sql/emotion_events_memo_length_guard.sql`
   - probe insert with `memo_short` length `170` now fails with `23514`
   - constraint confirmed active: `emotion_events_memo_short_max_len`
19. Admin ops partial checks close (2026-02-26, Playwright + API probe):
   - `/admin/pairings` list/filter/approve re-run on QA rows:
     - `status=all`: draft row approved successfully
     - `status=approved`: approved row visible
     - `status=draft`: approved row excluded
   - approval validation for missing translation:
     - approve on draft row bound to verse with empty translation produced `Verse translation is missing.`
   - missing `verse_id` guard confirmed at DB layer:
     - `pairings.verse_id = null` update probe rejected with `23502` (`not-null` constraint)
   - result artifact: `/tmp/admin_ops_qa_result.json`

## Checklist Result (Pass/Fail/Blocked)

### Current Release Gates (Week 2)
- [x] Approved-only pairings visible to users (no drafts in Today/Detail). -> PASS (pairings-check + policy query returned only `approved`)
- [x] Today fetch returns verse_text + canonical_ref + translation label. -> PASS (safe-set fallback pairings have all three fields)
- [x] No blank day: Safe Pairing Set fallback verified. -> PASS (cron runs succeeded while no approved `today` row exists)
- [x] Quiet invite cron dry-run passes with dedupe (1 send per user per day). -> PASS (`inserted 0 / skipped 2` on repeated run)
- [x] Save/Unsave works after Today join changes. -> PASS (insert 201, `/saved` render, delete 204)
- [x] Admin can approve and set Today in <= 3 minutes. -> PASS (`2235ms`, verified row updated to today + approved)

### Core User Flow QA
- [x] Login works (magic link / code) and redirects to Home. -> PASS (OTP request accepted for valid email; callback token_hash flow completed and session authenticated)
- [x] Today -> Detail -> Save -> Saved -> Detail works without errors. -> PASS (authenticated route and save flow smoke)
- [x] Profile shows email; sign out redirects to /login. -> PASS (email shown on profile; runtime logout redirect verified to `/login`)
- [x] Emotion logging: primary emotion required, memo optional (<= 160 chars). -> PASS (UI/server enforce; DB now rejects >160 with check constraint `emotion_events_memo_short_max_len`)
- [x] Skip emotion logging writes nothing and does not error. -> PASS (skip button is client redirect only; no write path)

### Content & Pairing QA
- [x] Verse text is DB-sourced; no generated text. -> PASS (`resolveVerseText` returns DB value only)
- [ ] Literature excerpt <= 70 words; attribution present. -> N/A (length cap intentionally removed)
- [x] Rationale present (no length cap). -> PASS (approved rows include rationale)
- [x] Reference line format: "{Book} {Chapter}:{Verse} ({Translation})". -> PASS (Today formatter + verse data checks)
- [x] If translation missing, verse block does not render. -> PASS (guard requires `verseReference` and `verseText`)

### RLS & Security QA
- [x] saved_items: User A cannot read/modify User B rows. -> PASS (spoof insert blocked, cross-read empty)
- [x] emotion_events: User A cannot read/modify User B rows. -> PASS (spoof insert blocked, cross-read empty)
- [x] pairings: authenticated read only; approved-only filter. -> PASS (anon returns empty; auth sees approved rows)
- [ ] verses / verse_embeddings: authenticated read only. -> PARTIAL (verses confirmed; `verse_embeddings` table currently empty)
- [x] invite_deliveries: service-only; no user policies. -> PASS (service sees data; user/anon do not)

### Cron & Email QA (Week 2 dry-run)
- [x] /api/cron/quiet-invite requires CRON_SECRET. -> PASS
- [x] Dedupe verified (user_id + delivery_date). -> PASS
- [x] Deep link works: /login?redirect=/c/[id]. -> PASS (route reachable)
- [x] If no approved pairing, fallback uses FALLBACK_CURATION_ID. -> PASS (inference: no approved today row, cron still processes recipients via fallback path)

### Admin Ops QA
- [x] /admin/pairings lists, filters, and approves correctly. -> PASS (runtime re-run verified list/filter behavior + approve transition)
- [x] Approval validation blocks missing verse_id or translation. -> PASS (translation-missing message confirmed in UI; missing `verse_id` rejected by DB not-null guard `23502`)
- [x] Uniqueness: only one approved pairing per (pairing_date, locale). -> PASS (DB unique constraint `pairings_date_locale_unique` confirmed)
- [x] "Today pairing missing" banner appears when appropriate. -> PASS (rendered for admin with no approved EN pairing for today)

### Mobile Polish QA
- [x] Today pairing preview clamps to 2 lines; stays compact (80-96px). -> PASS (`cardHeight=92px` after compact preview update)
- [x] Detail view shows full verse text; rationale renders fully (no clamp). -> PASS
- [x] Long refs or titles do not overflow containers. -> PASS (Today/Detail horizontal overflow checks passed)
- [x] iOS safe-area padding prevents CTA overlap. -> PASS (Today CTA visible with bottom gap; detail body keeps bottom padding)

### Suggested Manual Tests
- [x] /saved-rls-check passes spoof tests. -> PASS (equivalent API spoof tests passed)
- [x] /pairings-check returns only approved rows. -> PASS
- [x] /search-check returns expected verse results. -> PASS (targeted re-test on 2026-02-24 + full rerun on 2026-02-25)

## New Findings (Blocking / Follow-up)
1. Fixed: localized marketing route mismatch is resolved.
   - `/ko/landing`, `/ko/subscribe` now return 200.
2. Fixed: `/search-check` SQL/schema mismatch resolved via app-side fallback.
   - Old error: `column v.text does not exist`
3. Magic-link callback path is now verified end-to-end for a confirmed account.
   - public OTP request succeeds with a valid email (`200`)
   - invalid/test domains can still return provider validation errors
4. Emotion memo limit is now enforced at DB-level.
   - >160 probe insert returns `23514` against `emotion_events_memo_short_max_len`
5. `pairings.verse_id` is DB `NOT NULL`, so missing-verse approval is pre-blocked at persistence layer.
6. Admin validation layering decision (2026-03-02):
   - keep explicit app-layer `Verse is required.` check for faster editor feedback,
     and keep DB `NOT NULL` as defense-in-depth.
7. `verse_embeddings` read-policy check remains partial in this log:
   - table was empty during QA runs, so row-level read behavior could not be fully exercised.

## Action Items
1. Non-blocking follow-up: rerun `verse_embeddings` auth read check when at least one QA row exists.
