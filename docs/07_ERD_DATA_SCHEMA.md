# ERD + Data Schema

Status: synced to `quiet-curation-dev` via Supabase (2026-01-20).

Sources:
- Supabase `quiet-curation-dev` schema (public/auth/storage)
- docs/agents/PROJECT_CONTEXT.md
- docs/ops/content_constraints.md
- docs/ops/emotion_taxonomy.md
- docs/ops/llm_curation_prompts.md
- docs/design/scope.md

---

## Entities (Current in quiet-curation-dev)

### profiles (public.profiles)
Minimal profile row per auth user.

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk, fk -> auth.users.id | required |
| created_at | timestamptz | not null, default now() | |
| role | text | not null, default 'user' | |

Constraints:
- PK on `id`
- FK `id` -> `auth.users(id)` on delete cascade

### verses (public.verses)
Canonical verse text with optional embedding.

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk, default gen_random_uuid() | |
| translation | text | not null | e.g., "KJV", "WEB", "KRV" |
| book | text | not null | |
| chapter | int | not null, check chapter > 0 | |
| verse | int | not null, check verse > 0 | |
| text | text | not null | verse body |
| embedding | vector | nullable | inline embedding column |
| created_at | timestamptz | not null, default now() | |
| locale | text | not null, default 'en' | "en" or "ko" |
| canonical_ref | text | nullable | e.g., "Psalm 30:5" |
| verse_text | text | nullable | |

Constraints:
- PK on `id`
- UNIQUE (`translation`, `book`, `chapter`, `verse`)
- CHECK `chapter > 0`, CHECK `verse > 0`

### verse_embeddings (public.verse_embeddings)
Dedicated embedding records for verses.

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk, default gen_random_uuid() | |
| verse_id | uuid | fk -> verses.id | required |
| embedding | vector | nullable | pgvector |
| model | text | not null, default 'text-embedding-3-small' | |
| dims | int | not null, default 1536 | |
| created_at | timestamptz | not null, default now() | |

Constraints:
- PK on `id`
- FK `verse_id` -> `verses(id)` on delete cascade

### pairings (public.pairings)
Daily pairing for a locale.

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk, default gen_random_uuid() | |
| pairing_date | date | not null | |
| locale | text | not null, check locale in ('ko','en') | |
| verse_id | uuid | fk -> verses.id | required |
| literature_text | text | not null | |
| literature_source | text | nullable | |
| literature_author | text | nullable | |
| literature_work | text | nullable | |
| quality_score | real | not null, default 0, check 0<=quality_score<=1 | |
| model_version | text | nullable | |
| created_at | timestamptz | not null, default now() | |
| status | text | not null, default 'draft', check status in ('draft','approved') | |
| curation_id | uuid | nullable | reserved; not enforced to items | |
| rationale_short | text | not null, default '' | short rationale |
| literature_title | text | nullable | |
| literature_url | text | nullable | |

Constraints:
- PK on `id`
- UNIQUE (`pairing_date`, `locale`)
- FK `verse_id` -> `verses(id)` (delete restrict)
- CHECK locale in ('ko','en')
- CHECK 0 <= quality_score <= 1
- CHECK status in ('draft','approved')

### emotion_events (public.emotion_events)
User emotion check-in per pairing/day.

| column | type | constraints | notes |
| --- | --- | --- | --- |
| id | uuid | pk, default gen_random_uuid() | |
| user_id | uuid | fk -> auth.users.id | required |
| pairing_id | uuid | fk -> pairings.id | required |
| emotion_primary | text | not null | emotion key |
| emotion_secondary | text[] | nullable | secondary keys |
| memo_short | text | nullable | |
| memo_long | text | nullable | |
| created_at | timestamptz | not null, default now() | |
| updated_at | timestamptz | not null, default now() | |
| event_date | date | nullable | |
| curation_id | uuid | nullable | reserved; not enforced to items |

Constraints:
- PK on `id`
- UNIQUE (`user_id`, `pairing_id`)
- FK `user_id` -> `auth.users(id)` on delete cascade
- FK `pairing_id` -> `pairings(id)` (mix of CASCADE/SET NULL upstream)

### saved_items (public.saved_items)
Per-user bookmark of pairings.

| column | type | constraints | notes |
| --- | --- | --- | --- |
| user_id | uuid | pk, fk -> auth.users.id | |
| pairing_id | uuid | pk, fk -> pairings.id | |
| created_at | timestamptz | not null, default now() | |

Constraints:
- PK on (`user_id`, `pairing_id`)
- FK `user_id` -> `auth.users(id)` on delete cascade
- FK `pairing_id` -> `pairings(id)` on delete cascade

---

## Relationships (High Level)
- profiles.id -> auth.users.id
- pairings.verse_id -> verses.id
- verse_embeddings.verse_id -> verses.id
- emotion_events.user_id -> auth.users.id
- emotion_events.pairing_id -> pairings.id
- saved_items.user_id -> auth.users.id
- saved_items.pairing_id -> pairings.id

---

## Value Sets
- locale: "en", "ko"
- emotion_key (app taxonomy): peace, anxiety, weariness, loneliness, hope, gratitude, grief, confusion, joy

---

## RLS Notes (current)
- RLS enabled on all listed public tables; anything not covered by a policy is denied.
- profiles (roles: public -> anon+auth):
  - SELECT `id = auth.uid()`
  - UPDATE `id = auth.uid()`
- pairings (roles: authenticated):
  - SELECT `status = 'approved'`
- emotion_events (roles: authenticated):
  - SELECT `user_id = auth.uid()`
  - INSERT with_check `user_id = auth.uid()`
  - UPDATE where `user_id = auth.uid()` with_check `user_id = auth.uid()`
  - DELETE where `user_id = auth.uid()`
- saved_items (roles: public -> anon+auth):
  - SELECT `auth.uid() = user_id`
  - INSERT with_check `auth.uid() = user_id`
  - DELETE where `auth.uid() = user_id`
- verses (roles: authenticated):
  - SELECT all rows (no row filter)
- verse_embeddings (roles: authenticated):
  - SELECT all rows (no row filter)

---

## Gaps vs earlier design
- Tables not present in quiet-curation-dev: `items`, `collections`, `collection_items`, dedicated `saved_items` for items (current saved_items bookmarks pairings instead).
- `curation_id` fields exist on pairings/emotion_events but no referenced `items` table yet.
