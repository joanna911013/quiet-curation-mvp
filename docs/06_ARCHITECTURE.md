# 06 Architecture
Last updated: 2026-01-24

Architecture overview for the MVP, aligned to Week 1-2 decisions and the current delivery pipeline.

## System Overview
- Client: Next.js PWA (mobile-first, add-to-home-screen on iOS).
- Backend: Supabase (Postgres + Auth + RLS).
- Admin ops: minimal /admin screens for pairings approval.
- Cron: Vercel /api/cron/quiet-invite (dry-run in Week 2).
- Pipeline: offline curation (LLM-assisted, human approved).

## Data Flow (Daily Pairing)
1) Curation pipeline writes approved pairings to `pairings`.
2) App fetches Today snapshot by (pairing_date, locale).
3) Only status='approved' pairings are visible to users.
4) If no pairing exists for today, use Safe Pairing Set; if none exists, omit pairing section.
5) Verse text is joined from `verses` and rendered in UI.

## Data Flow (Emotion Logging)
- User selects primary emotion + optional memo.
- One entry per user per day (unique user_id + event_date).
- Skip writes nothing.

## Email Flow (Quiet Invite)
- Cron runs daily with CRON_SECRET.
- Deduped by (user_id, delivery_date).
- Uses approved-only pairing; if missing, falls back to FALLBACK_CURATION_ID.
- Dry-run until Week 3 (no external sends).

## Security Model (RLS)
- saved_items: user-scoped CRUD (user_id = auth.uid()).
- emotion_events: user-scoped CRUD (user_id = auth.uid()).
- pairings: read-only for authenticated users, approved-only filter.
- verses / verse_embeddings: authenticated read only.
- invite_deliveries: service-only (no user policies).

## Environments
- Dev and prod Supabase projects are separated.
- Env var scopes documented in `ops/env-vars.md`.

## Links
- Technical reference (TRD): `engineering/trd.md`
- Data schema: `07_ERD_DATA_SCHEMA.md`
- DevOps playbook: `02_DEVOPS_PLAYBOOK.md`
- MLOps playbook: `03_MLOPS_PLAYBOOK.md`
- Decisions log: `weekly/W02_DECISIONS_LOG.md`
