# Week 2 Day 5 — E2E QA Scenarios (Must Pass)
Last updated: 2026-01-23

Goal: A repeatable QA suite that validates Week 2 readiness across user flow, admin ops, RLS, data integrity, fallback, and failure behavior.

---

## Prerequisites

### Environments
- Local: `http://localhost:3000`
- Preview/Prod: Vercel URL (use the exact deployment URL)

### Required env vars
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `EMOTION_LOGGING_ENABLED=true` (if testing emotion logging)
- `SITE_URL` (used to generate deep links in email)
- `CRON_SECRET` (for cron route if tested)

### Test accounts (fill in before running)
- Admin (profiles.role = `admin`): `{ADMIN_EMAIL}`, `{ADMIN_USER_ID}`
- User A (normal): `{USER_A_EMAIL}`, `{USER_A_ID}`
- User B (normal): `{USER_B_EMAIL}`, `{USER_B_ID}`

### Sample IDs (fill in before running)
- Approved pairing id: `{PAIRING_ID}`
- Verse id used in pairing: `{VERSE_ID}`

### Helper routes (reuse existing)
- `/whoami`: confirm current authed user id/email.
- `/saved-rls-check`: spoof save/unsave against `saved_items` (RLS check).
- `/pairings-check`: verifies non-admin can only read approved pairings.
- `/verse-check`: verifies verses are readable (auth-only).

> Notes:
> - “Today” uses KST. Use `select (now() at time zone 'Asia/Seoul')::date;` in SQL.
> - In this MVP, “curation” content is stored on `pairings` (no separate curation UI in app).

---

## Scenario 1) New User Core Flow

**Flow**
`/login` → `/` → `/c/[id]` → Save → `/saved`

**Steps**
1) Log in as User A at `/login`.
2) Confirm redirect to `/` (Today).
3) Click the pairing card to open `/c/[id]`.
4) Click the Save icon.
5) Navigate to `/saved`.
6) Click Save icon again from detail to confirm idempotency (no duplicates).

**Expected UI**
- Today loads without crash.
- Detail page renders verse + literature (no missing join).
- Save toggles ON; shows saved state.
- `/saved` shows the item once.
- Repeat save does not duplicate.

**Expected DB**
- One `saved_items` row for `(user_id, pairing_id)`.

**Verification SQL**
```sql
-- Verify the saved row exists
select * from saved_items
where user_id = '{USER_A_ID}'
  and pairing_id = '{PAIRING_ID}';

-- Ensure no duplicates
select user_id, pairing_id, count(*)
from saved_items
group by user_id, pairing_id
having count(*) > 1;
```

---

## Scenario 2) Email Deep Link Correctness

**Deep link format**
`{SITE_URL}/login?redirect=/c/{PAIRING_ID}`

**Steps**
1) Logged out: open the deep link in a fresh session.
2) Complete magic-link login.
3) Confirm redirect lands on `/c/{PAIRING_ID}`.
4) Logged in: open the same deep link and confirm it goes directly to detail.

**Expected UI**
- No redirect loop.
- If logged out, login screen appears then returns to the target detail.
- If logged in, you land on the detail page immediately.

**Expected DB**
- No DB changes required.

**Verification**
- Confirm `login?redirect=` preserved on Vercel domain.
- Deep link is generated in `renderQuietInviteEmail` as:
  - `/login?redirect=/c/{curation.id}` (curation id is the pairing id in current cron flow).

---

## Scenario 3) Admin Operation (Daily Content Mode)

**Flow**
Admin creates + approves pairing → sets it for Today (KST) → Today shows it.

**Steps**
1) Log in as Admin.
2) Open `/admin/pairings/new`.
3) Fill in: `pairing_date` (KST today), `locale`, `verse_id`, `literature_text`, optional `rationale_short`, optional `curation_id`.
4) Click **Save draft**.
5) Click **Approve**.
6) Click **Set as Today**.
7) Open `/` (Today) and verify pairing block shows.

**Expected UI**
- Non-admin user sees “Not authorized” at `/admin` and `/admin/*`.
- Admin can save + approve without manual SQL.
- Today shows the approved pairing with verse text + reference + attribution (rationale shown on detail per spec).

**Expected DB**
- Approved pairing exists for `(pairing_date, locale)`.
- `verse_id` joins to `verses`.

**Verification SQL**
```sql
-- Confirm today’s approved pairing exists
select id, pairing_date, locale, status, verse_id
from pairings
where pairing_date = (now() at time zone 'Asia/Seoul')::date
  and locale = 'en'
  and status = 'approved';

-- Ensure uniqueness by day/locale
select pairing_date, locale, count(*)
from pairings
where pairing_date = (now() at time zone 'Asia/Seoul')::date
  and status = 'approved'
group by pairing_date, locale
having count(*) > 1;
```

