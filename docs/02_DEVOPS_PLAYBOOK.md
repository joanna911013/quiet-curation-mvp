# 02 DevOps Playbook
Last updated: 2026-01-22

Operational reference for daily pairing approvals, fallback safety, and delivery readiness. This is the operator-facing summary with links to detailed runbooks and inventories.

## Daily Operator Loop
1) Approve pairing for today (date + locale).
2) Verify Today renders approved-only pairing.
3) Run fallback drill (remove today pairing, confirm safe set fallback).
4) Run quiet invite cron and confirm dedupe.

## Links
- Daily operator runbook: `weekly/W02_DAILY_OPERATOR_RUNBOOK.md`
- Pairing inventory (Day 3): `ops/day3_pairing_inventory.md`
- Execution plan (Ops lane): `weekly/W02_EXECUTION_PLAN.md`
