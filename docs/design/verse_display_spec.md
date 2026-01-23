# Verse Display Spec (Today vs Detail)

## Scope
- Screens: Today (/) and Detail (/c/[id]).
- Verse reference format is fixed: "{Book} {Chapter}:{Verse} ({Translation})".
- Verse text must be DB-sourced only (no generation).

## Global Rules
- Reference line is always shown and always single-line with ellipsis on overflow.
- Use the same verse block container on Today and Detail; only content changes.
- Use translation label from DB. If translation label is missing, do not render the verse block (treat as verse missing state).


## Today (Preview)
- Show reference line + verse text preview; rationale is not shown.
- Truncation:
  - Line clamp to 2 lines for verse preview.
  - Fallback when line-clamp is unavailable: max 140 characters, trim to word boundary, append "...".
- Ellipsis only at end; if text fits, show full preview.
- Tap target: entire verse block opens Detail.

## Detail
- Reference line: always visible, single line.
- Verse text: full text, no truncation; preserve line breaks (pre-line or paragraph split).
- Rationale section:
  - Title: "Why this pairing?"
  - Body: short rationale, target 2-4 lines; clamp to 4 lines with ellipsis (no expand in v1).
- Attribution line: shown under rationale (or under verse if no rationale); prefix with "— ".
- Missing states:
  - Verse missing: show "Verse unavailable right now." + "Pull to refresh or try again." (1-2 lines total).
  - Rationale missing: hide rationale section entirely.

## Typography and Spacing (Mobile-First)
- Reference line: 12px, weight 600, line-height 1.4, color #6b6b6b.
- Verse text: 17px, weight 400-500, line-height 1.6, color #111111; paragraph spacing 8px.
- Rationale title: 13px, weight 600, line-height 1.4, color #4b4b4b.
- Rationale body: 14px, weight 400, line-height 1.5, color #5c5c5c; no italics.
- Attribution line: 12px, weight 500, line-height 1.4, color #7a7a7a; prefix with "— ".
- Spacing:
  - Reference -> verse gap: 8px.
  - Verse -> rationale title gap: 14px.
  - Rationale title -> rationale body gap: 6px.
  - Rationale body -> attribution gap: 8px.
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
- Today (Preview): full verse_text (no truncation) and hide rationale.
- Detail shows full verse text; rationale heading "Why this pairing?" and clamp to 4 lines; hide rationale if missing.
- Add label row handling (fallback + approved-only) per spec.
- Omit pairing section entirely when no pairing is available (no placeholder text).
- Apply typography + spacing tokens per spec.

## References
- Visual hierarchy tokens: `docs/design/day4_visual_hierarchy_spec.md`.
- Source formatting gate: `docs/ops/source_formatting_approval_gate.md`.