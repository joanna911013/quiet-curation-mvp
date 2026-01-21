# Week 2 Execution Plan — Data & RAG MVP (Single Source of Execution Truth)

**Scope (Week 2):**
1) DB schema + verses ingestion + keyword search (Option C; embeddings deferred)  
2) Pairings show in Today view  
3) Emotion logs save  
4) Daily delivery (“quiet invite”) remains stable and deduped

**Operating Rules (Week 2):**
- Global daily snapshot: same **date + locale** => same Today pairing for all users
- Approved-only consumption: users see only approved snapshots
- No blank day: fallback to Safe Pairing Set if today snapshot missing/invalid
- Verse integrity: verse text must come from DB, not generated
- Emotion logs are captured (NOT used to change content in v1)

---

## Today — MORNING LOCK (fill in daily)
**Date:** YYYY-MM-DD  
**Day #:** Day 1 / Day 2 / Day 3 / Day 4 / Day 5  

### Goals (3)
1) Lock DB contract (schema + constraints + RLS)
2) Lock Today fetch contract (shape + fallback behavior)
3) Lock Pairing UI spec (Today/Detail + states)

### Freeze (2)
- Snapshot key fixed: (pairing_date, locale)
- No new screens beyond Week2 scope
-

### Gate Checks (5)
- [ ]  Schema + constraints documented
- [ ] RLS rules defined and testable
- [ ] Today fetch contract written (input/output)
- [ ] Pairing UI states defined
- [ ] Decisions log contains baseline 5 decisions

---

## Week 2 North Star Outcomes
1) Login → Today → Detail → Save → Saved works without friction  
2) Today renders pairing snapshot reliably (or fallback)  
3) Verse search works (Option C keyword search; embeddings deferred)  
4) Emotion logs save with correct RLS  
5) Daily ops (approve curation + pairing) can be done in ≤15 minutes

---

## Week 2 Definition of Done (DoD)
### Product
- Core screens: Login, Home(Today), Detail, Saved, Profile(min), Admin(min)
- Today shows: curation + pairing (verse + rationale + attribution)
- Emotion logging: primary emotion required, memo optional, “logged today” state

### Data & RAG
- `verses` populated + keyword search works (Option C; embeddings deferred)
- `pairings` stored as daily snapshot with unique `(pairing_date, locale)`
- `emotion_events` stored per user with RLS

### Ops
- Runbook exists and is runnable daily (≤15 min)
- Safe Pairing Set exists and prevents blank day

---

# Day 1 — Contracts & Foundations (Lane-Separated)

## Today — MORNING LOCK (MASTER)
**Date:** YYYY-MM-DD  
**Day #:** Day 1  

### Global Goals (3)
1) Lock DB contract (schema + constraints + RLS)  
2) Lock Today fetch contract (shape + fallback behavior)  
3) Lock Pairing UI spec (Today/Detail + states)  

### Global Freeze (2)
- Snapshot key is fixed: **(pairing_date, locale)** — do not change today  
- No new screens beyond Week 2 scope (Admin stays minimal)  

### Global Gate Checks (5)
- [ ] Schema + constraints are documented (no ambiguity)  
- [ ] RLS rules are defined and testable  
- [ ] Today fetch contract is written (input/output)  
- [ ] Pairing UI states are defined (loading/empty/error/missing/fallback)  
- [ ] Decisions Log contains the baseline 5 decisions  

---

## DEV Lane — Day 1
### Objectives
1) Finalize Week 2 schema (tables + constraints + indexes)  
2) Define RLS policies for user data + approved-only reads  
3) Write Today fetch contract (exact response shape)
4) RLS confirmed: pairings approved-only (authenticated), emotion_events own-only CRUD (authenticated), verses/verse_embeddings authenticated read (no public policies).

- [ ] Finalize tables:
  - [X] `verses` (locale, translation, book, chapter, verse, canonical_ref, verse_text)
  - [X] `verse_embeddings` (verse_id FK, embedding vector, model, dims)
  - [] `pairings` (pairing_date, locale, verse_id FK, curation_id optional, rationale_short, status)
  - [X] `emotion_events` (user_id, event_date, emotion_primary, memo_short optional, pairing_id/curation_id recommended)
- [X] Add constraints:
  - [X] Unique: `pairings(pairing_date, locale)`
  - [X] Unique (choose one): `emotion_events(user_id, event_date)` OR `emotion_events(user_id, event_date, curation_id)`
- [X] Add indexes:
  - [X] `pairings(pairing_date)` and `pairings(locale)`
  - [X] Vector index for `verse_embeddings.embedding` (prepare for Day 2)
- [x] Define RLS:
  - [x] `emotion_events`: user-scoped select/insert/update by `auth.uid()`
  - [x] `saved_items`: user-scoped select/insert/delete by `auth.uid()`
  - [x] `pairings`: read-only for users when `status='approved'`
  - [x] `verses`/`verse_embeddings`: readable for app usage (consistent rule)
