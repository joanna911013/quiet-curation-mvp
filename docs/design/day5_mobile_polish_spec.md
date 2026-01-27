# Day 5 Mobile Polish Spec (Week 2)

## Summary
- Prevent mobile overflow in Today/Detail/Emotion with clear wrapping/ellipsis rules.
- Today shows full literature + full verse in two distinct inner blocks; ensure long content wraps without overflow.
- Detail separates literature and verse with a single divider line (no verse card).
- Respect iOS safe-area so CTAs and inputs never sit under the bottom bar.
- Maintain quiet vibe: no banners, no loud highlights, no alert-style blocks.

## A) Text Overflow Rules (Per Element)
- Literature text (Today): full text, preserve line breaks; allow wrap (no clamp).
- Reference line: 1 line max, ellipsis always.
- Verse text:
  - Today: full text, no truncation; preserve line breaks (pre-line or paragraph split).
  - Detail: full text, no truncation; preserve line breaks (pre-line or paragraph split).
- Rationale: full text, no clamp; allow wrapping.
- Attribution: 1 line, ellipsis; enforce em dash prefix "— "; do not wrap unless unavoidable (then allow 2nd line, smaller line-height).
- CTA row (ghost button): 1 line, ellipsis; EN "Click to see explanations" / KR "연결고리 보려면 클릭".
- Buttons/labels: 1 line max; ellipsis; no wrapping that increases card height.

## B) Worst-Case Content Guidelines
Stress cases to validate:
- Long book names (e.g., "1 Thessalonians"), long verse references, long translation labels.
- Long verse text (multi-sentence), long rationale, long literature titles/authors.

Degradation order (Today):
1) Truncate attribution first (if present).
2) Ensure CTA row remains single-line (ellipsis).
3) Allow content to extend vertically; do not clamp literature or verse text.
4) Keep reference line single-line ellipsis; do not reduce font size.

## C) Spacing Adjustments Under Stress
Maintain hierarchy while compressing gaps if needed:
- Verse block padding: keep 16px (do not shrink).
- Internal gaps:
  - Reference -> verse: 8px default; can compress to 6px minimum.
  - Verse -> rationale title (Detail): 14px default; can compress to 10px minimum.
  - Rationale title -> rationale body: 6px default; can compress to 4px minimum.
  - Rationale body -> attribution: 8px default; can compress to 6px minimum.
- Do not reduce font sizes below spec.

## D) iOS Browser Safe-Area Rules
Primary pages (Today, Detail, Saved, Emotion):
- Add bottom padding to main content: 16px + env(safe-area-inset-bottom).
- Ensure CTA containers or fixed footers include safe-area padding.

Sticky elements (if any):
- Sticky headers: keep top safe-area padding only if they overlap the status bar.
- Sticky footers / CTA bars: add padding-bottom: env(safe-area-inset-bottom).

DEV layout note (simple):
- Use `padding-bottom: calc(16px + env(safe-area-inset-bottom))` on main wrappers.
- Add a bottom spacer element in scrolling containers (height: env(safe-area-inset-bottom)).
- Avoid absolute-positioned buttons near bottom unless safe-area padding is applied.

## E) QA Checklist (Mobile)
Devices:
- iPhone Safari
- iPhone Chrome
- Android Chrome

Cases:
- Long verse text (multiple sentences)
- Long literature excerpt (Today)
- Long attribution (author/work/source)
- Long rationale (multi-paragraph)
- Long title (literature title)
- Locale switch (EN/KR) if applicable

Pass criteria:
- No text overflows container bounds.
- Today remains readable with full literature + verse (no overflow).
- Detail remains readable; line breaks preserved.
- CTAs/inputs are above iOS bottom bar and not clipped.
