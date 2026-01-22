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
- Operator check: read `literature_text` and `rationale_short` for calm, non-coercive tone.

## Bulk Verification (safe set)
```sql
select
  p.id,
  p.pairing_date,
  p.locale,
  p.status,
  v.canonical_ref,
  v.translation,
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
  'f5218f7e-62f1-41cb-87d9-03243b859c4a'
)
order by p.pairing_date asc;
```