- [x] Today fetch contract (write here in DEV lane):
  - Input: `(date, locale)`
  - Output: `curation (approved) + pairing (approved) + verse_text + verse_ref + translation + attribution fields`
  - Missing pairing behavior: `pairing=null` OR `{fallback:true}` (define clearly)
- [x] Routes & Layout (App Router) — REQUIRED TODAY
  - [x] Confirm/implement these routes exist (or stubs exist with safe states):
    - [x] `/login`
    - [x] `/` (Home: Today)
    - [x] `/c/[id]` (Detail)
    - [x] `/saved`
    - [x] `/profile` (minimal)
    - [x] `/admin` (stub only; full build Day 4)
  - [x] App Shell layout:
    - [x] Header with minimal nav (Home / Saved)
    - [x] Basic layout wrapper (mobile-safe spacing)
  - [x] Route guards:
    - [x] Unauthed user -> redirect to `/login` for protected routes
    - [x] Authed user visiting `/login` -> redirect to `/`
  - [x] Minimum UI states for each route:
    - [x] loading
    - [x] empty
    - [x] error

#### Today Fetch Contract

Function: getToday(date, locale)

Input:
- date: YYYY-MM-DD
- locale: "en" | "ko"

Returns:
- today_curation: { id, title, excerpt, body, attribution: { author, work, source_url } } | null
- today_pairing: { pairing_date, locale, verse_id, verse_text, verse_ref (canonical_ref), translation, pairing_reason_short, status } | null
- fallback: { is_fallback, reason } where reason is "missing_pairing" | "unapproved" | "join_failed"

Behavior:
- Non-admin callers only receive pairings where status = "approved".
- If pairing is missing or unapproved, return today_pairing = null and fallback.is_fallback = true (UI shows fallback state).
- If verse join fails, return today_pairing = null and fallback.reason = "join_failed".
- If pairing exists but curation join fails, return today_pairing and today_curation = null with fallback.reason = "join_failed".

#### Manual Test Steps
1) User A creates a saved_items row; User B cannot select or delete it (RLS isolation).
2) User A creates an emotion_events row; User B cannot select or update it (RLS isolation).
3) Non-admin user selects from pairings and only sees status = "approved"; admin can read drafts.
4) Authenticated user can read verses and verse_embeddings; unauthenticated access is denied (if enforced).
5) Attempt duplicate inserts to confirm unique constraints: pairings (pairing_date, locale) and emotion_events (user_id, event_date).

### Deliverables (must produce today)
- Migration SQL / schema changes applied in DEV
- RLS policy definitions + basic manual test steps
- Today fetch contract written in this file

### Freeze (DEV)
- Do not change snapshot key `(pairing_date, locale)`
- Do not introduce new feature tables outside Week 2 scope

### Gate (DEV must pass)
- [ ] `pairings` enforces unique `(pairing_date, locale)`
- [ ] `emotion_events` is user-scoped (no cross-user reads/writes)
- [ ] `pairings` are visible to users only when approved
- [ ] Today contract includes explicit missing-pairing behavior
- [ ] Required routes exist (at least stubbed) and route guards work
- [ ] `/c/[id]` handles 404 gracefully (no dead-end)

### DEV — Done
- RLS policies implemented for saved_items, emotion_events, pairings, verses, and verse_embeddings (per user).
- Today fetch contract documented with fallback behavior and manual verification steps.
- Routes and App Shell stubs in place with guards and loading/empty/error states.

### DEV — Blocked
- Awaiting schema migrations/constraints for Week 2 tables.

### DEV — Next
- Apply DB migrations + indexes and validate getToday query against real data.

---

## OPS Lane — Day 1
### Objectives
1) Decide translation + locale for Week 2  
2) Define initial verse scope (subset) for ingestion  
3) Draft pairing approval checklist (objective + enforceable)

### Tasks (Plan)
- [x] Decide Week2 translation + locale (start with 1):
  - Translation: NIV
  - Locale: en
- [x] Define verse scope for Day2 ingestion (subset, realistic):
  - Books / range: Psalms 23-30; Proverbs 3; Isaiah 40; Matthew 11; John 3; Romans 8; 1 Corinthians 13; Philippians 4
  - Target verse count for Day2: 300 (min)
- [ ] Draft pairing approval checklist (copy/paste runnable):
  - [X] Verse exists in DB (verse_id valid)
  - [X] Verse reference includes translation
  - [X] Literature attribution present (author/title at minimum)
  - [X] Excerpt length within limit (see MKT lane)
  - [X] Rationale is 1–2 sentences, calm tone
- [x] Seed/verify 5–10 curations ready for pairing workflow

### Deliverables
- Translation/locale decision logged in `W02_DECISIONS_LOG.md`
- Verse scope defined (subset + target count)
- Approval checklist draft completed

### Freeze (OPS)
- No approval without attribution + verse reference includes translation
- Keep scope realistic (no full ingestion attempt today)

