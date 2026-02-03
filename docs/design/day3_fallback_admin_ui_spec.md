# Day 3 Design Spec — Fallback + Admin Warning (Quiet UI)

## Goal
Keep all fallback and admin warning states calm, inline, and non-alarmist.

---

## A) Fallback UI (User-facing)
Applies to Today and Detail screens.

Rules:
- If no pairing exists: omit the pairing section entirely.
- If Safe Set fallback is used: render the pairing normally.
- Do not show warning banners, error copy, or alert icons.
- Optional label only if already approved (per `docs/design/verse_display_spec.md`).

Visual tone:
- Same layout and typography as normal pairing.
- No color shifts that imply an error state.

---

## B) Admin Warning Styling (Admin Dashboard)
Use an inline, quiet indicator for "Today pairing missing".

Layout:
- Single-row inline panel with text + link.
- No icon, no exclamation, no alert tone.

Typography:
- Text size: 13–14px.
- Weight: 500 for the label, 600 for the link only.

Color + surface:
- Text: neutral-600 (or #4b4b4b).
- Border: 1px solid rgba(0,0,0,0.08).
- Background: #fafafa (or white with no shadow).
- Avoid amber/red backgrounds.

Spacing:
- Padding: 10–12px vertical, 14–16px horizontal.
- Gap between label and link: 12–16px.

Interaction:
- Link uses subtle underline; no button styles.
- Hover/press should only change text opacity or underline weight.

---

## Implementation Notes (DEV)
- Replace any amber/alert styling with neutral inline styling.
- Keep the warning box visually lighter than primary admin actions.
- The warning should not dominate the admin list.

References:
- `docs/design/day4_visual_hierarchy_spec.md`
- `docs/design/verse_display_spec.md`
