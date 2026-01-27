# Week 2 Dev Notes

## Day 2
Smoke test: PASS
- logged-in user with 0 saves sees empty state + "Go to Today" CTA.
- user with 1+ saves sees list sorted by newest saved_at first.
- clicking a saved item opens the Detail page for that pairing.
- login -> open /profile -> email visible.
- click logout -> redirected to /login.
- visit /profile after logout -> redirected to /login.
- visit /saved after logout -> redirected to /login.

Saved RLS test in quiet-curation-web/app/(app)/saved-rls-check : PASS

A) Normal save/list
B) Cross-user visibility
C) Spoof insert (new row violates row-level security)
D) Spoof delete  (deleted: 0, no cross-user delete)

pairings check test in quiet-curation-web/app/(app)/pairings-check : PASS
- userId returned and userErr = null (session OK)
- rows returned only with status = "approved"
- nonApprovedSeen = [] (no drafts leaked to non-admin)
- Verified daily snapshot visibility across multiple dates (2026-01-19 ~ 2026-01-26), locale="en"

Verse ingest summary (sample run; full 300-row run postponed):
- Input file: quiet-curation-web/scripts/data/verses_en_niv_day2.json
- Input rows: 3 (sample)
- Result: ingest test passed

Verse search check (Option C text search):
- Ran `quiet-curation-web/scripts/sql/verse_search_text.sql` and visited `/search-check`.
- Query `shepherd` -> Psalms 23:1 (score 0.0607927106320858)
- Query `rest` -> no results
- Query `anxiety` -> Philippians 4:6 (score 0.100000001490116)

## Day 3
Delivery dedupe (send-quiet-invites):
- Delivery date (Asia/Seoul): 2026-01-21
- Recipients: 1
- Curation ID: f59c8e2e-9e4d-4ff9-bb35-cb8ca5537f8a
- 1st run: Inserted 1, Skipped 0 (link printed)
- 2nd run: Inserted 0, Skipped 1 (already sent)

Deep link login redirect:
- Invite link format `/login?redirect=/c/<id>` verified (lands on `/c/[id]` after login).

Vercel cron /api/cron/quiet-invite manual test:
- Authorization header accepted (200 OK).
- Summary: delivery_date 2026-01-21, recipients 1, inserted 1, sent 1, failed 0, retried 0.

Task D status update (email sending + dry-run):
- Cron pipeline: /api/cron/quiet-invite runs, dedupe (user_id, delivery_date) verified, retry counts increment on failure.
- Template: renderQuietInviteEmail renders, deep link format /login?redirect=/c/{curationId} verified, pairing section optional.
- DB lifecycle: invite_deliveries transitions pending -> sent (dry-run) and pending -> failed -> retry when provider misconfigured; last_attempt_at/retry_count/error_message populated.
- Profiles: profiles.email used as recipient source (assumed backfilled from auth.users.email).
- Safety: EMAIL_PROVIDER defaults to dryrun, EMAIL_DRY_RUN supported; EMAIL_FROM set to "Quiet Curation <no-reply@quiet-curation.local>" for format validation.
- Decision: real provider sending deferred to Week 3; Task D complete for Week 2.

Task E (approval gate):
- Cron now fetches today's pairing with status='approved' (date+locale); deterministic selection enforced.
- If no approved pairing exists, cron falls back to FALLBACK_CURATION_ID (no new fallback pool).
- Manual approval via SQL snippet added (scripts/sql/approve_pairing.sql).

## Day 4
Admin panel (pairings) - minimal ops UI:
- List view at `/admin/pairings` with filters (date, locale, status) and sort by pairing_date desc.
- Tables used: `pairings` (list/edit/approve), `verses` (approval validation), `profiles` (admin role check).
- Validation rules for approval:
  - verse_id resolves to a verse
  - verse reference renders (canonical_ref or book/chapter/verse) and translation present
  - literature_source present
  - literature_author OR literature_title present
  - literature_text word count <= 70
  - rationale required
- Approval gate: status set to `approved` only after validation passes; save draft does not run validation.
- Uniqueness policy (Option A): block approval if another approved pairing exists for same (pairing_date, locale).
- Set Today: sets `pairing_date` to today (Asia/Seoul) for approved pairings; blocks if another approved pairing already exists for today+locale.
- Admin role SQL:
  - `update public.profiles set role='admin' where id='<USER_ID>';`
- Status: complete (list, edit/new, approve, set-today verified).
- Today + Detail render real pairing data:
  - Today fetch uses approved-only pairing for today (Asia/Seoul) + locale, ordered by created_at desc/id desc.
  - Today shows verse reference + 2-line verse preview + literature excerpt + citation line; fallback uses Safe Pairing Set (no blank day).
  - Detail shows full verse text + rationale section + sources; shows missing-verse message if translation is absent.

Safe fallback (Day 3 Task E):
- Fallback selection: if no approved pairing for today+locale, select from safe set where status='approved' and is_safe_set=true, ordered by created_at desc then id desc. UI receives isFallback flag but shows the same block.
- Cron delivery uses safe set before failing (no blank day email).
- Admin dashboard shows banner "Today pairing missing" when no approved pairing exists for today+locale; link to /admin/pairings filtered to today+locale.

SQL snippet (pairings safe set flag):
```sql
alter table public.pairings
  add column if not exists is_safe_set boolean not null default false;
```

## Day 5
### Emotion Logging (Task A)
- Skip policy: Skip writes nothing (no `emotion_events` row).
- Memo cap: 160 characters (client + server; DB check constraint added).
- Idempotency key: unique `(user_id, event_date)` on `emotion_events` with upsert.
- Linkage rule: use `pairing_id` when Today pairing resolves; also store `curation_id` if present; allow either to be null without blocking logging.
- Edit policy: read-only once logged for the day (no same-day edits in v1).

### Security/Config Review (Task D)
- Env vars documented in `docs/ops/env-vars.md` with public vs server-only classification.
- Cron auth verified: bearer token checked before any side effects; added auth-fail structured log.
- No server-only secrets referenced in client components; service role key only used server-side.
- RLS scripts added for `profiles`, `saved_items`, and `invite_deliveries` (service-only); `emotion_events` RLS already covered.