### Gate (OPS must pass)
- [ ] Translation + locale locked
- [ ] Verse scope defined (books/range + target verse count)
- [ ] Approval checklist ready (objective, not vague)

### OPS — Done
- Translation/locale locked (en, NIV)
- Verse scope defined with target count (subset + min 300)
- Seeded/verified 5–10 curations with length/attribution constraints
### OPS — Blocked
- None.
### OPS — Next
- Draft pairing approval checklist (copy/paste runnable)

---

## MKT Lane — Day 1
### Objectives
1) Define source formatting rules (literature + verse)  
2) Define excerpt length limit + disclaimer trigger rule  
3) Provide microcopy keys for pairing + emotion prompt (short, calm)

### Tasks (Plan)
- [x] Source formatting spec (exact display strings):
  - Literature citation line: `— {Author}, *{Title}*{, Year}`
  - Verse reference line: `{Book} {Chapter}:{Verse} ({Translation})`
- [X] Approval-required fields (minimum):
  - Literature: at least one of {author/title}; URL optional
  - Verse: translation + canonical_ref required
- [x] Excerpt length limit (hard number):
  - Max characters: ________ OR Max sentences: ________
- [x] Disclaimer trigger rule (conditional only):
  - Show rights-holder notice only when: `license=unknown` OR excerpt exceeds limit
  - Copy: `Source provided for attribution. If you are the rights holder and want this removed, contact us.`
- [x] Microcopy keys (short):
  - “Today’s Pairing”
  - “Why this pairing?”
  - Emotion prompt: “How are you feeling right now?” (optional)

### Deliverables
- Formatting rules + excerpt limits + disclaimer rule finalized in this lane

### Freeze (MKT)
- No long marketing copy; keep it calm and short
- No extra campaigns beyond “quiet invite” concept

### Gate (MKT must pass)
- [ ] Rules are explicit enough to be used as an OPS approval gate
- [ ] Excerpt limit is a hard number (not vague)
- [ ] Disclaimers are conditional (trigger rule exists)

### MKT — Done
- Source formatting spec finalized (literature + verse) with rules and examples
- Disclaimer rule finalized (triggers, word-count method, copy, placement, examples)
- Microcopy keys drafted (defaults + alternates)
### MKT — Blocked
- None.
### MKT — Next
- Set excerpt length limit (hard number) and record in this lane
- Confirm approval-required fields (literature author/title; verse translation + canonical_ref)

---

## DESIGN Lane — Day 1
### Objectives
1) Pairing block spec for Today + Detail (implementable)  
2) Define verse formatting + truncation rules  
3) Define UI states (pairing missing, fallback, error)

### Tasks (Plan)
- [x] Today pairing preview spec:
  - Fields shown: verse reference line + verse text snippet (no rationale in Today preview)
  - Max lines/characters: line clamp to 2 lines and 120 characters; truncate with ellipsis if either limit is exceeded
  - Tap behavior: entire block opens Detail (no secondary CTA)
- [x] Detail pairing section spec:
  - Verse reference (required, includes translation)
  - Verse text (DB-sourced, full verse; no truncation)
  - Rationale (1-2 sentences, calm tone)
  - Attribution placement: literature citation line under literature excerpt; verse translation shown in reference line
- [x] State spec:
  - Loading: skeleton for verse reference + 2 text lines
  - Pairing missing (today curation exists, pairing not set): show "Pairing not set for today." + "Check back later."
  - Fallback shown (safe set): show label "Fallback pairing" above the block; content renders normally
  - Error + retry: show "Unable to load pairing." with "Retry"
- [x] Verse reference display rule (final):
  - `{Book} {Chapter}:{Verse} ({Translation})`
- [x] Mobile readability rules:
  - Body text 16px, line-height 1.5; reference line 12-13px, line-height 1.4
  - Spacing: 8px between reference and verse text; 16px between blocks

### Deliverables
- Implementable pairing block spec + all states defined (no ambiguity)

### Freeze (DESIGN)
- No new screens; keep existing routes
- No changes requiring schema changes today (request via Decisions Log)

### Gate (DESIGN must pass)
- [x] Spec is implementable without follow-up questions
- [x] Mobile readability rules included (spacing / line length)
- [x] State handling is complete

### DESIGN — Done
- Today/Detail pairing block specs finalized with truncation rules
- UI states specified (loading, missing, fallback, error + retry)
- Mobile readability rules documented
### DESIGN — Blocked
- None.
### DESIGN — Next
- DEV: implement line clamp + fallback label in Today/Detail pairing blocks

---

## MASTER Lane — Day 1
### Objectives
1) Ensure baseline decisions are written (5 entries)  
2) Enforce scope discipline (Week 2 only)  
3) Run Evening Gate and set Day 2 numeric targets

