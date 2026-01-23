# Week 2 Day 5 — Dev Notes

## Emotion Logging (Task A)
- Skip policy: Skip writes nothing (no `emotion_events` row).
- Memo cap: 160 characters (client + server; DB check constraint added).
- Idempotency key: unique `(user_id, event_date)` on `emotion_events` with upsert.
- Linkage rule: use `pairing_id` when Today pairing resolves; also store `curation_id` if present; allow either to be null without blocking logging.
- Edit policy: read-only once logged for the day (no same-day edits in v1).

## Security/Config Review (Task D)
- Env vars documented in `docs/ops/env-vars.md` with public vs server-only classification.
- Cron auth verified: bearer token checked before any side effects; added auth-fail structured log.
- No server-only secrets referenced in client components; service role key only used server-side.
- RLS scripts added for `profiles`, `saved_items`, and `invite_deliveries` (service-only); `emotion_events` RLS already covered.
