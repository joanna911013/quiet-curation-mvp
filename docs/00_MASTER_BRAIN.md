# 00 Master Brain
Last updated: 2026-02-23

Quiet Curation MVP is in Week 5-6 closeout mode.
This document is the top-level status and source-of-truth map.

## Current Stage
- Week 5-6: MVP finish and release gate close

### What is done
- Landing and subscribe marketing flow implemented (`/landing` -> `/subscribe`).
- `/subscribe` placeholder removed; magic-link request path wired.
- Localized marketing routes runtime issue fixed:
  - `/ko/landing`, `/ko/subscribe` now resolve.
- Release QA gate run executed with evidence log.

### What is still open (P0)
- `/search-check` currently fails (`column v.text does not exist`).
- Admin runtime action checks still pending:
  - approve + set-today timing (`<= 3 min`) not yet recorded.
- Full magic-link callback/login QA and sign-out redirect QA still pending.
- Mobile viewport polish QA still pending.

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
