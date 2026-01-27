# 00 Master Brain
Last updated: 2026-01-26

Quiet Curation MVP is a literature and scripture pairing experience focused on calm, reliable daily reading. This doc is the top-level entry point for current status, source-of-truth links, and the canonical doc set.

## Current Stage
- Week 3 : Ship Week2 Day5 goals + start real delivery

DEV : 
- Turn on real email provider (Resend or SendGrid) + keep dedupe/retry + invite_deliveries lifecycle logs.
- Ship Emotion logging (required primary emotion, optional memo cap; “logged today” read-back; link to pairing/curation).
-E2E QA suite (new user, deep link, admin ops, permissions/RLS, fallback behavior, failure states).
-Minimal observability logs (delivery, today fetch, join fail, emotion save fail) + “cron summary” output.

DESIGN:
- Final mobile polish: overflow, spacing for long verse/excerpts, iOS safe-area quirks.
- Emotion UI polish: lightweight confirmation (“Logged today”) state, calm tone.

OPS:
-Expand Safe Pairing Set toward 15–20, run daily review (sample 3, guardrails).

MKT:
-Framer page polish (email opt-in web MVP): clearly explain “web app + daily email invite at 09:00 KST,” show 1–2 screen previews, set expectations, opt-in CTA.

## Target State and Stack (App Store / Play)
- Web MVP remains Next.js (App Router) on Vercel.
- Backend/data: Supabase Postgres (RLS + pgvector), server routes for cron/admin.
- Scheduling: Vercel Cron -> `/api/cron/quiet-invite` (`CRON_SECRET`).
- Email: Week 2 dry-run; Week 3 real provider (Resend or SendGrid).
- Growth page: Framer (email opt-in -> "get the web experience via daily email").
- App Store/Play path (minimal change): package the web app as a wrapper (typically Capacitor) and submit.
- Expect two clocks: engineering (wrapper/auth/deeplink/privacy/QA) ~1-2 weeks; store review timing variable, plan buffer.
- Pragmatic plan: v1 web-first, then v2 stability + light personalization, then store packaging.

## Source Of Truth
- Execution plan: `weekly/W03_EXECUTION_PLAN.md`
- Decisions log: `weekly/W03_DECISIONS_LOG.md`
- Weekly history index: `weekly/README.md`

## Links
- PRD: `01_PRD_MVP.md`
- DevOps playbook: `02_DEVOPS_PLAYBOOK.md`
- MLOps playbook: `03_MLOPS_PLAYBOOK.md`
- Design system: `04_DESIGN_SYSTEM.md`
- Quality guardrails: `05_QUALITY_GUARDRAILS.md`
- Architecture: `06_ARCHITECTURE.md`
- Data schema: `07_ERD_DATA_SCHEMA.md`
- Prompts library: `08_PROMPTS_LIBRARY.md`
- QA release checklist: `09_QA_RELEASE_CHECKLIST.md`
- Latest weekly brief: `weekly/W01_BRIEF.md`
- Latest dev notes: `weekly/W02_DEV_NOTES.md`