### Tasks (Plan)
- [x] Confirm these 5 baseline decisions exist in `W02_DECISIONS_LOG.md`:
  - Daily snapshot key = (pairing_date, locale)
  - Approved-only consumption
  - No blank day via Safe Pairing Set fallback
  - Verse text must come from DB (no generation)
  - Emotion logs captured but do not alter Today in v1
- [x] Ensure each agent updated only their lane in this file
- [x] Set Day 2 numeric targets:
  - Min verses ingested: 300
  - Text search top_k: 5
  - Embeddings: deferred (Option C; no paid embeddings Day2)

### MASTER — Done
- Baseline decisions verified in `W02_DECISIONS_LOG.md`
- Day 2 numeric targets set (ingested 300, text search top_k 5; embeddings deferred)
### MASTER — Blocked
- None.
### MASTER — Next
- Run end-of-day review and confirm Day 2 handoff notes

---

## Today — EVENING GATE (MASTER)
### Done
- Day 1 lanes updated; MKT/DESIGN/OPS entries recorded
- Day 2 targets recorded and shared
### Blocked
- None.
### Carry-over (explicit)
- Day 2 DEV: ingest verses, run keyword search (Option C), validate search
- OPS: draft pairing approval checklist (copy/paste runnable)
- MKT: confirm approval-required fields (literature author/title; verse translation + canonical_ref)

### Decisions Recorded?
- [x] Yes (added to W02_DECISIONS_LOG.md)
- [ ] No

---

# Day 2 — Verse Ingestion + Keyword Search + Save Loop Stability (Option C)
## DEV Lane
**Plan**
- [ ] Verses ingestion (idempotent)
  - [ ] Ingest Day2 subset (~300) with OPS normalization rules
  - [ ] Ensure fields present: `locale`, `translation`, `book`, `chapter`, `verse`, `canonical_ref`, `verse_text`
  - [x] Dedupe rule: prevent duplicates for same `(translation, locale, book, chapter, verse)`
  - [x] Sample ingest run (3 rows) to verify pipeline
- [x] Embeddings generation deferred (Option C)
  - [x] Embedding script exits cleanly without OPENAI_API_KEY (no writes)
  - [x] Embedding writes require `--mode openai` (skip by default)
- [x] Keyword search contract (FTS)
  - [x] Define RPC `search_verses(query_text, locale, translation, top_k)`
  - [x] Create FTS GIN index on `verses.verse_text` (with fallback to legacy `text`)
  - [x] Add `/search-check` server page for sanity queries
- [x] Search sanity tests (Option C)
  - [x] Run `/search-check` (shepherd/rest/anxiety) and record results
- [x] Product loop: Save/Unsave on Detail (must be stable today)
  - [x] Save button toggle states
  - [x] Idempotent upsert with unique `(user_id, pairing_id)`
  - [x] Optimistic UI + rollback on failure
  - [x] Persist server timestamp via `created_at`
  - [x] Saved screen renders user’s saved list (RLS-safe)
**Done**
- [x] Save/Unsave loop stable with server actions + optimistic UI; Saved list renders per user.
- [x] Profile screen shows email and supports logout.
- [x] Keyword search RPC + `/search-check` added; shepherd + anxiety queries return anchors; rest empty.
- [x] Embedding script set to skip by default for Option C.
**Blocked**
- Full 300-row verse ingest pending (sample ingest only).
**Next**
- Run full Day2 verse ingest when dataset is ready.
- Confirm `rest` query returns Matthew 11:28 once verse text is present.
**Day 2 DEV — Gate (must pass)**
- [ ] `verses` count (NIV/en) ≥ 300 (or ≥ minimum agreed for today)
- [x] Keyword search RPC works for locale/translation filters
- [ ] Search sanity queries pass for shepherd/rest/anxiety (rest pending)
- [x] Save/Unsave loop works end-to-end for one user without duplicates

## DESIGN Lane
**Plan**
- [x] Lock verse display spec (Today vs Detail) and publish to docs (`docs/design/verse_display_spec.md`)
- [ ] Confirm truncation rules are implemented (Today clamp vs Detail full)
- [ ] Confirm fallback label rendering is calm + non-alarming (if shown)
- [ ] Confirm Save button states in Detail (saved / not saved / disabled while saving)

