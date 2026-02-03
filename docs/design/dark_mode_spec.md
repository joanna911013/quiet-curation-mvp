`# Dark Mode Spec (Draft v1)
Last updated: 2026-02-02

Purpose: Fix dark-mode readability issues found in wireframes (`*_dark.png`) while keeping the “quiet” vibe.

## 1) Observed Issues (from dark wireframes)
- Primary text is too dim on dark background (Login/Detail/Saved/Settings).
- White cards in dark mode feel harsh and dominate the screen (Today/Detail).
- Ghost buttons + dividers are nearly invisible.
- Nav links and meta text lack contrast.

## 2) Decision (choose one)
**Option A — Support tuned dark palette (recommended for mobile)**  
Use a controlled dark palette with clear hierarchy and soft contrast.

**Option B — Lock light theme only**  
Set `color-scheme: light;` and disable dark mode to keep a single visual system.

This spec describes Option A. If Option B is chosen, apply the “lock light” note in §6.

---

## 3) Dark Palette Tokens (A)
Use near‑black and soft whites (avoid pure #000/#fff).

- `--dm-bg`: #0c0c0c  
- `--dm-surface-1`: #141414 (primary card)  
- `--dm-surface-2`: #1b1b1b (inner blocks)  
- `--dm-border`: rgba(255,255,255,0.10)  
- `--dm-text-primary`: #f0f0f0  
- `--dm-text-secondary`: #b8b8b8  
- `--dm-text-tertiary`: #8f8f8f  
- `--dm-accent`: #e5e5e5  
- `--dm-divider`: rgba(255,255,255,0.14)  
- `--dm-button-primary-bg`: #e7e7e7  
- `--dm-button-primary-text`: #111111  
- `--dm-button-ghost-border`: rgba(255,255,255,0.20)  
- `--dm-button-ghost-text`: #d9d9d9

## 4) Component Rules
**Body / Page**
- Background uses `--dm-bg`.
- Default text uses `--dm-text-primary`.

**Header / Nav**
- Nav links: `--dm-text-secondary` with hover to `--dm-text-primary`.
- Header border uses `--dm-divider`.

**Cards / Blocks**
- Primary cards: `--dm-surface-1` with `--dm-border`.
- Inner blocks: `--dm-surface-2` with subtle border.
- Avoid white surfaces in dark mode.

**Inputs**
- Input background: `--dm-surface-2`.
- Border: `--dm-border`.
- Placeholder: `--dm-text-tertiary`.
- Label/helper text: `--dm-text-secondary`.

**Buttons**
- Primary: light button (`--dm-button-primary-bg`) with dark text.
- Ghost: transparent + `--dm-button-ghost-border`, text `--dm-button-ghost-text`.

**Meta / Reference / Attribution**
- Meta: `--dm-text-tertiary`.
- Reference line: `--dm-text-secondary`.
- Attribution line: `--dm-text-tertiary` and ensure divider is visible.

---

## 5) Screen‑Specific Notes
**Login**
- “Send magic link” button must be clearly legible (use primary light button).
- Helper text should be `--dm-text-tertiary`, not near-black.

**Today**
- Pairing card should use dark surfaces (no white card).
- Inner literature/verse blocks use `--dm-surface-2`.
- CTA ghost row must be visible against dark surface.

**Detail**
- Replace white explanation cards with `--dm-surface-2`.
- Divider line must be visible (`--dm-divider`).
- Primary text upgraded to `--dm-text-primary`.

**Saved**
- List rows should be readable: title `--dm-text-primary`, meta `--dm-text-secondary`.

**Settings**
- Form card + button visibility (border + text) must pass contrast.

**Emotion**
- Chips: selected state uses lighter outline/fill; unselected uses `--dm-border`.

---

## 6) If Locking Light Theme (Option B)
Add a global override:
- `html { color-scheme: light; }`
- Disable dark mode tokens and keep light palette only.

---

## 7) QA Checklist (Dark Mode)
- All primary text readable (no “near‑black on dark”).
- Ghost buttons and divider lines visible.
- No white cards unless explicitly intended.
- “Quiet” vibe preserved (no high-contrast neon accents).

---

## References
- `docs/design/day4_visual_hierarchy_spec.md`
- `docs/design/day5_mobile_polish_spec.md`
- Dark wireframes in `docs/design/wireframes/*_dark.png`
