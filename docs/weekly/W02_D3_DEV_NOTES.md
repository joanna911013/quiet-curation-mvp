# Week 2 Day 3 Dev Notes

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