**Done**
- Locked Verse Display Spec (Today vs Detail) for Today (/) and Detail (/c/[id]) screens.
  - Global rules:
    - Verse text must be DB-sourced only (no generation).
    - Reference line format: "{Book} {Chapter}:{Verse} ({Translation})"; single line with ellipsis if overflow.
    - Reference line always shown; verse block uses same container on Today and Detail.
  - Today (preview):
    - Show reference line + verse text preview; rationale not shown.
    - Truncation: line clamp 2 lines; fallback max 140 chars (trim to word boundary) + "...".
    - Ellipsis only at end; if text fits, show full preview.
    - Entire verse block is tap target to open Detail.
  - Detail:
    - Reference line always visible, single line.
    - Verse text shows full text, no truncation; preserve line breaks (pre-line or paragraphs).
    - Rationale shown below verse text; target 1-2 sentences; clamp to 3 lines with ellipsis if longer (no expand in v1).
    - If verse missing: "Verse unavailable right now." + "Pull to refresh or try again."
    - If rationale missing: hide rationale section entirely.
  - Typography + spacing (mobile-first):
    - Reference line: 12px, weight 600, line-height 1.4, color #6b6b6b.
    - Verse text: 17px, weight 400-500, line-height 1.6, color #111111; paragraph spacing 8px.
    - Rationale: 14px, weight 400, line-height 1.5, color #5c5c5c; not italic.
    - Spacing: reference->verse 8px; verse->rationale 12px; block padding 16px; block margin-bottom 16px.
  - Labels (if present):
    - Fallback label text: "Alternate pairing"; show only when fallback pairing is used.
    - Approved-only label text: "Approved" (admin/debug only; do not show to end users).
    - Placement: above reference line, left-aligned inside verse block; style 10px uppercase, letter-spacing 0.12em, color #9a9a9a.
  - States:
    - Loading Today: skeleton with reference line + 2 verse lines.
    - Loading Detail: skeleton with reference line + 3 verse lines + 2 rationale lines.
    - Empty (no pairing after fallback): "No pairing yet. Check back later." + Retry.
    - Error: "Unable to load verse. Check connection and retry." + Retry.
    - Unapproved pairing: treat as empty unless fallback data exists.
  - NOTE: This locked spec supersedes Day 1 draft numbers in this doc.
  - DEV implementation checklist (see `docs/design/verse_display_spec.md`):
    - Apply Today truncation rules (2-line clamp + 140-char fallback + ellipsis) and hide rationale.
    - Detail shows full verse text; rationale clamps to 3 lines; hide rationale if missing.
    - Add label row handling (fallback + approved-only) per spec.
    - Apply typography + spacing tokens and state copy per spec.
**Blocked**
- 
**Next**
- Carry-over: confirm truncation rules are implemented (Today clamp vs Detail full).
- Carry-over: confirm fallback label rendering is calm + non-alarming (if shown).
- Carry-over: confirm Save button states in Detail (saved / not saved / disabled while saving).

## OPS Lane
**Plan**
- [ ] (Carry-over) Draft pairing approval checklist (copy/paste runnable)
- [ ] After DEV ingestion: verify DB rows match source spec (spot-check 10)
- [ ] Run search acceptance checks after keyword search is enabled
- [x] Load initial verses dataset (spec + scope ready for DEV ingestion)
- [x] Spot-check references/text correctness (sample)
- [x] Create "anchor verse" list for sanity tests

**Done**
- Locked Day 2 subset scope (locale/translation + books/chapters below).
- Drafted ingestion-ready dataset spec with normalization rules.
- Spot-checked 10 verses (NIV text/ref/label OK; no encoding issues in sample).
- Built 10 anchor verses and search acceptance criteria (Option C).
**Blocked**
- None.
**Next**
- DEV: ingest verses and run keyword search per spec.
- OPS: re-validate spot-check against DB rows after ingestion.

### Day 2 OPS - Subset Scope (Frozen)
- Locale: en
- Translation: NIV
- Scope (books/chapters): Psalms 23-30; Proverbs 3; Isaiah 40; Matthew 11; John 3; Romans 8; 1 Corinthians 13; Philippians 4.
- Target verse count (Day 2): ~300 (min 300).

### Day 2 OPS - Dataset Spec (Ingestion-Ready)
Required fields per verse:
- locale
- translation
- book
- chapter
- verse
- canonical_ref
- verse_text

Normalization rules:
- Book names: Title Case, standard full names; use numerals with a space (e.g., "1 Corinthians"); use "Psalms" not "Psalm".
- canonical_ref: "{Book} {Chapter}:{Verse}" using the same book name as `book` (e.g., "Psalms 23:1").
- chapter/verse: integers with no leading zeros.
- verse_text: trim leading/trailing whitespace; collapse internal whitespace to single spaces; preserve original punctuation/casing (e.g., "LORD" stays uppercase).

Dataset source + license:
- Source: NIV verse text from a licensed source (ingested into DB; no generation).
- License/attribution: NIV is copyrighted; ensure licensed source and required attribution; keep translation label = "NIV".

### Day 2 OPS - Spot-Check Results (10 Verse Sample)
- Sampled refs: Psalms 23:1, 24:1, 27:1; Proverbs 3:5; Isaiah 40:31; Matthew 11:28; John 3:16; Romans 8:28; 1 Corinthians 13:4; Philippians 4:6.
- Result: reference matches expected NIV text; translation label = NIV; no broken characters observed.
- If mismatch appears post-ingest: verify source file and enforce whitespace-only normalization (do not alter punctuation/casing).

