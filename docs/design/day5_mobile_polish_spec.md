# Day 5 Mobile Polish Spec (Week 2)

## Summary
- Prevent mobile overflow in Today/Detail/Emotion with explicit clamp + ellipsis rules.
- Keep Today pairing preview compact (target 80-96px) while degrading gracefully under stress.
- Respect iOS safe-area so CTAs and inputs never sit under the bottom bar.
- Maintain quiet vibe: no banners, no loud highlights, no alert-style blocks.

## A) Text Overflow Rules (Per Element)
- Reference line: 1 line max, ellipsis always.
- Verse text:
  - Today preview: clamp 2 lines; fallback 140 chars trimmed to word boundary + "...".
  - Detail: full text, no truncation; preserve line breaks (pre-line or paragraph split).
- Rationale: clamp 4 lines; ellipsis at end only.
- Attribution: 1 line, ellipsis; enforce em dash prefix "— "; do not wrap unless unavoidable (then allow 2nd line, smaller line-height).
- Buttons/labels: 1 line max; ellipsis; no wrapping that increases card height.

## B) Worst-Case Content Guidelines
Stress cases to validate:
- Long book names (e.g., "1 Thessalonians"), long verse references, long translation labels.
- Long verse text (multi-sentence), long rationale, long literature titles/authors.

Degradation order (Today preview):
1) Truncate attribution first (if present). (Note: Today preview generally has no attribution.)
2) Clamp verse excerpt to 2 lines + ellipsis.
3) If height still exceeds 96px, allow reference to shrink in width via ellipsis; do not reduce font size.

Today pairing block height target:
- Ideal: 80-96px including padding.
- If overflow persists, keep padding at 16px but allow internal gap compression (see C).

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
- Long excerpt (Today preview)
- Long attribution (author/work/source)
- Long rationale (4+ lines)
- Long title (literature title)
- Locale switch (EN/KR) if applicable

Pass criteria:
- No text overflows container bounds.
- Today pairing preview remains compact and secondary (height target holds).
- Detail remains readable; line breaks preserved.
- CTAs/inputs are above iOS bottom bar and not clipped.
