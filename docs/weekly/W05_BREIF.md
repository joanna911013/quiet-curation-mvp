## Week 5 — iOS Wrapper Kickoff + Newsletter (Secondary)
**Outcome:** iOS wrapper boots, deep links work in TestFlight, newsletter spec drafted.

**DEV**
- Initialize Capacitor wrapper and iOS project (bundle id, app icon placeholders, build).
- Universal Links: configure associated domains + deep link routing (`/c/[id]`).
- Auth in wrapper: magic-link -> app -> login -> redirect to deep link.
- TestFlight internal build + basic install checklist.
- Newsletter: define data model + send pipeline (separate from daily invite).
- Add basic analytics events (open detail, save, emotion logged).

**DESIGN**
- iOS wrapper audit: status bar, safe areas, default fonts, in-app browser fallback.
- Newsletter content card spec + email layout constraints.

**OPS**
- Inventory discipline: tomorrow + safe set always ready.
- Add iOS wrapper QA checklist to ops routine (install -> login -> Today -> Detail).

**MKT**
- Update opt-in copy to mention iOS TestFlight (if applicable).
- Newsletter onboarding copy (why it is different, cadence, examples).

## Day 1 — Wrapper Bootstrap + Audit Start
### DEV
- [ ] Initialize Capacitor wrapper repo and iOS project (bundle id, display name, build).
- [ ] Add app icon placeholder set and launch screen defaults.
- [ ] Confirm base URL / origin config for web view and document in notes.

### DESIGN
- [ ] Start iOS wrapper audit (status bar, safe areas, default fonts, in-app browser fallback).
- [ ] Outline newsletter content card structure (fields + hierarchy).

### OPS
- [ ] Ensure tomorrow + safe set are ready (log count + date).
- [ ] Draft iOS wrapper QA checklist steps (install -> login -> Today -> Detail).

### MKT
- [ ] Review current opt-in copy and note where TestFlight mention should land.
- [ ] Outline newsletter onboarding copy sections (why, cadence, example topics).

---

## Day 2 — Universal Links + Routing
### DEV
- [ ] Configure Associated Domains + AASA for Universal Links.
- [ ] Implement deep link routing for `/c/[id]` and confirm in simulator.
- [ ] Add fallback behavior for non-app contexts (open web).

### DESIGN
- [ ] Document wrapper-specific UI notes from audit (safe-area padding, status bar).
- [ ] Draft newsletter content card spec (layout + constraints).

### OPS
- [ ] Add deep-link validation steps to the QA checklist.
- [ ] Spot-check 3 pairings for attribution correctness.

### MKT
- [ ] Draft opt-in copy update mentioning iOS TestFlight (if applicable).
- [ ] Draft newsletter onboarding copy v1 (why it is different, cadence, example).

---

## Day 3 — Auth Flow + Analytics
### DEV
- [ ] Implement magic-link auth flow inside wrapper with redirect back to deep link.
- [ ] Verify login -> redirect -> detail route works on device.
- [ ] Add analytics events (open detail, save, emotion logged).

### DESIGN
- [ ] Finalize newsletter content card spec and email layout constraints.

### OPS
- [ ] Run wrapper QA dry-run on simulator (install -> login -> Today -> Detail).
- [ ] Verify tomorrow + safe set remain ready after edits.

### MKT
- [ ] Align opt-in copy update with current product tone.
- [ ] Draft newsletter onboarding copy v2 with examples.

---

## Day 4 — TestFlight Build + Newsletter Pipeline
### DEV
- [ ] Create internal TestFlight build and record build notes.
- [ ] Create basic install checklist for internal testers.
- [ ] Define newsletter data model and draft send pipeline steps.

### DESIGN
- [ ] Provide any iOS wrapper visual tweaks from audit (if issues found).
- [ ] Share finalized newsletter email layout constraints with DEV.

### OPS
- [ ] Add TestFlight install steps to ops QA checklist.
- [ ] Confirm inventory discipline (tomorrow + safe set).

### MKT
- [ ] Finalize opt-in copy update with TestFlight mention (if applicable).
- [ ] Finalize newsletter onboarding copy for review.

---

## Day 5 — Validation + Wrap
### DEV
- [ ] Validate deep links in TestFlight build (detail route, auth redirect).
- [ ] Fix any wrapper-specific issues discovered by QA.
- [ ] Record weekly carry-overs (if any).

### DESIGN
- [ ] Sign-off on wrapper audit findings and newsletter specs.

### OPS
- [ ] Run full wrapper QA checklist on TestFlight build.
- [ ] Confirm ops routine updates applied (install -> login -> Today -> Detail).

### MKT
- [ ] Prep short internal TestFlight invite copy (if needed).
- [ ] Confirm newsletter onboarding copy ready for Week 6 use.
