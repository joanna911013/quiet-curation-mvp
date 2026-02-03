# OPS To DEV
Last updated: 2026-01-23

Handoff notes for operational requirements that impact implementation and data workflows.

## Updates
- Expanded Safe Pairing Set to 10 approved items (ops-marked).
- Approved the 2026-01-21 pairing and inserted new approved pairings for 2026-01-27 to 2026-02-01 (public domain sources).
- Added SQL for candidate listing + bulk verification and a daily review checklist with a 3-item sample run.
- Created `docs/ops/daily_ops_routine_v1.md` (daily ops routine v1) with UI + SQL steps and pass/fail checks.
- No DB flag for safe set yet; currently tracked via ops process (proposed `is_safe_set` in DB).

## Links
- Execution plan (Ops lane): `../weekly/W02_EXECUTION_PLAN.md`
- Daily ops routine: `../ops/daily_ops_routine_v1.md`
- Quality guardrails: `../05_QUALITY_GUARDRAILS.md`
