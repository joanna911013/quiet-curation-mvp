# W05 Day1 Release QA Gate Log
Date: 2026-02-23
Last updated: 2026-02-25
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

## Checklist Result (Pass/Fail/Blocked)

### Current Release Gates (Week 2)
- [x] Approved-only pairings visible to users (no drafts in Today/Detail). -> PASS (pairings-check + policy query returned only `approved`)
- [x] Today fetch returns verse_text + canonical_ref + translation label. -> PASS (safe-set fallback pairings have all three fields)
- [x] No blank day: Safe Pairing Set fallback verified. -> PASS (cron runs succeeded while no approved `today` row exists)
- [x] Quiet invite cron dry-run passes with dedupe (1 send per user per day). -> PASS (`inserted 0 / skipped 2` on repeated run)
- [x] Save/Unsave works after Today join changes. -> PASS (insert 201, `/saved` render, delete 204)
- [x] Admin can approve and set Today in <= 3 minutes. -> PASS (`2235ms`, verified row updated to today + approved)

### Core User Flow QA
- [ ] Login works (magic link / code) and redirects to Home. -> BLOCKED (OTP probe returned `email_address_invalid`; full email-link callback still not executable in current env)
- [x] Today -> Detail -> Save -> Saved -> Detail works without errors. -> PASS (authenticated route and save flow smoke)
- [x] Profile shows email; sign out redirects to /login. -> PASS (email shown on profile; runtime logout redirect verified to `/login`)
- [x] Emotion logging: primary emotion required, memo optional (<= 160 chars). -> PARTIAL/PASS (UI + server action enforce 160 in code; DB accepts >160 if bypassing app)
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
- [ ] /admin/pairings lists, filters, and approves correctly. -> PARTIAL (list/filter render + approve runtime verified; filter behavior not fully exercised)
- [ ] Approval validation blocks missing verse_id or translation. -> PARTIAL (runtime validation path confirmed; specific missing verse_id/translation case not run)
- [x] Uniqueness: only one approved pairing per (pairing_date, locale). -> PASS (DB unique constraint `pairings_date_locale_unique` confirmed)
- [x] "Today pairing missing" banner appears when appropriate. -> PASS (rendered for admin with no approved EN pairing for today)

### Mobile Polish QA
- [ ] Today pairing preview clamps to 2 lines; stays compact (80-96px). -> BLOCKED (manual mobile viewport test pending)
- [ ] Detail view shows full verse text; rationale renders fully (no clamp). -> BLOCKED
- [ ] Long refs or titles do not overflow containers. -> BLOCKED
- [ ] iOS safe-area padding prevents CTA overlap. -> BLOCKED

### Suggested Manual Tests
- [x] /saved-rls-check passes spoof tests. -> PASS (equivalent API spoof tests passed)
- [x] /pairings-check returns only approved rows. -> PASS
- [x] /search-check returns expected verse results. -> PASS (targeted re-test on 2026-02-24 + full rerun on 2026-02-25)

## New Findings (Blocking / Follow-up)
1. Fixed: localized marketing route mismatch is resolved.
   - `/ko/landing`, `/ko/subscribe` now return 200.
2. Fixed: `/search-check` SQL/schema mismatch resolved via app-side fallback.
   - Old error: `column v.text does not exist`
3. Magic-link QA is blocked by auth provider policy in current environment.
   - OTP probe response: `email_address_invalid`
4. Emotion memo limit is app-layer enforced, not DB-layer enforced.
   - Risk: direct DB writes can exceed 160 chars.
   - Decision needed: keep app-only validation vs add DB constraint.

## Action Items
1. Execute mobile viewport QA (clamp/overflow/safe-area).
2. Resolve magic-link QA environment block (`email_address_invalid`) and run real callback test.
3. Decide whether to enforce emotion memo length at DB level.
