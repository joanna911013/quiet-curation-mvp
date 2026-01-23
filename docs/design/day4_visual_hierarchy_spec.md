# Day 4 Visual Hierarchy Spec (Pairing Block)

## Summary
- Pairing block stays secondary and calm; no banner-like treatments or heavy callouts.
- Detail shows full verse, then a light rationale section titled "Why this pairing?" (clamp 4 lines).
- Attribution is tertiary, with a small em dash line beneath the rationale (or beneath verse if no rationale).
- Fallback: omit pairing section entirely when no pairing is available; if fallback pairing exists, render normally.

## Component Tokens (Mobile-First)
| Element | Size/Weight | Color | Spacing/Rules |
| --- | --- | --- | --- |
| Verse block container | padding 16px, radius 16px | background #ffffff, border 1px solid rgba(0,0,0,0.06), no shadow | Max width same as content column; no full-bleed banner |
| Reference line | 12px, weight 600, line-height 1.4 | #6b6b6b | Single line + ellipsis; format "{canonical_ref} ({translation})" |
| Verse text (Today preview) | 17px, weight 400-500, line-height 1.6 | #111111 | Clamp 2 lines; fallback 140 chars trimmed to word boundary + "..." |
| Verse text (Detail) | 17px, weight 400-500, line-height 1.6 | #111111 | Full text, preserve line breaks |
| Rationale title | 13px, weight 600, line-height 1.4 | #4b4b4b | Text "Why this pairing?" (Detail only) |
| Rationale body | 14px, weight 400, line-height 1.5 | #5c5c5c | Clamp 4 lines with ellipsis |
| Attribution line | 12px, weight 500, line-height 1.4 | #7a7a7a | Prefix with "— "; show beneath rationale or verse |
| Optional label (fallback) | 10px, weight 600, uppercase, letter-spacing 0.12em | #9a9a9a | Only if label already approved; otherwise omit |

Spacing tokens
- reference -> verse: 8px
- verse -> rationale title: 14px
- rationale title -> rationale body: 6px
- rationale body -> attribution: 8px
- block margin-bottom: 16px

## Visual Hierarchy Rules (Explicit)
- Primary: verse text.
- Secondary: rationale (title + body).
- Tertiary: reference line and attribution line.
- Today preview max height target: 80-96px including padding; do not set a hard min-height beyond 72px.
- Contrast limits:
  - Avoid pure black backgrounds or high-saturation fills.
  - Keep borders <= rgba(0,0,0,0.08) and backgrounds #ffffff to #fafafa only.
- Allowed emphasis: 1px light border, subtle divider line, or gentle hover/press opacity change.
- Forbidden: banner blocks, colored callouts, warning icons, exclamation copy, or heavy shadows.

## Today Layout Spec
- Order: optional label (if approved) -> reference line -> verse excerpt.
- No rationale or attribution in Today preview.
- Entire block is tappable; text remains calm with no CTA styling.

## Detail Layout Spec
- Order: optional label (if approved) -> reference line -> full verse -> rationale title -> rationale body -> attribution line.
- Rationale is supportive and lighter than the verse.
- Attribution uses em dash prefix "— " and is visually tertiary.

## Quiet Vibe Checklist (Pass/Fail)
- No large colored panels or high-contrast banners in pairing block.
- No warning or alert icons in the pairing area.
- No bold CTA inside pairing block beyond normal tap affordance.
- Typography stays within defined weights and sizes.
- Borders and backgrounds remain neutral (#ffffff to #fafafa).

## Micro-Interaction Guidance
- Tap affordance: entire verse block clickable.
- Hover/press state: subtle opacity shift (0.96) or border darken to rgba(0,0,0,0.12); no fill inversion.
- Focus ring: 2px outline rgba(0,0,0,0.12), offset 2px.
- Loading skeleton: soft neutral blocks (#f2f2f2), no shimmer, no motion-heavy effects.

## Annotated Wireframes
- Notes: `docs/design/wireframes/day4_pairing_hierarchy_annotations.md`.

## Handoff Notes for DEV
- Use CSS line-clamp for Today (2 lines) and rationale (4 lines).
- Keep pairing section omitted when no pairing is available (no placeholder text).
- Apply em dash prefix exactly for attribution line.
- Contract change: none (aligns with Day 3 pairing spec and verse display spec).
