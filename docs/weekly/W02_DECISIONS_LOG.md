# Week 2 Decisions Log

Rules:
- Decisions only (no status updates).
- Format: Date / Decision / Why / Impact.
- If it affects schema, also patch `07_ERD_DATA_SCHEMA.md`.

---

## YYYY-MM-DD
**Decision:** Daily snapshot key = (pairing_date, locale)  
**Why:** Global Today snapshot for MVP; deterministic content for all users per day  
**Impact:** Pairings table must enforce unique(pairing_date, locale)

## YYYY-MM-DD
**Decision:** Pairings are approved-only for users  
**Why:** Avoid exposing drafts/unvalidated content  
**Impact:** RLS and queries must filter status=approved

## YYYY-MM-DD
**Decision:** No blank day via Safe Pairing Set fallback  
**Why:** Today view must always show something stable  
**Impact:** Need safe_set pool and fallback query behavior

## YYYY-MM-DD
**Decision:** Verse text must come from DB (no generation)  
**Why:** Integrity and trust; prevents hallucinations  
**Impact:** Today/Detail must join verses table

## YYYY-MM-DD
**Decision:** Emotion logs are captured in v1 but do not alter Today content  
**Why:** Keep MVP simple; enable personalization later (v2/v3)  
**Impact:** Store emotion_events; no ranking logic in v1

---

## 2026-01-19
**Decision:** emotion_events dedupe uses unique (user_id, event_date); verses and verse_embeddings are readable only to authenticated users  
**Why:** MVP allows one check-in per user per day; verse data is only needed inside the signed-in app  
**Impact:** Add unique constraint on emotion_events and enforce authenticated-only read RLS on verses/verse_embeddings

## 2026-01-19
**Decision:** RLS baseline for Week 2 tables is authenticated-only access. 
**Why:** Prevent accidental public exposure and ensure user isolation for sensitive logs.
**Impact:** 
-pairings: authenticated users can read approved rows only
- emotion_events: authenticated users can CRUD own rows only (user_id = auth.uid())
- verses / verse_embeddings: authenticated users can read (no public read)

## 2026-01-19
**Decision:** Week 2 verse ingestion scope locked to locale=en, translation=KJV, subset: Psalms 23-30; Proverbs 3; Isaiah 40; Matthew 11; John 3; Romans 8; 1 Corinthians 13; Philippians 4. Canonical book naming uses full standard names (e.g., "Psalms", "1 Corinthians") and canonical_ref format "{Book} {Chapter}:{Verse}".
**Why:** Keep Day 2 embedding run small, verifiable, and consistent for QA.
**Impact:** Ingestion, QA anchors, and search acceptance tests must use this scope and naming format.

## 2026-01-19
**Decision:** Switch Week 2 EN translation to NIV (locale=en) while keeping the same subset scope and canonical naming format. Supersedes the KJV scope decision above.
**Why:** Align translation choice across Day 2 ingestion and QA with NIV.
**Impact:** Ingestion source must be a licensed NIV text; anchors, spot-checks, and search acceptance criteria must use NIV wording.

## 2026-01-19
**Decision:**  Store `canonical_ref` without translation; display translation in UI as `"{canonical_ref} ({translation})"`.

## 2026-01-19
**Decision:** Excerpt risk threshold uses word count (> 90 words) and triggers the disclaimer when license_status is unknown or excerpt_word_count > 90.  
**Why:** Provide an objective, measurable approval gate for OPS.  
**Impact:** OPS must compute word_count via whitespace tokenization and show the disclaimer only when triggered at the bottom of the literature block.

## 2026-01-19
**Decision:** Literature excerpt length limit set to 70 words (hard cap).  
**Why:** Keep MVP snippets short and consistent with the calm, minimal reading time goal.  
**Impact:** OPS must enforce <=70 words in literature excerpts; items above the limit require trimming before approval.

## 2026-01-20
**Decision:** If the user’s locale has no approved pairings, Home falls back to the latest approved pairings across any locale.  
**Why:** Prevent empty states from blocking access to the Detail view while content is still being approved per locale.  
**Impact:** Home performs a locale-filtered query first, then retries without the locale filter when results are empty.

## 2026-01-21
**Decision:** Quiet invite cron only uses approved pairings for today; if none exist, fallback uses `FALLBACK_CURATION_ID` without erroring.  
**Why:** Prevent accidental sends of unreviewed content while keeping the daily pipeline stable.  
**Impact:** Cron pairing fetch must filter `status='approved'` and tolerate no results; manual approval happens via SQL or future admin tooling.

## 2025-01-21
**Decision:**
Email delivery remains in dry-run mode throughout Week 2; real email sending begins in Week 3.
**Why:**
To prevent accidental user emails while validating the full delivery pipeline (cron execution, deduplication, retries, content rendering).
**Impact:**
Cron jobs run end-to-end without external side effects. Switching to a real email provider is a controlled, explicit action at Week 3 kickoff.

## 2025-01-21
**Decision:**
If no approved pairing exists for Today, the pairing section is omitted entirely from the UI.
**Why:**
To preserve the “quiet” experience. Absence should feel intentional, not like an error or missing state.
**Impact:**
Users never see placeholder copy, warnings, or “no pairing” messages. The Today view remains visually stable and calm.

## 2025-01-21
**Decision:**
Today’s pairing selection is restricted to approved content only, filtered by `(pairing_date, locale)`, with deterministic selection using `created_at DESC, id DESC`.
**Why:**
To prevent draft or unreviewed content from being surfaced and to ensure reproducible behavior across environments.
**Impact:**
Operational safety is improved, and Today pairing behavior can be consistently reasoned about and debugged.

## 2025-01-21
**Decision:**
The Safe Pairing Set is seeded on Day 3 with a small set of approved pairings and expanded on Day 4.
**Why:**
To prioritize pipeline correctness and operational safety before scaling content inventory.
**Impact:**
Fallback behavior is reliable from Day 3, with capacity to scale without redesigning delivery logic.

## Template
## YYYY-MM-DD
**Decision:**  
**Why:**  
**Impact:**  
