# Agents Playbook (How we collaborate in Week 2)

This file defines:
- what each agent reads
- what each agent writes
- where daily progress is recorded

Non-negotiable:
- Daily progress is recorded ONLY in `docs/weekly/W02_EXECUTION_PLAN.md`.
- Decisions are recorded ONLY in `docs/weekly/W02_DECISIONS_LOG.md`.

---

## DEV Agent
**Reads**
- docs/weekly/W02_EXECUTION_PLAN.md
- docs/weekly/W02_DECISIONS_LOG.md
- docs/07_ERD_DATA_SCHEMA.md
- docs/DESIGN_TO_DEV.md

**Writes**
- code + migrations
- W02_EXECUTION_PLAN.md → DEV lane (Done/Blocked/Next)
- If needed: W02_DECISIONS_LOG.md (new decision only)
- If schema changed: patch docs/07_ERD_DATA_SCHEMA.md

**Output format in Cursor**
- What changed (bullets)
- What to test (bullets)
- Blockers (bullets)

---

## DESIGN Agent
**Reads**
- docs/weekly/W02_EXECUTION_PLAN.md
- docs/design/* (principles/components/typography/user-flow/scope)
- docs/DESIGN_TO_DEV.md

**Writes**
- W02_EXECUTION_PLAN.md → DESIGN lane
- If a new UI rule affects dev: add one entry to W02_DECISIONS_LOG.md

**Never**
- edits schema docs

---

## OPS Agent
**Reads**
- docs/weekly/W02_EXECUTION_PLAN.md
- docs/ops/content_constraints.md
- docs/ops/emotion_taxonomy.md
- docs/ops/llm_curation_prompts.md

**Writes**
- W02_EXECUTION_PLAN.md → OPS lane (inventory + readiness)
- W02_DAILY_OPERATOR_RUNBOOK.md (only if ops steps change)
- W02_DECISIONS_LOG.md (policy decisions only)

---

## MASTER Agent
**Reads**
- all relevant docs, but operates through Week 2 weekly docs

**Writes**
- Morning LOCK + Evening GATE blocks in W02_EXECUTION_PLAN.md
- Decisions Log entries
- Keeps runbook ≤15 minutes
- Enforces scope discipline (no new features outside Week 2)

---

## Prompting Rules (Cursor)
Every agent prompt MUST include:
1) Role
2) Read scope (2–4 files)
3) Today goals (1–3)
4) Freeze list (2)
5) Output location (exact file + lane)
6) Gate checks (measurable)
