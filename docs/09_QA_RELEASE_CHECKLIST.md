# 09 QA Release Checklist
Last updated: 2026-01-24

Release checklist and QA gates for Week 2 builds. Use this as the single pass/fail list before tagging a release candidate.

## Current Release Gates (Week 2)
- [ ] Approved-only pairings visible to users (no drafts in Today/Detail).
- [ ] Today fetch returns verse_text + canonical_ref + translation label.
- [ ] No blank day: Safe Pairing Set fallback verified (and pairing omitted if no fallback exists).
- [ ] Quiet invite cron dry-run passes with dedupe (1 send per user per day).
- [ ] Save/Unsave works after Today join changes.
- [ ] Admin can approve and set Today in <= 3 minutes.

## Core User Flow QA
- [ ] Login works (magic link / code) and redirects to Home.
- [ ] Today -> Detail -> Save -> Saved -> Detail works without errors.
- [ ] Profile shows email; sign out redirects to /login.
- [ ] Emotion logging: primary emotion required, memo optional (<= 160 chars).
- [ ] Skip emotion logging writes nothing and does not error.

## Content & Pairing QA
- [ ] Verse text is DB-sourced; no generated text.
- [ ] Literature excerpt <= 70 words; attribution present.
- [ ] Rationale present (no length cap).
- [ ] Reference line format: "{Book} {Chapter}:{Verse} ({Translation})".
- [ ] If translation missing, verse block does not render.

## RLS & Security QA
- [ ] saved_items: User A cannot read/modify User B rows.
- [ ] emotion_events: User A cannot read/modify User B rows.
- [ ] pairings: authenticated read only; approved-only filter.
- [ ] verses / verse_embeddings: authenticated read only.
- [ ] invite_deliveries: service-only; no user policies.

## Cron & Email QA (Week 2 dry-run)
- [ ] /api/cron/quiet-invite requires CRON_SECRET.
- [ ] Dedupe verified (user_id + delivery_date).
- [ ] Deep link works: /login?redirect=/c/[id].
- [ ] If no approved pairing, fallback uses FALLBACK_CURATION_ID.

## Admin Ops QA
- [ ] /admin/pairings lists, filters, and approves correctly.
- [ ] Approval validation blocks missing verse_id or translation.
- [ ] Uniqueness: only one approved pairing per (pairing_date, locale).
- [ ] "Today pairing missing" banner appears when appropriate.

## Mobile Polish QA
- [ ] Today pairing preview clamps to 2 lines; stays compact (80-96px).
- [ ] Detail view shows full verse text; rationale renders fully (no clamp).
- [ ] Long refs or titles do not overflow containers.
- [ ] iOS safe-area padding prevents CTA overlap.

## Suggested Manual Tests (Existing Check Routes)
- [ ] /saved-rls-check passes spoof tests.
- [ ] /pairings-check returns only approved rows.
- [ ] /search-check returns expected verse results.

## Links
- Execution plan gates: `weekly/W02_EXECUTION_PLAN.md`
- Decisions log: `weekly/W02_DECISIONS_LOG.md`
- Dev notes: `weekly/W02_DEV_NOTES.md`
- Daily ops routine: `ops/daily_ops_routine_v1.md`

## Appendix: Week 1 Friday Gate Review (2026-01-17)
See `weekly/W01_BRIEF.md` for the full Week 1 gate review summary and evidence.
