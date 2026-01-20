# ERD + Data Schema (MVP v1)

Status: inferred from current docs and UI flows; no local SQL/migrations found.

Sources:
- docs/agents/PROJECT_CONTEXT.md
- docs/ops/content_constraints.md
- docs/ops/emotion_taxonomy.md
- docs/ops/llm_curation_prompts.md
- docs/design/scope.md

---

## Entities (Core)

### profiles (auth.users extension)
Minimal profile data that mirrors auth.users.

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk, fk -> auth.users.id | required |
| created_at | timestamptz | not null, default now() | |
| role | text | not null, default 'user' | |

### items (curation unit, locale-specific)
Single curated pair (literature + scripture) for a locale.

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk | |
| owner_id | uuid | fk -> profiles.id | required |
| locale | text | not null | "en" or "ko" |
| date_key | date | nullable | YYYY-MM-DD (optional) |
| theme | text | nullable | optional card title / theme |
| title | text | nullable | optional explicit title |
| preview | text | nullable | optional preview for list cards |
| literature_text | text | not null | 2-3 sentences max |
| literature_author | text | not null | |
| literature_work | text | nullable | |
| scripture_reference | text | not null | e.g., "Psalm 30:5" |
| scripture_text | text | not null | exact verse |
| scripture_translation | text | nullable | e.g., "KJV", "WEB", "KRV" |
| emotion_suggestions | text[] | nullable | emotion keys |
| source_url_lit | text | nullable | |
| source_url_bible | text | nullable | |
| visibility | text | default "private" | "private" or "public" |
| curation_meta | jsonb | nullable | optional LLM output / QA flags |
| created_at | timestamptz | default now() | |
| updated_at | timestamptz | default now() | |

### collections
User-owned groupings of items (optional in MVP but listed as core object).

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk | |
| owner_id | uuid | fk -> profiles.id | required |
| title | text | not null | |
| description | text | nullable | |
| visibility | text | default "private" | "private" or "public" |
| created_at | timestamptz | default now() | |
| updated_at | timestamptz | default now() | |

### collection_items
Mapping table for collections with explicit ordering.

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk | |
| collection_id | uuid | fk -> collections.id | required |
| item_id | uuid | fk -> items.id | required |
| position | int | nullable | order within collection |
| created_at | timestamptz | default now() | |

Constraints:
- unique (collection_id, item_id)

---

## Entities (Supporting / Inferred from UI)

### saved_items (if not modeled as a default collection)
Per-user saved/bookmark state.

| column | type | constraints | notes |
| --- | --- | --- | --- |
| user_id | uuid | pk, fk -> profiles.id | |
| item_id | uuid | pk, fk -> items.id | |
| created_at | timestamptz | default now() | |

### emotion_events (current table)
Stores emotion selection (and optional memo) after reading.

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk | |
| user_id | uuid | fk -> profiles.id | required |
| pairing_id | uuid | fk -> pairings.id | required |
| emotion_primary | text | not null | primary emotion key |
| emotion_secondary | text[] | nullable | secondary emotion keys |
| memo_short | text | nullable | |
| memo_long | text | nullable | |
| created_at | timestamptz | not null, default now() | |
| updated_at | timestamptz | not null, default now() | |
| event_date | date | nullable | |
| curation_id | uuid | fk -> items.id | nullable |

---

## Relationships (High Level)
- profiles.id -> auth.users.id
- items.owner_id -> profiles.id
- collections.owner_id -> profiles.id
- collection_items.collection_id -> collections.id
- collection_items.item_id -> items.id
- saved_items.user_id -> profiles.id
- saved_items.item_id -> items.id
- emotion_events.user_id -> profiles.id
- emotion_events.pairing_id -> pairings.id
- emotion_events.curation_id -> items.id

---

## Value Sets
- locale: "en", "ko"
- visibility: "private", "public"
- emotion_key:
  - peace
  - anxiety
  - weariness
  - loneliness
  - hope
  - gratitude
  - grief
  - confusion
  - joy

---

## RLS Notes (from PROJECT_CONTEXT)
- Enable RLS on all user tables.
- Owner can CRUD their own rows.
- Public can read only rows with visibility = "public".
- Mapping tables must not bypass privacy via joins.
- RLS Summary (Week 2): pairings = authenticated SELECT where status='approved'; emotion_events = authenticated CRUD where user_id=auth.uid(); verses & verse_embeddings = authenticated SELECT (no public access).

---

## Open Questions / TBD
- Is "Saved" represented as a default collection or a dedicated saved_items table?
- Are title/preview stored or derived at read time?
- Do we persist LLM quality_checks and matching_rationale, or keep them in curation_meta only?
- Do items exist per-user (owner_id) or can there be global items curated by an admin account?

---

## Week 2 Patch (2026-01-19)
Adds Week 2 data tables for Today pairing and emotion check-ins. Use emotion_events for check-ins going forward.

### verses
Canonical verse records per locale/translation.

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk | |
| translation | text | not null | e.g., "KJV", "WEB", "KRV" |
| book | text | not null | |
| chapter | int | not null | |
| verse | int | not null | |
| text | text | not null | verse body |
| embedding | vector | nullable | |
| created_at | timestamptz | not null, default now() | |
| locale | text | not null, default 'en' | "en" or "ko" |
| canonical_ref | text | nullable | e.g., "Psalm 30:5" |
| verse_text | text | nullable | |

### verse_embeddings
Vector embeddings for verses (pgvector).

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk | |
| verse_id | uuid | fk -> verses.id | required |
| embedding | vector | nullable | pgvector |
| model | text | not null, default 'text-embedding-3-small' | |
| dims | int | not null, default 1536 | |
| created_at | timestamptz | not null, default now() | |

Indexes:
- verse_embeddings_embedding_idx on verse_embeddings using ivfflat (embedding vector_cosine_ops)

### pairings (daily snapshot)
Daily pairing per locale.

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk | |
| pairing_date | date | not null | |
| locale | text | not null | "en" or "ko" |
| verse_id | uuid | fk -> verses.id | required |
| literature_text | text | not null | |
| literature_source | text | nullable | |
| literature_author | text | nullable | |
| literature_work | text | nullable | |
| quality_score | real | not null, default 0 | |
| model_version | text | nullable | |
| created_at | timestamptz | not null, default now() | |
| status | text | not null, default 'draft' | "draft" or "approved" |
| curation_id | uuid | fk -> items.id | nullable |
| rationale_short | text | not null, default '' | short rationale |
| literature_title | text | nullable | |
| literature_url | text | nullable | |

Constraints:
- unique (pairing_date, locale)
- status in ("draft", "approved")

Indexes:
- pairings_pairing_date_idx on pairings(pairing_date)
- pairings_locale_idx on pairings(locale)

### emotion_events
User emotion check-in (one per day for MVP).

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk | |
| user_id | uuid | fk -> profiles.id | required |
| pairing_id | uuid | fk -> pairings.id | required |
| emotion_primary | text | not null | |
| emotion_secondary | text[] | nullable | |
| memo_short | text | nullable | |
| memo_long | text | nullable | |
| created_at | timestamptz | not null, default now() | |
| updated_at | timestamptz | not null, default now() | |
| event_date | date | nullable | |
| curation_id | uuid | fk -> items.id | nullable |

Constraints:
- unique (user_id, event_date)
