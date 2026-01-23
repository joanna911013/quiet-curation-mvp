# Env Vars (Week 2)

This document lists environment variables used by **quiet-curation-web** and related scripts, with scope and usage.

## Legend
- **Public**: Safe to expose to browser (`NEXT_PUBLIC_*` only).
- **Server-only**: Must never be shipped to client bundles or logged.

---

## App Runtime (Vercel)

| Name | Scope | Used In | Notes |
| --- | --- | --- | --- |
| `NEXT_PUBLIC_SUPABASE_URL` | Public | `lib/supabaseClient.ts`, `lib/supabaseServer.ts`, `app/auth/callback/route.ts` | Supabase URL for client + server SSR. |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Public | `lib/supabaseClient.ts`, `lib/supabaseServer.ts`, `app/auth/callback/route.ts` | Supabase anon key (client-safe). |
| `SUPABASE_URL` | Server-only | `/api/cron/quiet-invite`, scripts | Optional server-only override for Supabase URL. |
| `SUPABASE_SERVICE_ROLE_KEY` | Server-only | `/api/cron/quiet-invite`, admin service fetch, scripts | **Never** expose to client. |
| `CRON_SECRET` | Server-only | `/api/cron/quiet-invite` | Authorization bearer token. |
| `SITE_URL` | Server-only | `/api/cron/quiet-invite` | Used to build deep links in emails. |
| `FALLBACK_CURATION_ID` | Server-only | `/api/cron/quiet-invite` | Used if no approved pairing. |
| `EMAIL_PROVIDER` | Server-only | `lib/emails/sendEmail.ts` | `dryrun`, `resend`, or `sendgrid`. |
| `EMAIL_DRY_RUN` | Server-only | `lib/emails/sendEmail.ts` | Forces dry-run behavior. |
| `EMAIL_FROM` | Server-only | `lib/emails/sendEmail.ts` | Default from address. |
| `RESEND_API_KEY` | Server-only | `lib/emails/sendEmail.ts` | Required if `EMAIL_PROVIDER=resend`. |
| `RESEND_FROM` | Server-only | `lib/emails/sendEmail.ts` | Overrides `EMAIL_FROM` for Resend. |
| `SENDGRID_API_KEY` | Server-only | `lib/emails/sendEmail.ts` | Required if `EMAIL_PROVIDER=sendgrid`. |
| `SENDGRID_FROM` | Server-only | `lib/emails/sendEmail.ts` | Overrides `EMAIL_FROM` for SendGrid. |
| `CRON_DEBUG` | Server-only | `/api/cron/quiet-invite` | Includes debug fields in response. |
| `EMOTION_LOGGING_ENABLED` | Server-only | `/emotion` page + actions | Feature flag (server-side). |
| `NEXT_PUBLIC_EMOTION_LOGGING_ENABLED` | Public | `/emotion` page + actions | Optional public flag for previews. |
| `VERCEL_ENV` / `NODE_ENV` | Server-only | `lib/observability.ts` | Used for log metadata only. |

---

## Local / Script-only (CLI)

| Name | Scope | Used In | Notes |
| --- | --- | --- | --- |
| `SUPABASE_URL` | Server-only | ingest/search/embed scripts | Required for local scripts. |
| `SUPABASE_SERVICE_ROLE_KEY` | Server-only | ingest/search/embed scripts | Required for local scripts. |
| `OPENAI_API_KEY` | Server-only | `scripts/embed-verses.mjs` | Required for embeddings. |

---

## Notes / Guardrails
- **Never** prefix server-only secrets with `NEXT_PUBLIC_`.
- Client components only access `NEXT_PUBLIC_*` values.
- Cron and admin service paths use service role **server-side only**.

---

## RLS Policy Summary (Week 2)
- `profiles`: select/update/insert own row only. (SQL: `quiet-curation-web/scripts/sql/profiles_rls.sql`)
- `saved_items`: CRUD restricted to `user_id = auth.uid()`. (SQL: `quiet-curation-web/scripts/sql/saved_items_rls.sql`)
- `emotion_events`: CRUD restricted to `user_id = auth.uid()`. (SQL: `quiet-curation-web/scripts/sql/emotion_events.sql`)
- `invite_deliveries`: service-only writes; no user policies. (SQL: `quiet-curation-web/scripts/sql/invite_deliveries_rls.sql`)
