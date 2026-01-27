# docs/ops/llm_curation_prompts.md
# LLM Curation Prompts (MVP v1) — Structured JSON Only

## 0) What this is
These prompts generate **candidate pairings** for “Literature × Scripture” in a strict JSON format.
**Important**: The LLM is NOT the source of truth for quotes/verses.
MVP should prefer:
- **Seeded verified pairs** (fastest, safest), OR
- **Public-domain snippet library** + verification + human spot-check.

Use LLM for:
- Theme framing
- Emotion suggestions
- Ranking / scoring
- Metadata (author/work confidence, tone check)

## 1) Output Contract (JSON Schema)
LLM must output a single JSON object:
- No markdown
- No explanations
- No extra keys

```json
{
  "locale": "en",
  "date_key": "YYYY-MM-DD",
  "theme": "string",
  "literature": {
    "text": "2-3 sentences max",
    "author": "string",
    "work": "string or null",
    "public_domain_confidence": "high|medium|low",
    "source_hint": "string or null"
  },
  "scripture": {
    "reference": "Book Chapter:Verse",
    "translation": "KJV|WEB|KRV|개역개정",
    "text": "exact verse text or null",
    "source_hint": "string or null"
  },
  "emotion_suggestions": ["peace|anxiety|weariness|loneliness|hope|gratitude|grief|confusion|joy"],
  "matching_rationale": "calm, non-preachy (required)",
  "quality_checks": {
    "no_guilt": true,
    "non_moralizing": true,
    "brevity_ok": true,
    "hallucination_risk": "low|medium|high"
  }
}
