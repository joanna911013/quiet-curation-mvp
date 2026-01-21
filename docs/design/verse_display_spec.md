# Verse Display Spec (Today vs Detail)

## Scope
- Screens: Today (/) and Detail (/c/[id]).
- Verse reference format is fixed: "{Book} {Chapter}:{Verse} ({Translation})".
- Verse text must be DB-sourced only (no generation).

## Global Rules
- Reference line is always shown and always single-line with ellipsis on overflow.
- Use the same verse block container on Today and Detail; only content changes.
- Use translation label from DB.

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
- Rationale: show below verse text; target 1-2 sentences. If longer, clamp to 3 lines with ellipsis (no expand in v1).
- Missing states:
  - Verse missing: show "Verse unavailable right now." + "Pull to refresh or try again." (1-2 lines total).
  - Rationale missing: hide rationale section entirely.

## Typography and Spacing (Mobile-First)
- Reference line: 12px, weight 600, line-height 1.4, color #6b6b6b.
- Verse text: 17px, weight 400-500, line-height 1.6, color #111111; paragraph spacing 8px.
- Rationale: 14px, weight 400, line-height 1.5, color #5c5c5c; no italics.
- Spacing:
  - Reference -> verse gap: 8px.
  - Verse -> rationale gap: 12px.
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
- Empty (no pairing after fallback): "No pairing yet. Check back later." + Retry action.
- Error: "Unable to load verse. Check connection and retry." + Retry action.
- Unapproved pairing: treat as empty unless fallback data exists.

## DEV Implementation Checklist
- Apply Today truncation rules (2-line clamp + 140-char fallback + ellipsis) and hide rationale.
- Detail shows full verse text; rationale clamps to 3 lines; hide rationale if missing.
- Add label row handling (fallback + approved-only) per spec.
- Apply typography + spacing tokens and state copy per spec.
