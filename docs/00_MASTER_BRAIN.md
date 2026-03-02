# 00 Master Brain
Last updated: 2026-03-02

Quiet Curation MVP is in Week 5-6 closeout mode.
This document is the top-level status and source-of-truth map.

## Current Stage
- Week 5-6: MVP finish + launch closeout

### What is done
- Landing and subscribe marketing flow implemented (`/landing` -> `/subscribe`).
- `/subscribe` magic-link request flow is wired (placeholder removed).
- Localized marketing route runtime issues are resolved:
  - `/ko/landing`, `/ko/subscribe` route correctly.
- Marketing KO copy parity pass applied on landing/subscribe/header surfaces (2026-03-02).
- Release QA gate is closed with evidence:
  - `/search-check` SQL mismatch fixed.
  - admin runtime checks complete (`approve + set-today <= 3 min`).
  - magic-link callback/login flow, logout redirect, and mobile viewport checks all PASS.
  - emotion memo DB guard applied and verified.

### What is still open
- Internationalization is still partial in the signed-in app shell (many app strings EN-first).
- `verse_embeddings` RLS verification remains partial because table is empty in QA runs.
- No automated test suite yet (manual/route/script QA only).

## Source Of Truth
- Active schedule: `weekly/W05_06_SCHEDULE.md`
- Release QA gate log: `testing/W05_D1_RELEASE_QA_GATE_LOG.md`
- QA checklist baseline: `09_QA_RELEASE_CHECKLIST.md`
- Weekly history index: `weekly/README.md`

## Links
- PRD: `01_PRD_MVP.md`
- DevOps playbook: `02_DEVOPS_PLAYBOOK.md`
- MLOps playbook: `03_MLOPS_PLAYBOOK.md`
- Design system: `04_DESIGN_SYSTEM.md`
- Quality guardrails: `05_QUALITY_GUARDRAILS.md`
- Architecture: `06_ARCHITECTURE.md`
- Data schema: `07_ERD_DATA_SCHEMA.md`
- Prompts library: `08_PROMPTS_LIBRARY.md`
