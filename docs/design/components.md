# UI Components (v1)

## Global
### 1) App Header
- Title / context line (date or theme)
- Optional icons: Saved, Settings (keep subtle)

### 2) Button
- Primary (used in Login)
- Ghost/Secondary (rare; avoid clutter)

### 3) Icon Button
- Bookmark / Save toggle
- Back button (Detail)

---

## Home / Feed
### 4) Content Card
Fields:
- Title
- Preview (1–2 lines)
- Source (author / verse reference)
- Save icon (optional on Home; primary save action can live in Detail)

Interaction:
- Tap card → Detail
- Optional: Save toggle (if included, must not steal focus)

---

## Content Detail
### 5) Reading Container
- Title
- Body text block (scroll)
- Source block (small)
- Save toggle (clear state)

---

## Saved / Bookmarks
### 6) Saved List Item
- Title
- Source
- Optional preview snippet
- Tap → Detail

---

## Settings (minimal)
### 7) Settings Row
- Account email (read-only)
- Sign out
- About/version (optional)

---

## States (must exist)
- Loading state (Home + Detail)
- Empty state (Saved has no items)
- Error state (auth failure / network)
