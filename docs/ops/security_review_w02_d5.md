# Security/Config Review — Week 2 Day 5

## Summary
- Server-only secrets remain server-side; client bundles only use `NEXT_PUBLIC_*`.
- Cron endpoint is guarded by `CRON_SECRET` before any DB writes.
- RLS policies added/verified for user-scoped tables (`profiles`, `saved_items`, `emotion_events`).
- `invite_deliveries` set to service-only (no user policies).

## Env Var Audit
See `docs/ops/env-vars.md` for the full table and usage locations.

## RLS: Policy Listing (SQL)
Run in Supabase SQL Editor:
```sql
select schemaname, tablename, policyname, roles, cmd, qual, with_check
from pg_policies
where schemaname = 'public'
  and tablename in ('profiles', 'saved_items', 'emotion_events', 'invite_deliveries')
order by tablename, policyname;
```

## RLS: Smoke Test Checklist
- ✅ User A cannot read User B `saved_items`.
- ✅ User A cannot insert `saved_items` for User B.
- ✅ User A cannot read User B `emotion_events`.
- ✅ User A cannot insert `emotion_events` for User B.
- ✅ Anonymous (no session) cannot read user-scoped tables.

Suggested manual checks:
1) Use `/saved-rls-check` with User B to spoof User A IDs.
2) Attempt inserts with `user_id` set to a different user; expect RLS error.
3) Verify `/whoami` shows current user id before running checks.

## SQL Migrations (Idempotent)
- `quiet-curation-web/scripts/sql/profiles_rls.sql`
- `quiet-curation-web/scripts/sql/saved_items_rls.sql`
- `quiet-curation-web/scripts/sql/emotion_events.sql`
- `quiet-curation-web/scripts/sql/invite_deliveries_rls.sql`
