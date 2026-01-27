# 01 PRD MVP
Last updated: 2026-01-24

## Product Summary
Quiet Curation MVP is a minimalist daily pairing experience: one short literature/quote fragment paired with one Bible verse, plus a lightweight emotion check-in. The product is designed to feel quiet, non-preachy, and anti-guilt, with a complete daily flow in under three minutes.

## Problem
Many faith apps are time-heavy, gamified, or preachy, which creates cognitive debt and disengagement for quiet, private users. Users who are busy, tired, or anxious need a short, safe, non-demanding daily rhythm.

## Goals (MVP)
- Deliver a calm daily pairing (approved-only) with no blank day.
- Keep the end-to-end daily journey under 3 minutes.
- Capture a lightweight emotion log without pressure or guilt.
- Establish the foundation for Archive + Themes monetization.

## Non-Negotiables
- Anti-guilt: missing a day is never framed as failure.
- Short journey: open → done ≤ 3 minutes (target 90 seconds).
- No gamification: no streaks, XP, badges, or pressure loops.
- Quiet presence: no preaching, moralizing, or explicit explanation of the pairing.
- Safety: Bible verses are retrieved from DB; the app reads approved-only pairings.

## Target Users
- Primary: Christians who want a quiet daily rhythm outside church/community.
- Secondary: beginners who need a safe, low-friction, non-judgmental entry point.

## MVP Scope (In)
- Today view shows a daily pairing (literature + verse) using a deterministic snapshot by (pairing_date, locale).
- Detail view shows full verse text, rationale, and attribution metadata.
- Emotion logging: primary emotion required; optional memo (<= 160 chars); one entry per user per day; skip allowed.
- Save/unsave pairings and show a personal saved list.
- Locale support: KO/EN with strict i18n separation (no hard-coded UI strings).
- Quiet invite delivery: daily email with approved-only pairing, deduped by (user_id, delivery_date).
- Admin ops: minimal approval gate for pairings (list, edit, approve).
- Archive/paywall: past days locked for free users; payment integration can be stubbed.

## Out of Scope (MVP)
- Community, groups, sermons, or commentary content.
- Real-time generation on the client; no LLM calls from the app.
- Personalized recommendations driven by emotion logs.
- Streaks, XP, badges, or pressure-based notifications.
- Modern copyrighted literature excerpts (use public domain and curated sources).

## Core User Journey
1) Open app → Today pairing.
2) Read both texts in a calm, minimal layout.
3) Choose emotion → optional short memo (or skip).
4) Save → Done → close.
5) Optional: view Saved/Archive (locked for free users).

## Functional Requirements
- Approved-only content for non-admin users; no draft leakage.
- No blank day: fallback to Safe Pairing Set if today's snapshot is missing.
- Deterministic daily pairing by (pairing_date, locale).
- Email login (magic link/code) with protected routes for saved/logging.
- Settings include language and notification opt-in (default off).

## Non-Functional Requirements
- Stability: crash-free sessions ≥ 99% (target).
- Performance: daily flow finishes within 3 minutes.
- Privacy: minimal data collection; user data isolated by RLS.
- Accessibility: legible type, calm spacing, and mobile-first layout.

## Success Metrics (MVP Targets)
- Emotion log completion ≥ 70%.
- Paywall view → subscribe conversion 1%–3% (if paywall enabled).
- Zero incidents of unapproved content exposure.
- D1/D7 retention tracked for trend direction.

## Links
- Master brain: `00_MASTER_BRAIN.md`
- Execution plan: `weekly/W02_EXECUTION_PLAN.md`
- Design scope: `design/scope.md`
- Architecture: `06_ARCHITECTURE.md`
- Data schema: `07_ERD_DATA_SCHEMA.md`
- Quality guardrails: `05_QUALITY_GUARDRAILS.md`
- QA release checklist: `09_QA_RELEASE_CHECKLIST.md`
