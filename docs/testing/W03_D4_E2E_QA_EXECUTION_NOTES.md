# W03 D4 — E2E QA Execution Notes (Must Pass)
Last updated: 2026-01-29

Use this sheet to record pass/fail evidence for Day 4 "Must Pass" QA.

## Tester
- Name: Yoanna
- Environment: local 
- Build URL: 
- Date (KST): 2026-01-29

---

## Scenario 1) New user flow
Flow: `/login → / → /c/[id] → save → /saved`

- Result: PASS
- Evidence:
- Notes: 

---

## Scenario 2) Email deep link
Flow: open email → login (if needed) → correct `/c/[id]`

- Result: PASS 
- Evidence:
- Notes:
  - iOS Safari (Vercel URL): PASS (2026-02-02)
  - iOS in-app browser (Vercel URL): PASS (retest 2026-02-03)
    - Previous fail repro: Kakao in-app → open Vercel URL → enter email → open Naver Mail app → click login link → `auth_failed`
    - Recovery: open the site in Safari → request link again → open link in Safari → login success (main page visible)

---

## Scenario 3) Admin operation
Flow: create pairing → approve → set today → Today shows

- Result: PASS 
- Evidence:
- Notes:

---

## Scenario 4) Permissions / RLS
Flow: user A cannot see user B saved/emotion

- Result: PASS
- Evidence:
- Notes:

---

## Scenario 5) Data integrity
Flow: verse exists; if today pairing removed → safe fallback appears

- Result: PASS
- Evidence:
- Notes:

---

## Scenario 6) Failure behavior
Flow: simulate API fail → stable error + retry works

- Result: PASS
- Evidence:
- Notes:

---

## Day 4 Regression Sweep (Vercel)
Focus: login → Today → Detail → Saved → Emotion

**Tester:** Yoanna  
**Build URL:** https://quiet-curation-web.vercel.app  
**Date (KST):** 2026-02-05  

1) Login flow
- Result: PASS
- Notes: Vercel login succeeds.

2) Today page renders
- Result: PASS
- Notes: Today loads without blank state.

3) Detail page renders (from Today)
- Result: PASS
- Notes: Detail loads from Today link.

4) Saved list (save + view)
- Result: PASS
- Notes: Save + Saved list display works.

5) Emotion page (log + confirm)
- Result: PASS
- Notes: Emotion log succeeds; confirmation shown.
