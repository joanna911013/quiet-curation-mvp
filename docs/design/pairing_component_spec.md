# Pairing Component Spec (Today vs Detail)

## Intent
- Pairings feel discovered, not explained.
- Absence feels quiet, not broken.

## Today (Main)
**Purpose**
- Present the day’s literature first, then the verse, and quietly invite the reader to the rationale on Detail.

**Layout**
- Inline block inside the Today flow (no banner treatment).
- Content order:
  1) Literature block (full text, preserve line breaks).
  2) Verse block (reference line + full verse text).
  3) Quiet CTA row (ghost button): EN “Click to see explanations” / KR “연결고리 보려면 클릭”.
- No rationale text on Today.

**Tone**
- Quiet, secondary emphasis; calm reading rhythm without callouts.

**Constraints**
- Two distinct blocks inside one card; each block has subtle border/background.
- Literature and verse use same font size; distinguish by color (literature slightly lighter).
- No truncation for literature or verse on Today; reference line remains single-line ellipsis.

## Detail (Expanded)
**Purpose**
- Provide supportive context for reflection without taking over the screen.

**Layout**
- Literature section first (title/meta/text).
- Divider line between literature and verse (no verse card container).
- Verse section (reference + full text) directly below literature.
- Explanation/rationale blocks remain as-is below verse (no content/label changes).

**Tone**
- Reflective, not instructional.
- Avoid "AI explanation" voice; use human, calm phrasing.
- Avoid: “This pairing shows…”, “The reason is…”, “This verse teaches…”


**Hierarchy**
- Literature + verse are primary (equal weight).
- Rationale remains supportive and visually lighter.

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
