# docs/ops/content_constraints.md
# Content Constraints (Curation) — MVP v1

## 0) Purpose
To ensure daily “Literature × Scripture” curation is:
- **Simple** (readable in seconds)
- **Reliable** (no hallucinated quotes/verses)
- **Resonant** (not preachy; not forced)
- **Safe for global i18n** (KO/EN)

MVP shows:
- Literature: **2–3 sentences**
- Scripture: **1 verse**
- No commentary (interpretation-free) in MVP

## 1) Core Principles (Non-Negotiable)
1. **No guilt / no moralizing:** do not shame, do not “should”.
2. **Quiet presence:** invitation, not demand.
3. **Intrinsic:** no “rewards” language.
4. **Verification > creativity:** never invent quotes or verses.
5. **Separation of logic/content:** store content per locale; do not hardcode.

## 2) Content Types & Length
### 2.1 Literature Snippet
- Length: **<= 70 words** (hard cap, per locale)
- Must include: **author + work title** (if known)
- Must be **verifiable** and ideally **public domain** for MVP
- Tone: reflective, human, non-preachy

✅ Allowed:
- Public-domain classics (Project Gutenberg etc.)
- Short aphorisms/essays in the public domain
- Clearly attributed quotes with a reliable source

❌ Not allowed (MVP):
- Unattributed “internet quotes”
- Modern copyrighted excerpts (unless you have permission/licensing)
- Paraphrases presented as direct quotes
- AI-generated “fake quotes”

### 2.2 Scripture Verse
- Exactly **1 verse** (reference + text)
- EN: **KJV or WEB** (choose one and stick to it for consistency)
- KO: **개역개정** (or a chosen licensed translation)
- Must be copied accurately from a trusted source

## 3) Matching Logic Constraints (How Pairing Should Feel)
### 3.1 Matching Standard
A pairing is “good” when:
- The emotional tone aligns (e.g., grief ↔ lament / comfort)
- The theme resonates (e.g., resilience ↔ perseverance)
- The connection is **non-forced** and **non-technical**

### 3.2 What NOT to do
- Do not claim “this verse explains this author”
- Do not force typology/allegory in MVP
- Do not do doctrinal debate
- Do not add interpretation; let users meditate

### 3.3 Output Must Be Self-Contained
Each item contains:
- `literature_text`
- `literature_author`
- `literature_work` (optional)
- `scripture_reference`
- `scripture_text`
- `emotion_suggestions` (0–3 emotion keys) — optional but recommended

## 4) Quality Gates (Release Checklist)
Before an item can be “published” in the MVP DB:

### Gate A — Authenticity
- Literature quote is verifiable via a reputable source.
- Scripture verse matches the chosen translation exactly.
- No hallucinated citations.

### Gate B — Brevity & Clarity
- Literature <= 70 words
- Scripture exactly 1 verse
- Reads comfortably within **10–20 seconds**

### Gate C — Tone
- No guilt language
- No manipulation (“God will punish/bless if…” style)
- No political/controversial hot takes

### Gate D — i18n Consistency
- KO and EN are **not forced translations of each other**.
- They may be **parallel** (same theme) but must be **native-sounding**.
- Emotion mapping keys remain identical across locales.

## 5) “LLM-Assisted” Constraints (MVP Implementation)
Because MVP wants speed, LLM can be used for:
- Suggesting candidate pairings
- Tagging suggested emotions
- Drafting short metadata (not the quote/verse itself)

### 5.1 Hard Rule: LLM cannot be the source of truth
- LLM must never fabricate quotes or verses.
- LLM output must be validated against a source list / stored corpus.

### 5.2 MVP Practical Approach
**Option 1 (Fastest & safest): Curated seed set + LLM emotion tagging**
- You manually compile 50–200 verified pairings (KO/EN separately).
- LLM only assigns `emotion_suggestions` and checks tone constraints.

**Option 2 (Semi-automated): Public-domain corpus + semantic search**
- Preload a public-domain quote/snippet library.
- Use embeddings search to find candidates by emotion/theme.
- LLM ranks top 3 and outputs structured JSON only.
- Human spot-check for the first 2–4 weeks.

## 6) Data Schema (Minimal Fields)
Per locale table (recommended: two tables or one with locale field):

- `id`
- `date_key` (YYYY-MM-DD) or `theme_day`
- `locale` (en / ko)
- `literature_text`
- `literature_author`
- `literature_work` (nullable)
- `scripture_reference`
- `scripture_text`
- `emotion_suggestions` (array of emotion keys)
- `source_url_lit` (nullable but recommended)
- `source_url_bible` (nullable but recommended)
- `created_at`

## 7) Themes (MVP Guidance)
Themes should map to modern life while staying spiritually grounded:
- Work / Career fatigue
- Resilience / endurance
- Anxiety / uncertainty
- Loneliness / belonging
- Gratitude / ordinary grace
- Grief / comfort
- Hope / renewal
- Wisdom / decisions
- Peace / stillness

## 8) Copy Guidelines (App Tone)
Allowed microcopy:
- “오늘은 여기까지만 해도 충분해요.”
- “조용히 한 절과 한 문장을 마음에 담아보세요.”
- “내일 다시 와도 괜찮아요.”

Disallowed:
- “왜 어제 안 했나요?”
- “연속 기록이 끊겼어요”
- “지금 당장 해야 합니다”