### Day 2 OPS - Anchor Verse List (10)
- Psalms 23:1 (NIV) - "The Lord is my shepherd, I lack nothing." - keywords: shepherd, lack
- Psalms 24:1 (NIV) - "The earth is the Lord's, and everything in it, the" - keywords: earth, world
- Psalms 27:1 (NIV) - "The Lord is my light and my salvation - whom" - keywords: light, fear
- Proverbs 3:5 (NIV) - "Trust in the Lord with all your heart and lean" - keywords: trust, understanding
- Isaiah 40:31 (NIV) - "but those who hope in the Lord will renew their" - keywords: strength, hope
- Matthew 11:28 (NIV) - "Come to me, all you who are weary and burdened," - keywords: rest, weary
- John 3:16 (NIV) - "For God so loved the world that he gave his" - keywords: love, world
- Romans 8:28 (NIV) - "And we know that in all things God works for" - keywords: good, purpose
- 1 Corinthians 13:4 (NIV) - "Love is patient, love is kind. It does not envy," - keywords: love, kind
- Philippians 4:6 (NIV) - "Do not be anxious about anything, but in every situation," - keywords: prayer, anxiety

### Day 2 OPS - Text Search Acceptance Criteria (Option C)
- Min verses ingested: 300 (scope above).
- Embeddings deferred (Option C; no paid embeddings in Day 2).
- Search sanity (top_k = 5, keyword/FTS):
  - Query "shepherd" returns Psalms 23:1 (NIV) in top_k.
  - Query "rest" returns Matthew 11:28 (NIV) in top_k.
  - Query "anxiety" returns Philippians 4:6 (NIV) in top_k.

**Final Notes**
- `canonical_ref` is stored without translation (e.g., "Psalms 23:1"); UI displays as `"Psalms 23:1 (NIV)"`.
- NIV text must come from the licensed dataset used for ingestion; keep a clear source/version note for reproducibility.

**Day 2 OPS — Gate (must pass)**
- [ ] Ingested verses ≥ 300 (scope frozen)
- [ ] Text search checks pass (shepherd/rest/anxiety, top_k=5)
- [ ] Approval checklist is runnable and objective (no vague wording)

## MKT Lane
**Plan**
- [ ] (Carry-over) Confirm approval-required fields (enforceable)
  - [ ] Literature: at least one of `literature_author` or `literature_title` (URL optional)
  - [ ] Verse: UI reference requires `canonical_ref` + `(NIV)` translation label
- [x] Provide 5–10 sample rationales (tone reference only; 1–2 calm sentences)
- [ ] Confirm “quiet invite” snippet constraints (delivery-safe)
  - [ ] Max: 1 verse ref line + 1 rationale line (no long excerpts in delivery)

### Day 2 MKT — Excerpt Limit + Rationale Examples (Final)
Excerpt Limit (Final)
- Primary rule: `excerpt_word_count <= 70`
- Word count method: trim leading/trailing whitespace, then count whitespace-separated tokens
- Over-limit behavior (approval rule): reject for approval until trimmed to <= 70 words
- Secondary guardrail (optional): `sentence_count <= 3` where sentence_count = count of sentence-ending punctuation marks (. ! ?)

Rationale Examples (10)
1. A quiet reminder that rest can be found even when the day is unfinished. Let the weight ease for a moment.
2. When worries feel loud, this offers a small place to breathe. You do not need to solve everything right now.
3. In the middle of fatigue, this points to steady support rather than quick fixes. One small step is enough.
4. Even thin hope can be held gently; this keeps it simple and close. It suggests a path forward without rushing.
5. Gratitude can be small and still real; this invites a quiet notice of what remains. Let that be enough today.
6. For grief, this holds space without explaining it away. It honors the ache and the slow work of comfort.
7. If things feel unclear, this stays with the uncertainty rather than forcing answers. A calm pause is still progress.
8. Joy here is soft and grounded, not loud. It makes room to notice what is already good.
9. When you feel alone, this keeps company without asking for more. A gentle steadiness can be enough.
10. In moments of fear, this leans toward light and steadiness. It invites a quiet return to what is firm.

**Done**
- Excerpt length limit finalized (70-word cap + sentence guardrail)
- Rationale tone examples drafted (10)
**Blocked**
- None.
**Next**
- (Carry-over) Confirm approval-required fields (enforceable)
- Confirm “quiet invite” snippet constraints (delivery-safe)

---

## MASTER Lane
**Plan**
- [x] Set stop conditions (what “good enough” means today)
  - [ ] Verses ≥ 300, keyword search queries pass (shepherd/rest/anxiety)
  - [x] Save loop stable end-to-end once
- [x] Run Day 2 evening gate and record carry-overs

**Done**
- Save/Unsave loop stable end-to-end for one user (no duplicates).
- Keyword search RPC + `/search-check` live; shepherd + anxiety anchors found.
- Verse display spec locked; Day 2 dataset spec + anchor verses ready.
**Blocked**
- Full verse ingest (>= 300) pending; `rest` sanity blocked until Matthew 11:28 ingested.
**Next**
- Run full verse ingest and re-run `rest` sanity; update DEV/OPS gates.
- Confirm Today/Detail truncation + fallback label + Save button states in UI.
- Finalize approval checklist + quiet invite snippet constraints.

