# W03_D5_SECURITY_CONFIG_CHECKLIST
Date: 2026-01-30
Reviewer: Codex
Scope: quiet-curation-web (Next.js + Supabase + Resend)

## 1) Env separation & exposure
- [x] `.env*` is gitignored (`quiet-curation-web/.gitignore`).
- [x] No server secrets found in `NEXT_PUBLIC_*` (scan: only `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `NEXT_PUBLIC_EMOTION_LOGGING_ENABLED`, `NEXT_PUBLIC_SITE_URL`).
- [x] Verify Vercel envs are set in Production + Preview (manual check; confirmed 2026-01-30).
- [x] Verify `CRON_SECRET` is set in Vercel (manual check; confirmed 2026-01-30).
- [x] Verify `SITE_URL` points to prod domain (manual check; confirmed 2026-01-30).

## 2) Supabase keys & clients
- [x] Browser client uses anon key only (`quiet-curation-web/lib/supabaseClient.ts`).
- [x] Server session client uses anon key + cookies (`quiet-curation-web/lib/supabaseServer.ts`).
- [x] Service role key used only in server contexts:
  - cron route (`quiet-curation-web/app/api/cron/quiet-invite/route.ts`)
  - admin fallback fetch (`quiet-curation-web/app/(app)/admin/pairings/[id]/page.tsx`)
  - scripts (`quiet-curation-web/scripts/*.mjs`)
- [x] Confirm service role key is not present in any `NEXT_PUBLIC_*` Vercel envs (manual check; confirmed 2026-01-30).

## 3) RLS & policies (Supabase console)
- [x] RLS policy definitions exist in repo for user-scoped tables:
  - `saved_items` (`quiet-curation-web/scripts/sql/saved_items_rls.sql`)
  - `emotion_events` (`quiet-curation-web/scripts/sql/emotion_events.sql`)
  - `profiles` (`quiet-curation-web/scripts/sql/profiles_rls.sql`)
- [x] Verify RLS is enabled + policies applied in Supabase (manual check; results captured 2026-01-30).
- [x] `profiles.role` cannot be updated by non-admins (policy applied; manual test passed 2026-01-30).

## 4) Auth/session handling
- [x] SSR uses cookie-based auth via `@supabase/ssr`.
- [x] No refresh-token reuse found in repo scan.
- [ ] Verify iOS webview preserves auth cookies (manual QA).

## 5) API routes & cron
- [x] `/api/cron/quiet-invite` requires `Authorization: Bearer <CRON_SECRET>`.
- [x] Cron uses service role with `persistSession: false`.
- [x] Only API route is `cron/quiet-invite`; admin mutations are server actions gated by `requireAdmin()` (`quiet-curation-web/app/(app)/admin/actions.ts`).

## 6) Email provider
- [x] Resend API key accessed server-side only (`quiet-curation-web/lib/emails/sendEmail.ts`).
- [x] FROM address pulled from server env (`RESEND_FROM` / `EMAIL_FROM`).
- [x] DKIM/SPF/DMARC verified in Resend + GoDaddy (manual check; confirmed 2026-01-30).

## 7) Logging & PII
- [x] Email masking in logs (`maskEmail` usage in cron route).
- [x] Error messages truncated (`truncateText` for logs).
- [x] Confirm logs don’t include tokens or auth objects (manual review during runtime; confirmed 2026-01-30).

## Summary
- Code-level checks are clean for secret exposure and server/client separation.
- Supabase linter errors resolved (profile_emails view hardened; verse_import_web RLS enabled).
- Remaining manual item: iOS webview auth cookie persistence QA.

## Env + Redirect Final Values (Prod)
- Supabase Site URL: https://quiet-curation-web.vercel.app
- Supabase Redirect URLs:
  - https://quiet-curation-web.vercel.app
  - https://quiet-curation-web.vercel.app/auth/callback
  - https://quiet-curation-web.vercel.app/auth/verify
- Vercel `SITE_URL`: https://quiet-curation-web.vercel.app
- `NEXT_PUBLIC_SITE_URL`: https://quiet-curation-web.vercel.app (confirmed in Vercel)
