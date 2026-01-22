# quiet-curation-mvp
A minimalist app that takes under 3 minutes per day:
- Shows one daily pairing: a short literary/quote fragment + one Bible verse (no explanations).
- Lets the user select an emotion (plus optional short memo 1–2 sentences).
- Saves and closes with a gentle line.


## Tech Stack/Tools/Platforms
- Product: Faith-based daily curation (Literature/Quotes × Bible verse) + minimal emotion journal
- Principle: Remove cognitive debt. Keep it quiet, short, non-preachy.
- Platforms: Next.js PWA (mobile-first; iOS via Add to Home Screen) + Landing (Framer or Next.js)
- Backend: Supabase (Postgres + pgvector + Auth + Storage + Edge Functions)
- LLM Stack (pipeline-only): RAG + Critic (Batch pipeline). App consumes “approved snapshots” only.
- Monetization: Freemium — Free: Today view; Paid: Archive + Themes. No banner ads for v1.
- Dev Tooling: Cursor + Codex extension (ChatGPT Plus) for implementation acceleration