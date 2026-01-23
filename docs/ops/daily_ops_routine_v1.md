# Daily Ops Routine (v1)
Last updated: 2026-01-23

Repeatable daily routine for Week 2 operations. This is the runbook an operator can follow end-to-end without developer intervention.

## Preconditions (max 5)
- Safe Pairing Set is seeded and tracked in `docs/ops/day3_pairing_inventory.md` (ops-marked).
- Admin access to the app (`/admin`) is working.
- Supabase SQL Editor access is available (service role or project admin).
- Vercel deployment URL is known and reachable.
- Cron auth secret and dry-run mode are available for email preview (or a known preview route).

## Daily Schedule (KST)
### Day before (prep)
- 18:00–19:00 KST: approve tomorrow’s curation + pairing, verify join integrity, and update Safe Pairing Set if needed.

### Morning of (verification)
- 08:00–08:15 KST: verify Today UI rendering, attribution formatting, and email preview + deep link.

## Step-by-step Routine (checklist)

### A) Approve tomorrow’s curation (literature)
**UI steps**
- /admin → Curations (or Pairings if curation is embedded)
- Select tomorrow’s item → verify required fields → approve

**Validation checklist (pass/fail)**
- [ ] literature_text is present and <= 70 words
- [ ] literature_author and/or literature_title present
- [ ] literature_source present (public domain or verified source)
- [ ] Tone is quiet/reflective (no guilt/marketing/AI voice)

**SQL verification (copy/paste)**
```sql
select
  id,
  pairing_date,
  locale,
  literature_text,
  literature_author,
  literature_title,
  literature_source,
  array_length(regexp_split_to_array(trim(literature_text), '\\s+'), 1) as word_count
from public.pairings
where pairing_date = 'YYYY-MM-DD'
  and locale = 'en';
```

### B) Generate/select verse pairing
**Selection rules**
- If manually curated: choose a verse_id from the NIV set and write a short rationale.
- If missing: select from the Safe Pairing Set list in `docs/ops/day3_pairing_inventory.md`.

**Guardrails (pass/fail)**
- [ ] verse_id exists in `public.verses`
- [ ] translation label present (e.g., NIV)
- [ ] attribution fields present (author/title/source)
- [ ] rationale_short is brief (2–4 lines max)

### C) Approve pairing snapshot for (date, locale)
**UI steps**
- /admin → Pairings
- Ensure only one pairing exists for (pairing_date, locale)
- Approve the row

**Uniqueness rule**
- Only one approved pairing per (pairing_date, locale). If a row already exists, update it; do not insert a second row.

**SQL verification (copy/paste)**
```sql
select
  p.id,
  p.pairing_date,
  p.locale,
  p.status,
  v.canonical_ref,
  v.translation,
  v.verse_text
from public.pairings p
join public.verses v on v.id = p.verse_id
where p.pairing_date = 'YYYY-MM-DD'
  and p.locale = 'en'
  and p.status = 'approved';
```

### D) Verify Today rendering + attribution (UI)
**Steps**
- Login → Today
- Confirm pairing block is present (or omitted only if pairing truly missing)
- Verse reference format: `{Book} {Chapter}:{Verse} ({Translation})`
- Verse text renders
- Attribution line uses em dash prefix `— ` and correct fields
- Open Detail: full verse text + rationale clamp + attribution placement

**Pass/Fail**
- [ ] Today pairing block renders correctly
- [ ] Reference format correct and translation label present
- [ ] Attribution line format matches approval gate
- [ ] Detail view renders full verse + rationale clamp

### E) Verify email preview + deep link
**Preview method (pick one)**
- Cron dry-run: call `/api/cron/quiet-invite` with Authorization header and verify summary output.
- Preview route (if provided): open email preview page and validate content.

**Pass/Fail**
- [ ] Deep link resolves: email → login (if needed) → lands on `/c/[id]`
- [ ] Snippet rules: max 2 lines, calm tone, no labels

### F) Spot-check 3 pairings (quality audit)
**Sampling**
- Choose 3 approved pairings (today + next few days).

**Checklist (pass/fail)**
- [ ] Verse correctness (verse_id exists + verse_text present)
- [ ] Translation label present (NIV)
- [ ] Attribution format correct (em dash, fields, no suffix)
- [ ] Excerpt length <= 70 words
- [ ] Tone quiet/non-coercive
- [ ] Rationale length within 2–4 lines

### G) Missing Today pairing warnings (admin)
**Checks**
- /admin dashboard warning: “Today pairing missing” (if applicable)

**Response playbook**
- If missing: approve pairing for today immediately OR set Safe Pairing Set fallback
- Re-verify Today renders and cron will not break sending

## Operators’ SQL Snippet Pack (appendix)

**1) List approved pairings for date+locale**
```sql
select id, pairing_date, locale, status
from public.pairings
where pairing_date = 'YYYY-MM-DD'
  and locale = 'en'
  and status = 'approved';
```

**2) Join-check pairings → verses (translation + verse_text present)**
```sql
select
  p.id,
  p.pairing_date,
  p.locale,
  v.canonical_ref,
  v.translation,
  v.verse_text
from public.pairings p
join public.verses v on v.id = p.verse_id
where p.pairing_date = 'YYYY-MM-DD'
  and p.locale = 'en';
```

**3) Find missing Today pairing**
```sql
select
  'missing_today_pairing' as check,
  count(*) as approved_count
from public.pairings
where pairing_date = 'YYYY-MM-DD'
  and locale = 'en'
  and status = 'approved';
```

**4) List Safe Pairing Set IDs (ops list) + approved status**
```sql
select id, pairing_date, locale, status
from public.pairings
where id in (
  -- paste Safe Pairing Set IDs from docs/ops/day3_pairing_inventory.md
  'PAIRING_ID_1',
  'PAIRING_ID_2'
)
order by pairing_date asc;
```

**5) Invite deliveries sanity (last 10 today)**
```sql
select id, user_id, delivery_date, status, last_attempt_at, retry_count
from public.invite_deliveries
where delivery_date = 'YYYY-MM-DD'
order by last_attempt_at desc
limit 10;
```

## What to do when things go wrong

**Today pairing missing**
- Approve a pairing for today or pick from Safe Pairing Set immediately.
- Capture: pairing_id, SQL output from “missing today pairing” query, and Today screenshot.

**Verse join failed / translation missing**
- Do not approve the pairing. Fix verse_id or translation field first.
- Capture: pairing_id, verse_id, join-check output.

**Email preview fails / deep link incorrect**
- Verify cron dry-run output and CRON secret; check `/login?redirect=/c/[id]` flow.
- Capture: preview URL, deep link URL, response payload/screenshot.

**Escalation**
- Log issue in `docs/weekly/W02_EXECUTION_PLAN.md` (OPS lane) and notify MASTER with artifacts above.
