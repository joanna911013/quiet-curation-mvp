# Day 4 Visual Hierarchy Spec (Pairing Block)

## Summary
- Pairing block stays secondary and calm; no banner-like treatments or heavy callouts.
- Today shows literature first, then the verse (full text), with a quiet CTA to Detail.
- Detail shows literature first, divider line, then full verse; explanation/rationale blocks remain unchanged.
- Attribution is tertiary, with a small em dash line beneath the rationale (or beneath verse if no rationale).
- Fallback: omit pairing section entirely when no pairing is available; if fallback pairing exists, render normally.

## Component Tokens (Mobile-First)
| Element | Size/Weight | Color | Spacing/Rules |
| --- | --- | --- | --- |
| Today inner block container | padding 16px, radius 16px | background #ffffff or #fafafa, border 1px solid rgba(0,0,0,0.06), no shadow | Max width same as content column; no full-bleed banner |
| Literature text (Today) | 17px, weight 400, line-height 1.6 | #3f3f3f | Full text, preserve line breaks |
| Literature text (Detail) | 16px (1rem), weight 400, line-height 1.8 | #1f1f1f | Full text, preserve line breaks |
| Reference line | 12px, weight 600, line-height 1.4 | #6b6b6b | Single line + ellipsis; format "{canonical_ref} ({translation})" |
| Verse text (Today) | 17px, weight 500, line-height 1.6 | #111111 | Full text, preserve line breaks |
| Verse text (Detail) | 17px, weight 400-500, line-height 1.6 | #111111 | Full text, preserve line breaks |
| Divider line (Detail) | 1px height | rgba(0,0,0,0.08) | Between literature and verse; no card |
| Explanation/rationale titles | 13px, weight 600, line-height 1.4 | #4b4b4b | Use existing labels ("About the literature", "Explanations") |
| Explanation/rationale body | 14px, weight 400, line-height 1.5 | #5c5c5c | Full text (no clamp) |
| Attribution line | 12px, weight 500, line-height 1.4 | #7a7a7a | Prefix with "— "; show beneath rationale or verse |
| CTA row (Today) | 14px, weight 600, line-height 1.4 | #374151 | Ghost button; EN “Click to see explanations” / KR “연결고리 보려면 클릭” |
| Optional label (fallback) | 10px, weight 600, uppercase, letter-spacing 0.12em | #9a9a9a | Only if label already approved; otherwise omit |

Spacing tokens
- literature block -> verse block: 16px
- reference -> verse: 8px
- verse block -> CTA row: 16px
- verse -> rationale title: 14px
- rationale title -> rationale body: 6px
- rationale body -> attribution: 8px
- block margin-bottom: 16px

## Visual Hierarchy Rules (Explicit)
- Primary: literature text and verse text (full, readable).
- Secondary: rationale (title + body).
- Tertiary: reference line, attribution line, and CTA hint.
- Contrast limits:
  - Avoid pure black backgrounds or high-saturation fills.
  - Keep borders <= rgba(0,0,0,0.08) and backgrounds #ffffff to #fafafa only.
- Allowed emphasis: 1px light border, subtle divider line, or gentle hover/press opacity change.
- Forbidden: banner blocks, colored callouts, warning icons, exclamation copy, or heavy shadows.

## Today Layout Spec
- Order: optional label (if approved) -> literature block -> verse block -> CTA row (ghost button).
- No rationale on Today.
- Entire block is tappable; CTA row is a visual affordance (no nested button).

## Detail Layout Spec
- Order: optional label (if approved) -> literature title/meta/text -> divider line -> verse reference + full verse -> explanation/rationale blocks -> attribution line.
- Explanation/rationale remain supportive and lighter than the primary content.
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
- Today uses two distinct inner blocks (literature + verse) with subtle border/background and equal font size.
- CTA is a ghost-button row (text-only block, no nested <button>) with EN/KR copy above.
- No truncation for Today literature or verse; rationale shows full text on Detail.
- Keep pairing section omitted when no pairing is available (no placeholder text).
- Apply em dash prefix exactly for attribution line.