---

## Today — EVENING GATE (MASTER)
### Done
- DEV: Save/Unsave loop stable; keyword search RPC + `/search-check`; embedding script skip default.
- DESIGN: Verse display spec locked in `docs/design/verse_display_spec.md`.
- OPS: Day 2 subset scope + dataset spec locked; anchor verses + spot-checks done.
- MKT: Excerpt limit finalized; rationale examples drafted.
### Blocked
- Full verse ingest (>= 300) pending; `rest` search sanity blocked until Matthew 11:28 ingested.
### Carry-over (explicit)
- DEV: run full verse ingest; re-run search sanity (`rest`) and update gates.
- DESIGN: confirm truncation implementation, fallback label rendering, Save button states.
- OPS: draft approval checklist; verify DB rows post-ingest; run search acceptance checks.
- MKT: confirm approval-required fields; confirm quiet invite snippet constraints.
### Decisions Recorded?
- [X] Yes (added to `W02_DECISIONS_LOG.md`)
- [] No

---

# Day 3 — Pairings Pipeline + Today Joins + Quiet Invite Uses Pairing When Available

## DEV Lane
**Plan**
- [ ] Pairings pipeline (draft → approved)
  - [ ] Enforce unique `(pairing_date, locale)` behavior (update vs insert policy)
  - [x] Ensure non-admin reads are approved-only
- [ ] Today query joins reliably
  - [ ] `pairings` + `verses` join must always return: `verse_text`, `canonical_ref`, `translation`
  - [x] Define join-failure behavior (fallback reason)
- [ ] Delivery dedupe (stability)
  - [x] Ensure “quiet invite” is deduped to 1/day/user (no double send)
  - [x] Deep link routes remain valid (Today or Detail)
- [x] Quiet invite email pipeline (Task D)
  - [x] Template renders with pairing optional
  - [x] Provider abstraction + dry-run default
  - [x] Cron uses pairing/verse when available
  - [x] Missing recipient emails skipped (no failure)
- [ ] Minimal Saved stability check (regression)
  - [ ] Save/Unsave still works after Today join changes

**Done**
- [x] Delivery dedupe confirmed via script (1st run inserts, 2nd run skips).
- [x] Deep-link login redirect works with `/login?redirect=/c/[id]`.
- [x] Quiet invite email sending wired (template + provider abstraction + dry-run default).
- [x] Cron uses approved-only pairing for today; falls back to env var if none.
- [x] Manual approval SQL snippet added (scripts/sql/approve_pairing.sql).
**Blocked**
- 
**Next**
- Carry-over: pairings pipeline (draft → approved) and Today joins (pairings + verses).
- Carry-over: verify Save/Unsave still works after Today join changes.

**Day 3 DEV — Gate (must pass)**
- [ ] Able to set a pairing for a date+locale and see it in Today (approved-only)
- [ ] Today join returns verse + reference + rationale without nulls (or clean fallback)
- [x] Delivery dedupe confirmed (no duplicate invite runs for same day)

---

## DESIGN Lane
**Plan**
- [x] Pairing component spec locked (Today vs Detail) with hierarchy + tone guidance
- [x] Fallback behavior decision (no pairing available) finalized: omit pairing section, no copy
- [x] Wireframe annotations added for Today + Detail pairing placement

**Done**
- Pairing component spec published: `docs/design/pairing_component_spec.md`.
- Wireframe annotations published: `docs/design/wireframes/day3_pairing_annotations.md`.
- Detail rationale section defined with heading "Why this pairing?" and 2-4 line rationale cap.
- Fallback behavior: omit pairing section entirely when no pairing is available; no error/empty copy in the pairing area.
**Blocked**
- 
**Next**
- DEV: implement pairing component spec during UI pass (Today + Detail).

---

## OPS Lane
**Plan**
- [ ] Create initial pairings inventory (draft)
- [ ] Approve at least 1 pairing for “today” (date+locale)
- [ ] Start Safe Pairing Set seed (target 20 over Week 2; start here)
- [ ] Operator rehearsal (single run)
  - [ ] Approve pairing → verify Today → verify fallback toggle (by removing today)

**Done**
- 
**Blocked**
- 
**Next**
- 

---

## MKT Lane
**Plan**
- [ ] Quiet invite subject line set (3–5 options; calm)
- [ ] Confirm attribution display strings in Today/Detail align with spec
- [ ] Confirm fallback label copy (if shown)

**Done**
- 
**Blocked**
- 
**Next**
- 

---

## MASTER Lane
**Plan**
- [ ] Run one end-to-end rehearsal and record gaps
  - [ ] Login → Today (approved pairing shows) → Detail → Save → Saved
  - [ ] Remove today pairing → fallback appears (no blank day)