---

## Scenario 4) Permissions / RLS Isolation

**Flow**
User A saves + logs emotion → User B cannot see or spoof.

**Steps**
1) Log in as User A:
   - Save a pairing.
   - Log an emotion on `/emotion`.
2) Log in as User B:
   - `/saved` should not show User A’s saved item.
   - `/emotion` should show the empty form (not “Logged today”).
3) Use `/saved-rls-check` as User B:
   - Set spoof user id to User A and attempt “Spoof Save”.
   - Expect RLS error and no row created.
4) Use `/pairings-check` as User B:
   - `nonApprovedSeen` should be empty.

**Expected UI**
- User B cannot see User A data.
- Spoof Save fails (RLS enforced).

**Expected DB**
- Emotion event has `user_id = User A`.
- No new rows for User B when spoof attempt fails.

**Verification SQL**
```sql
-- Verify User A emotion event exists
select user_id, event_date, emotion_primary, memo_short
from emotion_events
where user_id = '{USER_A_ID}'
order by created_at desc
limit 5;

-- Ensure no duplicates for User A/day
select user_id, event_date, count(*)
from emotion_events
group by user_id, event_date
having count(*) > 1;
```

---

## Scenario 5) Data & RAG Integrity

**Checks**
- Verse shown on Today/Detail exists in `verses` and joins correctly.
- If no approved pairing for today+locale → safe fallback renders.

**Safe fallback definition**
- If no approved pairing for `(pairing_date, locale)`, select from **safe set**:
  - `status = 'approved' AND is_safe_set = true`
  - ordered by `created_at DESC, id DESC` (most recent)

**Steps**
1) On `/`, click pairing → detail page.
2) Confirm verse reference + text visible.
3) Test fallback:
   - Temporarily unapprove today’s pairing or set its date to a different day.
   - Refresh `/` → safe set pairing should render (no blank day).

**Expected UI**
- Verse block renders with reference + full text.
- Safe fallback renders normally (no apology/blank state).

**Verification SQL**
```sql
-- Join check: pairing -> verses
select p.id as pairing_id, p.pairing_date, p.locale, p.verse_id, v.id as verse_join
from pairings p
left join verses v on v.id = p.verse_id
where p.status = 'approved'
  and p.pairing_date = (now() at time zone 'Asia/Seoul')::date
  and p.locale = 'en';

-- Safe set candidate
select id, pairing_date, status, is_safe_set
from pairings
where status = 'approved' and is_safe_set = true
order by created_at desc, id desc
limit 3;
```

---

## Scenario 6) Failure Behavior (Hardening)

**Targets**
- Today fetch
- Detail fetch
- Save action
- Emotion log write

**How to simulate locally**
- Temporarily set an invalid `NEXT_PUBLIC_SUPABASE_URL` or `NEXT_PUBLIC_SUPABASE_ANON_KEY`.
- Or disable network in browser DevTools.

**Steps & Expected UI**
1) **Today fetch failure**
   - Open `/` while Supabase is unreachable.
   - Expected: calm error state (“Unable to load today’s pairing.”).
   - Recovery: restore env/network and refresh.

2) **Detail fetch failure**
   - Open `/c/{PAIRING_ID}` while Supabase is unreachable.
   - Expected: “Unable to load reading.”
   - Recovery: restore env/network and refresh.

3) **Save action failure**
   - From detail, toggle Save while Supabase is unreachable.
   - Expected: save state reverts + small error text “Unable to update saved state.”
   - No duplicate rows after retry.

4) **Emotion log write failure**
   - On `/emotion`, submit while Supabase is unreachable.
   - Expected: inline error message; no “Logged today” state.

**Expected DB**
- No partial writes.
- No duplicate rows after retry (idempotency + unique constraints).

**Verification SQL**
```sql
-- Confirm no extra saved_items rows after failure/retry
select user_id, pairing_id, count(*)
from saved_items
group by user_id, pairing_id
having count(*) > 1;

-- Confirm no extra emotion_events rows after failure/retry
select user_id, event_date, count(*)
from emotion_events
group by user_id, event_date
having count(*) > 1;
```

---

## E2E Rehearsal (30-minute run order)
1) Scenario 1 (User A flow).
2) Scenario 2 (Deep link).
3) Scenario 3 (Admin).
4) Scenario 4 (RLS isolation).
5) Scenario 5 (Data + fallback).
6) Scenario 6 (Failure behaviors).

---

## Notes
- SQL Editor runs with elevated privileges and may bypass RLS; use UI + helper routes for RLS validation.
- Always use KST “today” for pairing checks.
