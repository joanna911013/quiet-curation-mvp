# Week 2 Execution Plan — Data & RAG MVP (Single Source of Execution Truth)

**Scope (Week 2):**
1) DB schema + verses embeddings  
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
3) Verse embeddings pipeline works and is re-runnable  
4) Emotion logs save with correct RLS  
5) Daily ops (approve curation + pairing) can be done in ≤15 minutes

---

## Week 2 Definition of Done (DoD)
### Product
- Core screens: Login, Home(Today), Detail, Saved, Profile(min), Admin(min)
- Today shows: curation + pairing (verse + rationale + attribution)
- Emotion logging: primary emotion required, memo optional, “logged today” state

### Data & RAG
- `verses` populated + embeddings stored + vector search works
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
  - Min verses embedded: 295
  - Similarity search top_k: 5

### MASTER — Done
- Baseline decisions verified in `W02_DECISIONS_LOG.md`
- Day 2 numeric targets set (ingested 300, embedded 295, top_k 5)
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
- Day 2 DEV: ingest verses, run embeddings, validate search
- OPS: draft pairing approval checklist (copy/paste runnable)
- MKT: confirm approval-required fields (literature author/title; verse translation + canonical_ref)

### Decisions Recorded?
- [x] Yes (added to W02_DECISIONS_LOG.md)
- [ ] No

---

# Day 2 — Verse Ingestion + Embeddings + Save Loop Stability
## DEV Lane
**Plan**
- [ ] Build ingestion (idempotent) for verses
- [ ] Build embeddings batch + store model/dims
- [ ] Add vector search function (top_k + min_similarity)
- [ ] Ensure Save/Saved screens + RLS tests are stable

**Done**
- 
**Blocked**
- 
**Next**
- 

## DESIGN Lane
**Plan**
- [ ] Truncation rules for verse text (Today vs Detail)
- [ ] Readability polish notes for verse block

**Done**
- 
**Blocked**
- 
**Next**
- 

## OPS Lane
**Plan**
- [ ] (Carry-over) Draft pairing approval checklist (copy/paste runnable)
- [x] Load initial verses dataset (spec + scope ready for DEV ingestion)
- [x] Spot-check references/text correctness (sample)
- [x] Create "anchor verse" list for sanity tests

**Done**
- Locked Day 2 subset scope (locale/translation + books/chapters below).
- Drafted ingestion-ready dataset spec with normalization rules.
- Spot-checked 10 verses (NIV text/ref/label OK; no encoding issues in sample).
- Built 10 anchor verses and embedding/search acceptance criteria.
**Blocked**
- None.
**Next**
- DEV: ingest verses and run embeddings per spec.
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

### Day 2 OPS - Embedding/Search Acceptance Criteria (OPS Gate)
- Min verses ingested: 300 (scope above).
- Min verses embedded: 295 (>= ingested - 5).
- Embedding metadata stored: model name + dims for each embedded row.
- Search sanity (top_k = 5):
  - Query "shepherd" returns Psalms 23:1 (NIV) in top_k.
  - Query "love" returns 1 Corinthians 13:4 (NIV) or John 3:16 (NIV) in top_k.
  - Query "comfort" returns Psalms 23:1 (NIV) in top_k.
  - Query "rest" returns Matthew 11:28 (NIV) in top_k.
  - Query "anxiety" returns Philippians 4:6 (NIV) in top_k.

**Final Notes**
- `canonical_ref` is stored without translation (e.g., "Psalms 23:1"); UI displays as `"Psalms 23:1 (NIV)"`.
- NIV text must come from the licensed dataset used for ingestion; keep a clear source/version note for reproducibility.

## MKT Lane
**Plan**
- [ ] (Carry-over) Confirm approval-required fields (literature author/title; verse translation + canonical_ref)
- [ ] Provide 5–10 sample pairing rationales (tone reference)
- [ ] Confirm email pairing snippet rule (max 1 verse line + 1 rationale line)

### Day 2 MKT — Approval Gate Specs (Final)
Source Formatting Spec (approval gate)
- Literature citation line (exact format): `— {Author}, *{Title}*{, Year}`
- Rules:
  - Prefix with em dash + single space: `— `
  - Title must be wrapped in markdown italics: `*Title*`
  - If Year is missing: omit `, Year` cleanly (no trailing comma)
  - If Author is missing: default to `Unknown author`
  - If Title is missing: default to `Untitled`
  - Trim extra whitespace; no double spaces
- Examples:
  - `— Virginia Woolf, *To the Lighthouse*, 1927`
  - `— James Baldwin, *The Fire Next Time*`
  - `— Unknown author, *A Quiet Room*, 1901`

Verse reference line (approval gate)
- Required format: `{Book} {Chapter}:{Verse} ({Translation})`
- Rules:
  - Book names in Title Case with standard full names
  - Numerals with a space (e.g., "1 Corinthians")
  - No extra punctuation beyond the colon in Chapter:Verse
- Examples:
  - `Psalms 23:1 (NIV)`
  - `John 3:16 (NIV)`
  - `1 Corinthians 13:4 (NIV)`