- [ ] Update decision log if any behavioral contract changes

**Done**
- 
**Blocked**
- 
**Next**
- 

---

## Today — EVENING GATE (MASTER)
### Done
- 
### Blocked
- 
### Carry-over (explicit)
- 
### Decisions Recorded?
- [ ] Yes (added to `W02_DECISIONS_LOG.md`)
- [ ] No

---

# Day 4 — Admin Ops Mode + Safe Pairing Set + No Blank Day Drill

## DEV Lane
**Plan**
- [ ] Admin access control (role-based)
  - [ ] Only admin can create/edit/approve pairings
  - [ ] Users remain read-only approved consumption
- [ ] Admin minimal workflows
  - [ ] Set/approve pairing for `(pairing_date, locale)`
  - [ ] Approve flow is one-click / minimal form
- [ ] Fallback behavior hardened
  - [ ] If today missing/unapproved/join_failed → use Safe Pairing Set
  - [ ] Fallback reason surfaced to UI contract (for debugging only)

**Done**
- 
**Blocked**
- 
**Next**
- 

**Day 4 DEV — Gate (must pass)**
- [ ] Admin can set today pairing in ≤ 3 minutes
- [ ] Users never see draft pairings
- [ ] “No blank day” verified (forced missing-today drill)

---

## DESIGN Lane
**Plan**
- [ ] Admin UI minimal layout spec check (only required fields)
- [ ] Mobile QA for Today/Detail/Saved regression

**Done**
- 
**Blocked**
- 
**Next**
- 

---

## OPS Lane
**Plan**
- [ ] Expand Safe Pairing Set inventory (target 20; minimum 10 by end of Day 4)
- [ ] Daily routine draft (≤15 min)
  - [ ] Approve pairing → verify Today → verify delivery dedupe → spot-check attribution

**Done**
- 
**Blocked**
- 
**Next**
- 

---

## MKT Lane
**Plan**
- [ ] Final microcopy for:
  - [ ] Pairing block labels
  - [ ] Fallback label (quiet)
  - [ ] Emotion prompt confirmation copy (calm)

**Done**
- 
**Blocked**
- 
**Next**
- 

---

## MASTER Lane
**Plan**
- [ ] Missing-today drill: remove today pairing → fallback verified
- [ ] Time the daily ops run and confirm ≤15 minutes
- [ ] Record any contract changes as decisions

**Done**
- 
**Blocked**
- 
**Next**
- 

---

## Today — EVENING GATE (MASTER)
### Done
- 
### Blocked
- 
### Carry-over (explicit)
- 
### Decisions Recorded?
- [ ] Yes (added to `W02_DECISIONS_LOG.md`)
- [ ] No

---

# Day 5 — Emotion Logs Ship + Hardening + Week 2 Final Gate

## DEV Lane
**Plan**
- [ ] Emotion logging end-to-end
  - [ ] Primary emotion required, memo optional
  - [ ] Deduped by unique `(user_id, event_date)` (or chosen unique constraint)
  - [ ] “Logged today” UI state
- [ ] RLS verification (must be explicit)
  - [ ] User A cannot read/write User B emotion events
- [ ] E2E QA scenarios (Week 2 final)
  - [ ] Today pairing present
  - [ ] Today pairing missing → fallback
  - [ ] Detail → Save/Unsave → Saved list stable
  - [ ] Delivery dedupe holds (if running)
- [ ] Minimal observability hooks (debug-level)
  - [ ] Log today fetch failure reasons
  - [ ] Log emotion save failures

**Done**
- 
**Blocked**
- 
**Next**
- 

---

## DESIGN Lane
**Plan**
- [ ] Emotion UI: minimal, skippable, calm confirmation
- [ ] Final mobile QA checklist (Today/Detail/Saved/Profile)

**Done**
- 
**Blocked**
- 
**Next**
- 

---

## OPS Lane
**Plan**
- [ ] Finalize daily runbook (≤15 min; copy/paste steps)
- [ ] Spot-check 3 approved pairings for attribution compliance
- [ ] Confirm Safe Pairing Set inventory meets minimum

**Done**
- 
**Blocked**
- 
**Next**
- 

---

## MKT Lane
**Plan**
- [ ] Release notes bullets (internal)
- [ ] Quiet invite copy final (if any adjustments needed)
- [ ] Confirm disclaimer trigger rule is consistent with ops checklist

**Done**
- 
**Blocked**
- 
**Next**
- 

---

## MASTER Lane — Final Gate (Must Pass)
- [ ] Today renders approved pairing snapshot (date+locale) or safe fallback (no blank day)
- [ ] Verse text always DB-sourced; verse reference includes translation label (NIV)
- [ ] Keyword search sanity checks pass (Option C; embeddings deferred)
- [ ] Save/Unsave loop stable; Saved list accurate per user (RLS)
- [ ] Emotion logs save + user isolation verified
- [ ] Daily ops runnable in ≤15 minutes (timed)
