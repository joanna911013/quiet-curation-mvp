# Verse Display Spec (Today vs Detail)

## Scope
- Screens: Today (/) and Detail (/c/[id]).
- Verse reference format is fixed: "{Book} {Chapter}:{Verse} ({Translation})".
- Verse text must be DB-sourced only (no generation).

## Global Rules
- Reference line is always shown and always single-line with ellipsis on overflow.
- Today uses two inner blocks (literature + verse). Detail uses an inline verse section separated by a divider line.
- Use translation label from DB. If translation label is missing, do not render the verse block (treat as verse missing state).


## Today (Main)
- Two distinct blocks inside the same card:
  - Literature block first (full text, preserve line breaks).
  - Verse block second (reference line + full verse text, no truncation).
- Each block uses a subtle border/background to distinguish sections.
- Rationale is not shown on Today.
- CTA row (ghost button): EN "Click to see explanations" / KR "연결고리 보려면 클릭" (opens Detail).
- Tap target: entire pairing card opens Detail.

## Detail
- Order: literature title/meta/text -> divider line -> verse reference + verse text.
- Divider line: 1px neutral line between literature and verse (no verse card).
- Reference line: always visible, single line.
- Verse text: full text, no truncation; preserve line breaks (pre-line or paragraph split).
- Explanation/rationale blocks remain unchanged in Detail UI:
  - Literature explanation block (if present) titled "About the literature".
  - Rationale block (if present) titled "Explanations".
- Attribution line: shown under rationale (or under verse if no rationale); prefix with "— " and append year if provided.
- Missing states:
  - Verse missing: show "Verse unavailable right now." + "Pull to refresh or try again." (1-2 lines total).
  - Rationale missing: hide rationale section entirely.

## Typography and Spacing (Mobile-First)
- Literature text:
  - Today: 17px, weight 400, line-height 1.6, color #3f3f3f.
  - Detail: 16px (1rem), weight 400, line-height 1.8, color #1f1f1f.
- Reference line: 12px, weight 600, line-height 1.4, color #6b6b6b.
- Verse text: 17px, weight 500, line-height 1.6, color #111111; paragraph spacing 8px.
- Rationale title: 13px, weight 600, line-height 1.4, color #4b4b4b.
- Rationale body: 14px, weight 400, line-height 1.5, color #5c5c5c; no italics.
- Attribution line: 12px, weight 500, line-height 1.4, color #7a7a7a; prefix with "— ".
- CTA row: ghost button, 14px, weight 600, line-height 1.4, color #374151; subtle border.
- Spacing:
  - Literature block -> verse block gap: 16px.
  - Reference -> verse gap: 8px.
  - Verse -> rationale title gap: 14px.
  - Rationale title -> rationale body gap: 6px.
  - Rationale body -> attribution gap: 8px.
  - Verse block -> CTA row gap: 16px.
  - Verse block padding: 16px.
  - Verse block margin to next block: 16px.

## Labels (if present)
- Fallback label text: "Alternate pairing"; show only when fallback pairing is used.
- Approved-only label text: "Approved" (admin/debug only; do not show to end users).
- Placement: above reference line, left-aligned inside the verse block.
- Visual weight: 10px, uppercase, letter-spacing 0.12em, color #9a9a9a; no pill.

## States
- Loading Today: skeleton with reference line + 2 verse lines.
- Loading Detail: skeleton with reference line + 3 verse lines + 2 rationale lines.
- No pairing available: omit pairing section entirely; no placeholder text.
- Error: use screen-level error state; do not show pairing-level error copy.

## DEV Implementation Checklist
- Today: literature block first (full), verse block below (full), CTA ghost button row at bottom; hide rationale.
- Detail shows full verse text; rationale heading "Why this pairing?" and full rationale text; hide rationale if missing.
- Add label row handling (fallback + approved-only) per spec.
- Omit pairing section entirely when no pairing is available (no placeholder text).
- Apply typography + spacing tokens per spec.

## References
- Visual hierarchy tokens: `docs/design/day4_visual_hierarchy_spec.md`.
- Source formatting gate: `docs/ops/source_formatting_approval_gate.md`.
