# Week 2 Day 4 Dev Notes

Admin panel (pairings) — minimal ops UI:
- List view at `/admin/pairings` with filters (date, locale, status) and sort by pairing_date desc.
- Tables used: `pairings` (list/edit/approve), `verses` (approval validation), `profiles` (admin role check).
- Validation rules for approval:
  - verse_id resolves to a verse
  - verse reference renders (canonical_ref or book/chapter/verse) and translation present
  - literature_source present
  - literature_author OR literature_title present
  - literature_text word count <= 70
  - rationale_short required; max 240 chars
- Approval gate: status set to `approved` only after validation passes; save draft does not run validation.
- Uniqueness policy (Option A): block approval if another approved pairing exists for same (pairing_date, locale).
- Set Today: sets `pairing_date` to today (Asia/Seoul) for approved pairings; blocks if another approved pairing already exists for today+locale.
- Admin role SQL:
  - `update public.profiles set role='admin' where id='<USER_ID>';`
- Status: complete (list, edit/new, approve, set-today verified).
