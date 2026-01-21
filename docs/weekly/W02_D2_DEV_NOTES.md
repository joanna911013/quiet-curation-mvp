# Week 2 Day 2 Dev Notes

Smoke test: PASS
- logged-in user with 0 saves sees empty state + "Go to Today" CTA.
- user with 1+ saves sees list sorted by newest saved_at first.
- clicking a saved item opens the Detail page for that pairing.
- login -> open /profile -> email visible.
- click logout -> redirected to /login.
- visit /profile after logout -> redirected to /login.
- visit /saved after logout -> redirected to /login.

Saved RLS test in quiet-curation-web/app/(app)/saved-rls-check : PASS

A) Normal save/list
B) Cross-user visibility
C) Spoof insert (new row violates row-level security)
D) Spoof delete  (deleted: 0, no cross-user delete)

pairings check test in quiet-curation-web/app/(app)/pairings-check : PASS
- userId returned and userErr = null (session OK)
- rows returned only with status = "approved"
- nonApprovedSeen = [] (no drafts leaked to non-admin)
- Verified daily snapshot visibility across multiple dates (2026-01-19 ~ 2026-01-26), locale="en"

Verse ingest summary (sample run; full 300-row run postponed):
- Input file: quiet-curation-web/scripts/data/verses_en_niv_day2.json
- Input rows: 3 (sample)
- Result: ingest test passed

Verse search check (Option C text search):
- Ran `quiet-curation-web/scripts/sql/verse_search_text.sql` and visited `/search-check`.
- Query `shepherd` -> Psalms 23:1 (score 0.0607927106320858)
- Query `rest` -> no results
- Query `anxiety` -> Philippians 4:6 (score 0.100000001490116)
