# 05 Quality Guardrails
Last updated: 2026-01-24

Behavioral contracts and release gates that protect content quality, tone, and reliability. These guardrails govern approvals and QA for Week 1-2 builds.

## Core Guardrails
- Approved-only pairing fetch for users (no draft exposure).
- Deterministic daily pairing by (pairing_date, locale).
- No blank day: Safe Pairing Set fallback; if none exists, omit pairing section entirely.
- Verse text must come from DB (no generation).
- No gamification or pressure loops.

## Content Guardrails (Pairings)
- Literature excerpt <= 70 words.
- Rationale_short required; <= 240 chars.
- Attribution required: literature_author or literature_title must be present.
- Tone: quiet, reflective, non-preachy, non-guilt.
- No commentary that explains the verse or moralizes.

## Verse Integrity Guardrails
- canonical_ref format: "{Book} {Chapter}:{Verse}".
- Translation label must be present and displayed as "{canonical_ref} ({translation})".
- If translation is missing, do not render the verse block.

## UX Guardrails
- Pairing block is secondary (never a banner).
- Missing pairing is quiet: no placeholder copy.
- Rationale is optional; if missing, omit the section.
- Emotion logging is optional; skip writes nothing.

## Email Guardrails (Quiet Invite)
- Approved-only content; if missing, omit pairing snippet.
- Pairing snippet max 2 lines; no labels; calm tone.
- Deep link format: /login?redirect=/c/[id].

## Release Gates (Week 2)
- Approved-only visibility confirmed in UI and RLS.
- Safe Pairing Set fallback verified.
- Source formatting gate passes (attribution + verse reference).
- RLS isolation passes for saved_items and emotion_events.
- Cron dry-run dedupe passes (1 send per user per day).

## Links
- Source formatting approval gate: `ops/source_formatting_approval_gate.md`
- Content constraints: `ops/content_constraints.md`
- Emotion taxonomy: `ops/emotion_taxonomy.md`
- Decisions log: `weekly/W02_DECISIONS_LOG.md`
- QA release checklist: `09_QA_RELEASE_CHECKLIST.md`
