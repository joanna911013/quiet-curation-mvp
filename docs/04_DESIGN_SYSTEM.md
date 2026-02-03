# 04 Design System
Last updated: 2026-01-24

Design system summary for the MVP. This file captures the current UI rules used in Week 1-2 builds and links to the canonical specs.

## Design Principles (Non-Negotiable)
- Reading-first: UI never interrupts the text.
- Quiet presence: no banners, no alert blocks, no hype.
- One screen, one intent.
- Saving feels like keeping, not clicking.
- Absence is calm: missing content does not trigger warnings.

## Core Layout Rules
- Today: preview-only verse block (2-line clamp), no rationale.
- Detail: full verse text + rationale, attribution line.
- Pairing block is secondary to the main reading flow.
- If no pairing exists, omit the pairing section entirely.
- Safe fallback renders normally; optional small label only if approved.

## Typography (MVP)
- System UI font.
- Comfortable body size and line height (1.5-1.7).
- Reference and attribution text are smaller and lighter.
- Emphasis uses weight, not color.

## Emotion UI (Week 2)
- Primary emotion required; optional memo (<= 160 chars).
- Skip does not write an emotion event.
- Confirmation copy is subtle and inline (no banners).
- Error copy is minimal and calm.

## Mobile Polish
- Today preview height target: 80-96px including padding.
- Clamp rules: verse preview 2 lines; rationale 4 lines.
- Safe-area padding for iOS bottom bar.
- No overflow for long refs or long verse text.

## Links (Canonical Specs)
- Specs index (single source of truth): `design/specs_index.md`
- Principles: `design/principles.md`
- Typography: `design/typography.md`
- Components: `design/components.md`
- User flow: `design/user-flow.md`
- Pairing component spec: `design/pairing_component_spec.md`
- Verse display spec: `design/verse_display_spec.md`
- Visual hierarchy tokens: `design/day4_visual_hierarchy_spec.md`
- Emotion UI polish: `design/day5_emotion_ui_polish.md`
- Mobile polish: `design/day5_mobile_polish_spec.md`
- Microcopy keys (EN/KR): `ops/microcopy_keys_kr_en.md`
