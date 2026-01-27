# 08 Prompts Library
Last updated: 2026-01-24

Index of all prompt artifacts used in curation and validation. Prompts are used offline only; the app never calls LLMs directly.

## Active Prompt Assets
- Curator candidate generation (structured JSON): `ops/llm_curation_prompts.md`
- Critic validation prompt (pairing quality gate): `prompts/08_CRITIC_PROMPT_VALIDATION.md`
- Content constraints (tone/length rules): `ops/content_constraints.md`
- Emotion taxonomy (label keys): `ops/emotion_taxonomy.md`

## Usage Rules (MVP)
- LLM outputs are candidates only; never a source of truth.
- Quotes and verses must be verified against a trusted corpus.
- Bible verses are pulled from DB (no generation).
- Human approval is required before any pairing is visible.

## Output Expectations
- Literature excerpt: 2-3 sentences, <= 70 words.
- Verse: exactly 1 verse with canonical_ref and translation label.
- Rationale_short: 1 sentence max, calm, non-preachy, <= 240 chars.

## Notes
- Use structured JSON only; no markdown in LLM output.
- KO/EN are parallel but not forced translations; emotion keys must map 1:1.
