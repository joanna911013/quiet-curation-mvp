# W03 D4 — Email Template QA Checklist (Mobile Clients)
Last updated: 2026-01-29

Goal: confirm email invite renders clearly on mobile mail clients (spacing, readability, safe links).

## 1) Test Clients
- iOS Mail (native)
- Gmail iOS
- Android Gmail
- (Optional) Outlook iOS

## 2) Test Data
- Subject: default EN + KR
- Long pairing text (2-line snippet)
- Long author/title attribution
- Link to detail (/c/[id])

## 3) Layout + Readability Checks
Pass/Fail for each client:
- Subject line is readable (not truncated badly).
- Preheader (if present) is visible and not noisy.
- Body text line length is comfortable (no horizontal scroll).
- Line breaks preserved where intended.
- CTA/link is tappable and clearly visible.
- Attribution line is legible and not wrapping awkwardly.
- Footer/legal text is readable but not dominant.

## 4) Link Behavior
- Link opens correct domain.
- If login required → redirect works after auth.
- No mixed-content warnings.

## 5) Capture
- Record device + client version.
- Screenshot any layout break.

---

## Execution Log (fill in)
**Tester:**  
**Date (KST):**  
**Build URL:**  

### iOS Mail
- Result: 
- Notes:

### Gmail iOS
- Result:
- Notes:

### Android Gmail
- Result:
- Notes:

### (Optional) Outlook iOS
- Result:
- Notes:

