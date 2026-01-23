# Day 5 Emotion UI Polish

## A) Confirmation State (Lightweight)
- After save, show a subtle inline confirmation: "Logged for today".
- Placement: directly under the emotion chips grid OR just below the primary CTA (preferred if CTA is near bottom).
- Duration: persists until navigation or state change; no auto-dismiss animation.
- Styling: 12-13px, weight 500, color #6b6b6b; no banner, no border, no icon.

## B) Interaction States
- Primary emotion required:
  - Selected chip should be clear but calm (slight tint + border; avoid saturated fill).
  - Unselected chips remain neutral.
- Memo optional:
  - Placeholder copy: "Optional memo".
  - Length cap guidance: 160 chars max (counter optional; if shown, 12px neutral text).
- Skip behavior:
  - Default decision: "Skip for now" does not write an emotion event.
  - If product later requires a skipped flag, show a quiet inline note: "Skipped for today" (same styling as confirmation).
  - No judgmental copy.

## C) Error State (Save Failure)
- Use minimal inline error near the CTA:
  - Copy: "Unable to save right now." + "Try again" action.
- Styling: small neutral text (12-13px), avoid red alert blocks; use a subtle link-style retry.

## D) Copy Keys (EN/KR placeholders)
- Logged for today: EN "Logged for today" / KR "오늘 기록됨"
- Save: EN "Save" / KR "저장"
- Optional memo: EN "Optional memo" / KR "메모(선택)"
- Skip for now: EN "Skip for now" / KR "지금은 건너뛰기"
- Try again: EN "Try again" / KR "다시 시도"

## Notes
- Keep all copy gentle and non-urgent; avoid exclamation marks.
- No warning icons or alert-style backgrounds in the emotion flow.
