# 03 MLOps Playbook
Last updated: 2026-01-24

MLOps is intentionally minimal for the MVP. The pipeline is batch-first, human-approved, and never runs inside the app. The app consumes approved snapshots only.

## Current Status (Week 2)
- Retrieval: Option C keyword/text search for verse discovery; embeddings deferred.
- Locale: EN only (NIV) for Week 2; KO planned after pipeline stability.
- LLM usage: offline candidate generation and scoring only (no client calls).
- Approval: human approval required before any pairing is visible to users.

## Content Inputs
- Verse corpus: NIV subset defined in Week 2 scope (see decisions log).
- Literature sources: verified public-domain or licensed sources only.
- Emotion taxonomy: fixed 1:1 KO/EN keys (MVP v1).

## Pipeline (Batch)
1) Ingest verses (validated text + canonical_ref + translation label).
2) Generate candidate pairings (LLM or manual) using strict JSON format.
3) Critic validation (reject preachy, forced, or guilt-inducing pairings).
4) Human review + approval (length, attribution, tone, verse correctness).
5) Store approved pairing snapshots in `pairings`.
6) Tag Safe Pairing Set for fallback coverage.

## Quality Gates (Hard)
- Literature excerpt <= 70 words.
- Rationale_short present and <= 240 chars.
- Verse text from DB only; reference format is canonical_ref + translation label.
- No preaching, no moralizing, no guilt language.
- Locale and translation are explicit and consistent.

## Outputs / Artifacts
- Approved daily snapshots in `pairings`.
- Safe Pairing Set tracked in DB; verification SQL in `ops/daily_ops_routine_v1.md`.
- Prompt assets and constraints in ops docs.

## Future (Week 3+)
- Add embeddings + semantic search for verse matching.
- Expand locale coverage (KO/EN in parallel).
- Automate more of the approval workflow while preserving human gate.

## Links
- Content constraints: `ops/content_constraints.md`
- Emotion taxonomy: `ops/emotion_taxonomy.md`
- LLM curation prompts: `ops/llm_curation_prompts.md`
- Source formatting gate: `ops/source_formatting_approval_gate.md`
- Critic validation results: `prompts/08_CRITIC_PROMPT_VALIDATION.md`
- Pairing inventory: query `pairings` directly (see `ops/daily_ops_routine_v1.md`)
- Decisions log: `weekly/W02_DECISIONS_LOG.md`
