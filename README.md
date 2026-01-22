# quiet-curation-mvp
MVP implementation for literature - bible matching curation app

## Quiet Curation MVP
- Product: Faith-based daily curation (Literature/Quotes × Bible verse) + minimal emotion journal
- Principle: Remove cognitive debt. Keep it quiet, short, non-preachy.
- Platforms: Next.js PWA (mobile-first; iOS via Add to Home Screen) + Landing (Framer or Next.js)
- Backend: Supabase (Postgres + pgvector + Auth + Storage + Edge Functions)
- LLM Stack (pipeline-only): RAG + Critic (Batch pipeline). App consumes “approved snapshots” only.
- Monetization: Freemium — Free: Today view; Paid: Archive + Themes. No banner ads.
- Dev Tooling: Cursor + Codex extension (ChatGPT Plus) for implementation acceleration

## What has been building
A minimalist app that takes under 3 minutes per day:
1. Shows one daily pairing: a short literary/quote fragment + one Bible verse (no explanations).
2. Lets the user select an emotion (plus optional short memo 1–2 sentences).
3. Saves and closes with a gentle line.
   
No streaks, no XP, no guilt loops.
The app’s core differentiation is “quiet presence” + “anti-guilt” + bilingual KO/EN from day 1.

## Documentation
- `docs/README.md`
