# Day 3 Ops Inventory (Pairings + Safe Set)

Locale: en (translation label must be present; current data uses NIV)

## Approved Pairings (ready for delivery)
| id | pairing_date | locale | status |
| --- | --- | --- | --- |
| 71ece5ba-41ed-45a0-91fb-c7427a2bf45a | 2026-01-20 | en | approved |
| f59c8e2e-9e4d-4ff9-bb35-cb8ca5537f8a | 2026-01-21 | en | approved |
| a7a3ee42-c9a4-4194-8c85-bba73a1d5422 | 2026-01-22 | en | approved |
| 24a78af2-080c-43d1-908d-490d7229e059 | 2026-01-23 | en | approved |
| f5218f7e-62f1-41cb-87d9-03243b859c4a | 2026-01-24 | en | approved |
| d3d9d366-b20e-481c-890f-d7bddcde6fd7 | 2026-01-27 | en | approved |
| e8a3b362-be96-40c9-baa0-70a63eefe15a | 2026-01-28 | en | approved |
| e1ecf8e6-a2b0-4e3c-9988-412d81db4160 | 2026-01-29 | en | approved |
| e8c036ed-78f9-4bba-a9a2-3416046ed125 | 2026-01-31 | en | approved |
| 6906defd-5011-45d1-a89a-b1cc61a87b58 | 2026-02-01 | en | approved |

## Safe Pairing Set (seed, Day 3)
Use these as fallback when Today pairing is missing.
Note: Safe Pairing Set items must always be approved and locale-matched.


| id | pairing_date | locale | status |
| --- | --- | --- | --- |
| 71ece5ba-41ed-45a0-91fb-c7427a2bf45a | 2026-01-20 | en | approved |
| f59c8e2e-9e4d-4ff9-bb35-cb8ca5537f8a | 2026-01-21 | en | approved |
| a7a3ee42-c9a4-4194-8c85-bba73a1d5422 | 2026-01-22 | en | approved |
| 24a78af2-080c-43d1-908d-490d7229e059 | 2026-01-23 | en | approved |
| f5218f7e-62f1-41cb-87d9-03243b859c4a | 2026-01-24 | en | approved |

## Safe Pairing Set (expanded, Day 4)
Target: 20 total safe items (acceptable today: >=10).

| id | pairing_date | locale | status | safe_set? |
| --- | --- | --- | --- | --- |
| 71ece5ba-41ed-45a0-91fb-c7427a2bf45a | 2026-01-20 | en | approved | yes (ops) |
| f59c8e2e-9e4d-4ff9-bb35-cb8ca5537f8a | 2026-01-21 | en | approved | yes (ops) |
| a7a3ee42-c9a4-4194-8c85-bba73a1d5422 | 2026-01-22 | en | approved | yes (ops) |
| 24a78af2-080c-43d1-908d-490d7229e059 | 2026-01-23 | en | approved | yes (ops) |
| f5218f7e-62f1-41cb-87d9-03243b859c4a | 2026-01-24 | en | approved | yes (ops) |
| d3d9d366-b20e-481c-890f-d7bddcde6fd7 | 2026-01-27 | en | approved | yes (ops) |
| e8a3b362-be96-40c9-baa0-70a63eefe15a | 2026-01-28 | en | approved | yes (ops) |
| e1ecf8e6-a2b0-4e3c-9988-412d81db4160 | 2026-01-29 | en | approved | yes (ops) |
| e8c036ed-78f9-4bba-a9a2-3416046ed125 | 2026-01-31 | en | approved | yes (ops) |
| 6906defd-5011-45d1-a89a-b1cc61a87b58 | 2026-02-01 | en | approved | yes (ops) |

Total: 10 / 20. Gap: 10 remaining.
Plan: approve 5 more public-domain pairings tomorrow and replace any paraphrase-only entries before adding them to the safe set.

## Approval Checklist (must pass all)
1) Verse exists in DB (queryable by ref)
```sql
select p.id, p.pairing_date, p.locale, v.id as verse_id
from public.pairings p
join public.verses v on v.id = p.verse_id
where p.id = 'PAIRING_ID';
```

2) Verse reference includes translation/version label (e.g., NIV)
```sql
select p.id, v.canonical_ref, v.translation
from public.pairings p
join public.verses v on v.id = p.verse_id
where p.id = 'PAIRING_ID';
```
Confirm UI renders `"{canonical_ref} ({translation})"` per decision log.

3) Literature citation line present (at least author or title) and excerpt <= 70 words

```sql
select
  id,
  literature_author,
  literature_title,
  literature_source,
  array_length(regexp_split_to_array(trim(literature_text), '\\s+'), 1) as word_count
from public.pairings
where id = 'PAIRING_ID';
```

4) Tone passes constraints (quiet/reflective; no preachy/marketing/AI tone)
- Operator check: read `literature_text` and `rationale` for calm, non-coercive tone.

## SQL (Day 4)
1) List candidate approved pairings (by locale + status)
```sql
select
  id,
  pairing_date,
  locale,
  status,
  verse_id,
  literature_author,
  literature_title,
  literature_source
from public.pairings
where locale = 'en'
  and status = 'approved'
order by pairing_date asc;
```

2) Bulk verify safe set items (verse join + attribution + word counts)
```sql
select
  p.id,
  p.pairing_date,
  p.locale,
  p.status,
  v.canonical_ref,
  v.translation,
  v.verse_text,
  p.literature_author,
  p.literature_title,
  p.literature_source,
  array_length(regexp_split_to_array(trim(p.literature_text), '\\s+'), 1) as word_count
from public.pairings p
join public.verses v on v.id = p.verse_id
where p.id in (
  '71ece5ba-41ed-45a0-91fb-c7427a2bf45a',
  'f59c8e2e-9e4d-4ff9-bb35-cb8ca5537f8a',
  'a7a3ee42-c9a4-4194-8c85-bba73a1d5422',
  '24a78af2-080c-43d1-908d-490d7229e059',
  'f5218f7e-62f1-41cb-87d9-03243b859c4a',
  'd3d9d366-b20e-481c-890f-d7bddcde6fd7',
  'e8a3b362-be96-40c9-baa0-70a63eefe15a',
  'e1ecf8e6-a2b0-4e3c-9988-412d81db4160',
  'e8c036ed-78f9-4bba-a9a2-3416046ed125',
  '6906defd-5011-45d1-a89a-b1cc61a87b58'
)
order by p.pairing_date asc;
```

## Daily Review (Day 4)
Checklist (repeatable):
1) Verse correctness
   - verse_id exists, verse_text not empty
   - canonical_ref matches book/chapter/verse
   - translation label present (e.g., NIV)
2) Attribution correctness (approval gate)
   - literature attribution line uses em dash prefix "— "
   - author/title/source present as required
   - no extra labels/suffixes
3) Tone guardrails
   - quiet/reflective, not salesy or moralizing
   - no urgency/guilt language
   - rationale is present

Today sample (3):
| pairing_id | pairing_date | verse correctness | attribution formatting | tone guardrails | rationale length |
| --- | --- | --- | --- | --- | --- |
| a7a3ee42-c9a4-4194-8c85-bba73a1d5422 | 2026-01-22 | pass | pass | pass | pass |
| d3d9d366-b20e-481c-890f-d7bddcde6fd7 | 2026-01-27 | pass | pass | pass | pass |
| e1ecf8e6-a2b0-4e3c-9988-412d81db4160 | 2026-01-29 | pass | pass | pass | pass |
