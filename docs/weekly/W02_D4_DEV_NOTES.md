# Week 2 Day 4 Dev Notes

Admin panel (pairings) — minimal ops UI:
- Tables used: `pairings` (list/edit/approve), `verses` (approval validation), `profiles` (admin role check).
- Validation rules for approval:
  - verse_id resolves to a verse
  - verse reference renders (canonical_ref or book/chapter/verse) and translation present
  - literature_source present
  - literature_author OR literature_title present
  - literature_text word count <= 70
- Approval gate: status set to `approved` only after validation passes; save draft does not run validation.
- Set Today: sets `pairing_date` to today (Asia/Seoul) for approved pairings; blocks if another approved pairing already exists for today+locale.
- Admin role SQL:
  - `update public.profiles set role='admin' where id='<USER_ID>';`
