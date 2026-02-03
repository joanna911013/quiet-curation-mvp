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
  - iOS in-app browser (Vercel URL): FAIL
    - Repro: Kakao in-app → open Vercel URL → enter email → open Naver Mail app → click login link → `auth_failed`

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
