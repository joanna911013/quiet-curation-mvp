# W05 Day1 Release QA Gate Log
Date: 2026-02-23
Owner: Yoanna + Codex
Target repo: `quiet-curation-web`
Environment: local `next start` (`http://localhost:3210`) with `.env.local`

## Scope
Checklist source: `docs/09_QA_RELEASE_CHECKLIST.md`
Execution mode: command-based smoke + route/API verification.

## Command Evidence
1. `npm run lint` -> PASS (0 errors, 0 warnings)
2. `npm run build` -> PASS
3. Route/API smoke via Node `fetch`:
   - `/landing` -> 200
   - `/subscribe` -> 200
   - `/today` -> 307 (redirect to `/` when unauthenticated)
   - `/saved` -> 307 (redirect to `/` when unauthenticated)
   - `/api/cron/quiet-invite` (no auth) -> 401
   - `/api/cron/quiet-invite` (Bearer `CRON_SECRET`) -> 200
     - summary: `inserted: 0`, `skipped: 2`, `sent: 0`, `failed: 0`, `fallback_used: true`

## Checklist Result (Pass/Fail/Blocked)

### Current Release Gates (Week 2)
- [ ] Approved-only pairings visible to users (no drafts in Today/Detail). -> BLOCKED (needs authenticated user scenario)
- [ ] Today fetch returns verse_text + canonical_ref + translation label. -> BLOCKED (needs authenticated user + detail verification)
- [x] No blank day: Safe Pairing Set fallback verified. -> PASS (cron run `fallback_used: true`)
- [x] Quiet invite cron dry-run passes with dedupe (1 send per user per day). -> PASS (dedupe observed: `inserted 0 / skipped 2`)
- [ ] Save/Unsave works after Today join changes. -> BLOCKED (needs authenticated UI flow)
- [ ] Admin can approve and set Today in <= 3 minutes. -> BLOCKED (needs admin session)

### Core User Flow QA
- [ ] Login works (magic link / code) and redirects to Home. -> PARTIAL (magic-link request works on `/subscribe`; link-open redirect flow not executed)
- [ ] Today -> Detail -> Save -> Saved -> Detail works without errors. -> BLOCKED
- [ ] Profile shows email; sign out redirects to /login. -> BLOCKED
- [ ] Emotion logging: primary emotion required, memo optional (<= 160 chars). -> BLOCKED
- [ ] Skip emotion logging writes nothing and does not error. -> BLOCKED

### Content & Pairing QA
- [ ] Verse text is DB-sourced; no generated text. -> BLOCKED
- [ ] Literature excerpt <= 70 words; attribution present. -> N/A (spec changed: excerpt length cap removed)
- [ ] Rationale present (no length cap). -> BLOCKED
- [ ] Reference line format: "{Book} {Chapter}:{Verse} ({Translation})". -> BLOCKED
- [ ] If translation missing, verse block does not render. -> BLOCKED

### RLS & Security QA
- [ ] saved_items: User A cannot read/modify User B rows. -> BLOCKED (requires two-user test)
- [ ] emotion_events: User A cannot read/modify User B rows. -> BLOCKED (requires two-user test)
- [ ] pairings: authenticated read only; approved-only filter. -> BLOCKED
- [ ] verses / verse_embeddings: authenticated read only. -> BLOCKED
- [ ] invite_deliveries: service-only; no user policies. -> PARTIAL (cron endpoint protected; DB policy spoof test not executed)

### Cron & Email QA (Week 2 dry-run)
- [x] /api/cron/quiet-invite requires CRON_SECRET. -> PASS (401 without token)
- [x] Dedupe verified (user_id + delivery_date). -> PASS (`inserted 0`, `skipped 2`)
- [x] Deep link works: /login?redirect=/c/[id]. -> PASS (`/login?redirect=/c/test-id` returned login page)
- [x] If no approved pairing, fallback uses FALLBACK_CURATION_ID. -> PARTIAL/PASS (fallback path active via safe pairing set; env fallback path not explicitly forced)

### Admin Ops QA
- [ ] /admin/pairings lists, filters, and approves correctly. -> BLOCKED
- [ ] Approval validation blocks missing verse_id or translation. -> BLOCKED
- [ ] Uniqueness: only one approved pairing per (pairing_date, locale). -> BLOCKED
- [ ] "Today pairing missing" banner appears when appropriate. -> BLOCKED

### Mobile Polish QA
- [ ] Today pairing preview clamps to 2 lines; stays compact (80-96px). -> BLOCKED (manual mobile test required)
- [ ] Detail view shows full verse text; rationale renders fully (no clamp). -> BLOCKED
- [ ] Long refs or titles do not overflow containers. -> BLOCKED
- [ ] iOS safe-area padding prevents CTA overlap. -> BLOCKED

### Suggested Manual Tests
- [ ] /saved-rls-check passes spoof tests. -> BLOCKED (requires authenticated session)
- [ ] /pairings-check returns only approved rows. -> BLOCKED
- [ ] /search-check returns expected verse results. -> BLOCKED

## New Findings (Blocking)
1. Localized marketing URLs fail in runtime smoke:
   - `/ko/landing` -> 404
   - `/ko/subscribe` -> 404
   - `/en/landing` -> 404
2. Build route list still shows `/[locale]/landing` and `/[locale]/subscribe`, so this is a runtime routing mismatch to fix before release.

## Action Items
1. Fix localized route runtime mismatch (`/[locale]/landing`, `/[locale]/subscribe`).
2. Execute authenticated manual QA batch (login/today/detail/save/emotion/admin/RLS) with two test users.
3. Re-run this gate log and upgrade BLOCKED items to PASS/FAIL.
