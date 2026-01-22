# 05 Quality Guardrails
Last updated: 2026-01-22

Behavioral contracts and release gates that protect content quality, tone, and reliability. These guardrails are the standard for approvals and QA.

## Core Guardrails
- Approved-only pairing fetch for users (no draft exposure).
- Deterministic daily pairing by (pairing_date, locale).
- UI fallback omits pairing section when none exists.
- Source formatting approval gate for citations and verse references.
- Verse text must come from DB (no generation).

## Links
- Source formatting approval gate: `ops/source_formatting_approval_gate.md`
- Decisions log: `weekly/W02_DECISIONS_LOG.md`
- QA release checklist: `09_QA_RELEASE_CHECKLIST.md`
- Gate review archive: `GATE_REVIEW_FRIDAY.md`
