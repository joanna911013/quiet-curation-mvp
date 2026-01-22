# Pairing Component Spec (Today vs Detail)

## Intent
- Pairings feel discovered, not explained.
- Absence feels quiet, not broken.

## Today (Preview)
**Purpose**
- Make the presence of a pairing recognizable at a glance without becoming the hero.

**Layout**
- Compact card or inline block inside the Today flow.
- Content: verse reference line + 1-2 line verse excerpt only.
- No rationale or explanatory text on Today.

**Tone**
- Quiet, secondary emphasis; skimmable in under 3 seconds.

**Constraints**
- Do not push primary content down; keep max visual height tight (target 80-96px).
- Use Today truncation rules from `docs/design/verse_display_spec.md`.

## Detail (Expanded)
**Purpose**
- Provide supportive context for reflection without taking over the screen.

**Layout**
- Verse block first (full text).
- Rationale section below with a clear title and short body:
  - Title: "Why this pairing?" (alt copy allowed, same tone family)
  - Rationale body: 2-4 lines max; clamp at 4 lines with ellipsis.

**Tone**
- Reflective, not instructional.
- Avoid "AI explanation" voice; use human, calm phrasing.
- Avoid: “This pairing shows…”, “The reason is…”, “This verse teaches…”


**Hierarchy**
- Verse remains primary.
- Rationale is supportive and visually lighter.

## Fallback Behavior (No Pairing Available)
**Decision**
- Omit the pairing section entirely.
- No pairing record at all (and no safe fallback enabled) → omit pairing section
- Safe fallback selected (from safe set) → render normally (+ optional label if allowed)

**Rules**
- No placeholder copy.
- No error or warning tone.
- If a fallback pairing is used (safe set), render the pairing normally (label may be shown per `docs/design/verse_display_spec.md`).

## Typography and Spacing Notes
- Use verse typography and spacing from `docs/design/verse_display_spec.md`.
- Final visual hierarchy tokens: `docs/design/day4_visual_hierarchy_spec.md`.
- Add rationale title styling:
  - 13px, weight 600, line-height 1.4, color #4b4b4b.
- Spacing targets:
  - Verse -> rationale title: 14px.
  - Rationale title -> rationale body: 6px.

## Wireframe Annotations
- See `docs/design/wireframes/day3_pairing_annotations.md`.

## Supersedes
- This spec supersedes Day 2 fallback copy guidance in `docs/design/verse_display_spec.md` and in `docs/weekly/W02_EXECUTION_PLAN.md`.
