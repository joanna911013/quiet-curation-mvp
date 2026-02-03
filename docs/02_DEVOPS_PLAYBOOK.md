# 02 DevOps Playbook
Last updated: 2026-01-24

Operational reference for Week 2. This playbook keeps daily pairing approvals, fallback safety, and delivery readiness consistent and repeatable.

## Scope (Week 2)
- Approved-only daily pairing snapshots.
- No blank day via Safe Pairing Set fallback.
- Quiet invite cron in dry-run mode (no external email sends).
- Admin approvals via /admin (pairings list/edit/approve).

## System Invariants
- Daily snapshot key: (pairing_date, locale).
- Users see only approved pairings (no draft exposure).
- Verse text is DB-sourced only.
- If no approved pairing exists for today, use Safe Pairing Set; if none exists, omit pairing section entirely.
- Pairing_date and delivery_date are anchored to Asia/Seoul (KST).

## Daily Operator Loop (<= 15 minutes)
1) Approve tomorrow's pairing (date + locale) and verify join integrity.
2) Verify Today UI renders approved-only pairing (or safe fallback) with correct attribution.
3) Run fallback drill (temporarily unapprove today's pairing; confirm safe set renders).
4) Run quiet invite cron (dry-run) and verify dedupe + deep link.

Detailed checklist and SQL snippets live in `ops/daily_ops_routine_v1.md`.

## Preflight Checklist
- Admin access to /admin is working.
- Safe Pairing Set is populated in DB (verify via `ops/daily_ops_routine_v1.md` SQL).
- Env vars validated (`ops/env-vars.md`).
- Cron auth secret available for dry-run.
- Supabase SQL Editor access available for spot checks.

## Critical Checks (Pass/Fail)
- Only one approved pairing for (pairing_date, locale).
- verse_id join succeeds and translation label is present.
- Literature excerpt <= 70 words and attribution present.
- Today renders full verse text (no truncation) and calm layout.
- No placeholder copy if pairing is missing.
- Cron dry-run returns inserted/sent counts and does not double-send.

## Failure Handling
- Missing pairing: approve a pairing for today or select from Safe Pairing Set, then re-check Today.
- Verse join failure: do not approve; fix verse_id or translation first.
- Email preview failure: verify CRON_SECRET, SITE_URL, and deep link flow (/login?redirect=/c/[id]).

## Links
- Daily ops routine (step-by-step): `ops/daily_ops_routine_v1.md`
- Env vars + scopes: `ops/env-vars.md`
- Security review (Week 2 Day 5): `ops/security_review_w02_d5.md`
- Execution plan (Week 2): `weekly/W02_EXECUTION_PLAN.md`
- Decisions log: `weekly/W02_DECISIONS_LOG.md`