Disclaimer Rule (conditional only)
- Trigger when `license_status = "unknown"` OR `excerpt_word_count > 90`
- Word-count method: `word_count = number of whitespace-separated tokens after trimming`
- Disclaimer copy (exact): `Attribution only. If you are the rights holder and want this removed, contact us.`
- Placement: show only when triggered, at the bottom of the literature excerpt block (not global)
- Examples:
  - Example A (license unknown; disclaimer shown):
    - Input: `license_status="unknown"`, `excerpt_word_count=42`
    - Output (literature block):
      - `A short, verified excerpt.`
      - `— Jane Austen, *Pride and Prejudice*, 1813`
      - `Attribution only. If you are the rights holder and want this removed, contact us.`
  - Example B (excerpt > 90 words; disclaimer shown):
    - Input: `license_status="licensed"`, `excerpt_word_count=112`
    - Output (literature block):
      - `A long excerpt exceeding the 90-word limit.`
      - `— Ralph Waldo Emerson, *Self-Reliance*, 1841`
      - `Attribution only. If you are the rights holder and want this removed, contact us.`

Microcopy keys (EN; defaults + up to 2 alternates)
- Default: “Today’s Pairing”
  - Alternates: “Today’s Pair”, “Today’s pairing”
- Default: “Why this pairing?”
  - Alternates: “Why this pair?”, “Why this match?”
- Default: “How are you feeling right now?”
  - Alternates: “How do you feel today?”, “How are you feeling today?”

**Done**
- 
**Blocked**
- 
**Next**
- 

## MASTER Lane
**Plan**
- [ ] Set stop conditions (min embedded verses; “good enough” search bar)

**Done**
- 
**Blocked**
- 
**Next**
- 

---

# Day 3 — Pairings Pipeline + Quiet Invite Includes Pairing When Available
## DEV Lane
**Plan**
- [ ] Store pairing snapshots as draft→approved with unique(date, locale)
- [ ] Today query joins curation + pairing + verse
- [ ] Email template optionally includes pairing snippet (if present)
- [ ] Dedupe deliveries (1/day/user)

**Done**
- 
**Blocked**
- 
**Next**
- 

## DESIGN Lane
**Plan**
- [ ] Pairing block final UI spec (verse + rationale + attribution)
- [ ] Fallback label micro-rule (quiet, not alarming)

**Done**
- 
**Blocked**
- 
**Next**
- 

## OPS Lane
**Plan**
- [ ] Create + approve initial pairings inventory
- [ ] Build Safe Pairing Set (target 20)
- [ ] Operator rehearsal: approve today + verify Today renders + verify email

**Done**
- 
**Blocked**
- 
**Next**
- 

## MKT Lane
**Plan**
- [ ] Quiet invite subject line set (3–5)
- [ ] Confirm attribution display strings

**Done**
- 
**Blocked**
- 
**Next**
- 

## MASTER Lane
**Plan**
- [ ] Run end-to-end rehearsal once and record gaps

**Done**
- 
**Blocked**
- 
**Next**
- 

---

# Day 4 — Admin Ops Mode (Curation + Pairing Approval) + No Blank Day
## DEV Lane
**Plan**
- [ ] Admin access control (role-based)
- [ ] Admin: create/edit/approve curations + set Today
- [ ] Admin: create/edit/approve pairings for date+locale
- [ ] Fallback: Safe Pairing Set when today missing/invalid
- [ ] Guardrails: approved-only, join-failure -> fallback

**Done**
- 
**Blocked**
- 
**Next**
- 

## DESIGN Lane
**Plan**
- [ ] Admin UI minimal layout (only what’s needed)
- [ ] Mobile polish for Today/Detail pairing blocks

**Done**
- 
**Blocked**
- 
**Next**
- 

## OPS Lane
**Plan**
- [ ] Expand safe set inventory to target
- [ ] Daily routine draft: approve curation + pairing + verify Today + verify fallback

**Done**
- 
**Blocked**
- 
**Next**
- 

## MKT Lane
**Plan**
- [ ] Final microcopy for pairing + fallback + emotion prompt

**Done**
- 
**Blocked**
- 
**Next**
- 

## MASTER Lane
**Plan**
- [ ] Missing-today drill: remove today pairing -> fallback verified
- [ ] Ensure daily ops can be done in ≤15 minutes

**Done**
- 
**Blocked**
- 
**Next**
- 

---

# Day 5 — Emotion Logs Ship + Hardening + Week2 Gate
## DEV Lane
**Plan**
- [ ] Emotion logging UI + API + RLS verification
- [ ] “Logged today” behavior (dedupe rule applied)
- [ ] E2E QA scenarios (today pairing present/missing, email deep link, save loop)
- [ ] Minimal observability logs (delivery, today fetch, emotion save)

**Done**
- 
**Blocked**
- 
**Next**
- 

## DESIGN Lane
**Plan**
- [ ] Emotion UI: minimal + skippable + calm confirmation
- [ ] Final mobile QA checklist

**Done**
- 
**Blocked**
- 
**Next**
- 

## OPS Lane
**Plan**
- [ ] Finalize daily runbook (≤15 min)
- [ ] Spot-check 3 pairings + verify attribution compliance

**Done**
- 
**Blocked**
- 
**Next**
- 

## MKT Lane
**Plan**
- [ ] Release notes bullets + updated quiet invite copy (if needed)

**Done**
- 
**Blocked**
- 
**Next**
- 

## MASTER Lane — Final Gate (Must Pass)
- [ ] Today renders approved curation + pairing (date+locale)
- [ ] Verse text always DB-sourced; reference includes translation
- [ ] Missing today snapshot triggers safe fallback (no blank day)
- [ ] Emotion logs save + user isolation verified
- [ ] Email delivery deduped + deep link works
- [ ] Daily ops runnable in ≤15
