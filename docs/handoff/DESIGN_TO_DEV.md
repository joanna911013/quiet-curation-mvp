# DESIGN_TO_DEV.md
Quiet Curation MVP - Design to Dev Handoff

Last updated: 2026-01-27
Owner: Yoanna
Scope: Wireframes and design docs to implementation rules for Next.js (App Router) + next-intl

Sources:
- docs/design/principles.md
- docs/design/typography.md
- docs/design/components.md
- docs/design/user-flow.md
- docs/design/scope.md
- docs/design/wireframes/*.png
- docs/ops/content_constraints.md
- docs/ops/emotion_taxonomy.md (only if check-in flow is enabled)

---

## 0) Goal
Build a 5-screen MVP with a calm, reading-first experience.
- One screen, one intent.
- Keep interactions quiet and minimal.
- One primary action per screen.

### MVP Screens (wireframes)
All screens use locale-prefixed routes.
1) Login (/[locale]/login)
2) Home / Feed (/[locale])
3) Content Detail (/[locale]/detail/[id])
4) Saved / Bookmarks (/[locale]/saved)
5) Settings (/[locale]/settings)

---

## 1) Design Principles (must hold)
- Do not interrupt reading; controls are secondary.
- Whitespace creates emotion; prefer breathing room over decoration.
- One screen, one intent (Home choose, Detail read, Saved return, Settings manage).
- Less explanation, more resonance.
- Saving should feel like "keeping," not "clicking."

---

## 2) Visual System
### Layout
- Container: centered, max width ~520-640px.
- Side padding: 16-20px.
- Vertical spacing scale: 8 / 12 / 16 / 24 / 32.

### Tap targets
- Minimum interactive target: 44px.
- Icon buttons must include aria-labels.

### Surfaces
- Rounded corners: 16-24px.
- Prefer borders over heavy shadows.

### Typography (from docs/design/typography.md)
- Font: system UI (platform default).
- Title: slightly larger, medium weight.
- Body: comfortable base size, line height ~1.5-1.7.
- Source/meta: smaller, lighter.
- Keep line length readable; avoid wide blocks.

---

## 3) Component Map (Design -> Code)
Core components from docs/design/components.md:
- AppHeader: title/context line + optional Saved/Settings icons.
- Button: primary and ghost, with a clear disabled state.
- IconButton: bookmark/save and back.
- ContentCard: title, preview (1-2 lines), source line; tap -> Detail.
- ReadingContainer: top bar with Back + Save; body text block; source/meta line.
- ListItem: title + source + optional preview; full row tap -> Detail.
- SettingsRow: account email (read-only) + sign out.

States (must exist):
- Loading (Home and Detail).
- Empty (Saved).
- Error (auth failure / network).

---

## 4) Screen Notes

### 4.1 Login
Goal: minimal friction.
- Title: "Sign in"
- CTA: "Continue with email" or "Send sign-in link"
- Subtext: "We'll email you a one-time sign-in link. No password."
- Optional privacy line: "We never share your email."

### 4.2 Home / Feed
Goal: fast scan and selection.
- Header: context line + title + 1-line description.
- List 1-3 ContentCards.
- Primary action is tapping a card; avoid extra CTAs unless check-in flow is enabled.

### 4.3 Content Detail
Goal: distraction-free reading.
- Top bar: Back + Save toggle.
- Body: present Literature and Scripture clearly (no commentary).
- Keep source/reference lines visible but subtle.

Content rules (from docs/ops/content_constraints.md):
- Literature: 2-3 sentences max (<= ~280 chars per locale).
- Scripture: exactly 1 verse, copied accurately.
- No commentary; the text should stand on its own.

### 4.4 Saved
Goal: quick return to reading.
- List rows only; tap -> Detail.
- Empty state: "No bookmarks yet."

### 4.5 Settings
Goal: minimal account info.
- Email display (read-only).
- Ghost button: "Sign out."
- Optional About/version rows.

---

## 5) i18n Notes (next-intl baseline)
- Route policy: all screens live under /[locale] to avoid partial localization drift.
- Locale routes: /en and /ko must render for every screen.
- Localize core strings first: screen titles, CTAs, short descriptions, empty states.
- Keep emotion keys stable across locales (see docs/ops/emotion_taxonomy.md).

Recommended key structure (example):
- nav.saved, nav.settings
- login.title, login.cta, login.subtext
- home.today, home.title, home.subtitle
- detail.back, detail.save
- saved.title, saved.empty
- settings.title, settings.signOut

---

## 6) Out of Scope (v1)
- Social features (followers, likes, comments, feed ranking)
- Search/filters
- Notifications/reminders
- Custom profiles/themes
- Storage uploads or edge functions (unless unavoidable)

---

## 7) Optional Check-in Flow (if enabled)
If we keep the Emotion and Done screens in v1, follow docs/ops/emotion_taxonomy.md:
- Single-select emotion chips, Save enabled after selection.
- Optional memo (1-2 lines, max 160 chars).
- Helper line: "How is your heart right now?"
- Keep copy quiet and non-guilting.
Routes (if enabled): /[locale]/emotion, /[locale]/done.

---

## 8) Acceptance for Dev
- Core flows work: Login -> Home -> Detail -> Saved -> Detail, and Settings -> Sign out.
- No crashes; navigation is stable.
- Locale routes render for every screen; core strings localized (partial OK for Week 1 gate).
- Reading experience stays calm (no modal traps, no noisy prompts).

---

## 9) Day 4 Design Handoff — Pairing Hierarchy + Quiet Vibe (2026-01-22)
Source of truth:
- docs/design/day4_visual_hierarchy_spec.md
- docs/design/verse_display_spec.md
- docs/design/pairing_component_spec.md
- docs/design/wireframes/day4_pairing_hierarchy_annotations.md

Implementation notes:
- Today pairing order: literature block (full) then verse block (full); add CTA ghost button row (EN “Click to see explanations” / KR “연결고리 보려면 클릭”).
- Detail pairing: full verse, then title "Why this pairing?" + rationale body (no clamp), then attribution line with exact em dash prefix "— ".
- Fallback: omit pairing section entirely when no pairing is available; no placeholder copy or error styling.
- Container styling: padding 16px, radius 16px, border rgba(0,0,0,0.06), background #ffffff to #fafafa, no heavy shadow.
- Micro-interaction: subtle hover/press only (opacity ~0.96 or border to rgba(0,0,0,0.12)); no fill inversion.

Guardrails:
- No banner-like callouts or high-contrast blocks.
- No warning or alert icons inside the pairing block.
- "Alternate pairing" label only if already approved; otherwise omit.

---

## 10) Day 5 Design Handoff — Mobile Polish + Emotion UI (2026-01-23)
Source of truth:
- docs/design/day5_mobile_polish_spec.md
- docs/design/day5_emotion_ui_polish.md
- docs/design/wireframes/day5_mobile_polish_annotations.md

Implementation notes:
- Overflow rules: reference 1-line ellipsis; Today literature/verse full text (no clamp); Detail verse full text; rationale full text; attribution 1 line with \"— \"; buttons/labels 1 line.
- Safe-area: add `padding-bottom: calc(16px + env(safe-area-inset-bottom))` on main wrappers; add bottom spacer in scroll containers.

Emotion UI:
- Confirmation: inline \"Logged for today\" under chips or near CTA; no banner.
- Error: inline \"Unable to save right now.\" + \"Try again\"; no alert block.

---

## 11) Day 3 Design Handoff — Fallback + Admin Warning (2026-01-28)
Source of truth:
- docs/design/day3_fallback_admin_ui_spec.md

Implementation notes:
- Fallback UI must render normally; no warning banners or alert tone.
- Admin warning \"Today pairing missing\" should be an inline neutral row (no amber background, no icons).
- Keep the admin warning visually lighter than primary admin actions.
- Selection: calm highlight (light tint + border), no saturated fills.
