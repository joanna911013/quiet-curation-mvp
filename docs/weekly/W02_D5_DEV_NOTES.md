# Week 2 Day 5 — Dev Notes

## Emotion Logging (Task A)
- Skip policy: Skip writes nothing (no `emotion_events` row).
- Memo cap: 160 characters (client + server; DB check constraint added).
- Idempotency key: unique `(user_id, event_date)` on `emotion_events` with upsert.
- Linkage rule: use `pairing_id` when Today pairing resolves; also store `curation_id` if present; allow either to be null without blocking logging.
- Edit policy: read-only once logged for the day (no same-day edits in v1).
