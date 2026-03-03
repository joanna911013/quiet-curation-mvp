
# Quiet Curation — AI Curator (Tier 0) 2-Week Schedule
Last updated: 2026-03-03  
Owner: Yoanna  
Timezone: Asia/Seoul (KST)

Companion doc:
- `docs/agents/AI Curator (Tier 0) Day0-2 Execution Tickets.md`

## Goal (2 weeks)
Ship a **Tier 0 AI Curator** that:
- Generates **3–10 draft pairing suggestions** per run (daily, on-demand in admin)
- Uses a **candidate pool ≤ 50** (verses) and a **selected literature source**
- Produces **strict JSON** (schema-validated server-side)
- Lets admin **import a suggestion into the existing /admin/pairings approval flow**
- Never auto-publishes; **human approval stays required**
- Enforces **admin-only access + traceable audit logs** for every generation job

## Definition of Done (DoD)
- Admin can click **Generate AI Suggestions** and see 3–10 candidates with:
  - `verse_id`, `literature_source_id`, `excerpt`, `rationale`, `risk_flags`, `score`
- Output is **schema-validated**; invalid output fails safely (no publish impact)
- Candidates are persisted in DB for traceability (`curation_job`, `curation_candidate`)
- One-click **Import to Draft** populates the pairing editor
- Basic guardrails: excerpt length cap + simple “quiet tone” banned patterns
- API is protected by **authenticated admin role check** (non-admin blocked)
- Job-level telemetry is visible: latency, model, prompt version, token/cost estimate, error_code

---

## Day 0 (Half day) — Preconditions lock
**Outcome:** Prevent schema drift and implementation rework
- [X] Confirm canonical source of constraints:
  - `docs/ops/content_constraints.md` + machine-readable `docs/ops/content_constraints.json`
- [X] Decide literature source contract for Tier 0:
  - minimum fields: `literature_source_id`, `title`, `author`, `license_status`, `allowed_for_serving`
  - id format (v1): `lit_src::<provider>::<work_slug>::v1`
- [X] Decide quote handling policy now:
  - model never invents quote text
  - model can only use provided `source_snippets[]` and must return `source_snippet_id`
- [X] Freeze prompt/schema versioning convention:
  - `curator_prompt_v1`, `schema_v1`
- [X] Freeze env contract for Day 1 wiring:
  - `OPENAI_API_KEY`, `OPENAI_MODEL_CURATOR`, `AI_CURATOR_TIER0_ENABLED`

### Day 0 Locked Decisions (Applied)
- License gate is pre-LLM:
  - reject request unless `allowed_for_serving=true`
  - reject request unless `license_status` in `public_domain|licensed|permission_granted`
- Prompt and schema versions must be logged in every generation response and error event.
- Feature flag default:
  - keep `AI_CURATOR_TIER0_ENABLED=false` in production until Week 1 smoke test passes.

---

## Week 1 — Build and Ship the Working Tier 0 Loop
**Outcome:** End-to-end: Generate → Review → Import → Approve (existing flow)

### Day 1 — LLM wiring + strict output contract
- [X] Choose model (baseline): `gpt-4.1` (single model is fine for now)
- [X] Add env vars: `OPENAI_API_KEY`, `OPENAI_MODEL_CURATOR`, `AI_CURATOR_TIER0_ENABLED`
- [X] Implement `runCuratorRecommend()` wrapper (timeout + 1 retry + logging)
- [X] Define **strict JSON schema** (Zod recommended)
- [X] Add server-side validation (reject if schema mismatch)
- [X] Add schema contract tests (valid/invalid fixture set)
- [X] Add prompt/version metadata in request/response (`prompt_version`, `schema_version`)
- Validation command note: `node scripts/validate-curator-schema.mjs` (run in `quiet-curation-web`)

### Day 2 — Candidate pool (≤50) + prompt packaging
- [X] Implement `getVerseCandidatePool(theme_brief, limit=50)`
  - keyword + embedding hybrid (use existing searchVerses where possible)
- [X] Add dedupe + diversity rules (same chapter/theme overconcentration 방지)
- [X] Compress candidates to LLM-friendly objects:
  - `verse_id`, `ref`, `snippet <= 200 chars`, `tags(optional)`
- [X] Phase 1 literature rule:
  - input requires `literature_source_id` (no web retrieval)
- [X] Add license gate:
  - candidate/source must be `allowed_for_serving=true` or equivalent flag
- Day 2 commands:
  - `npm run validate:curator-schema`
  - `node scripts/dry-run-curator.mjs --theme "grief" --locale en --source SOURCE_ID`

### Day 0-2 Completion Check (locked)
- [X] Day 0 contracts/versions/env keys frozen and documented
- [X] Day 1 wrapper/schema/fixtures/telemetry implemented and validated
- [X] Day 2 candidate pool/dedupe/payload/source gate/dry-run implemented and validated

### Day 3 — Context engineering + API contract
- [ ] Create `POST /api/admin/curation/recommend`
  - input: `{date, locale, theme_brief, literature_source_id}`
- [ ] Add admin authz in endpoint (same rule as existing `/admin` pages)
- [ ] Add rate-limit + idempotency guard (prevent rapid duplicate jobs)
- [ ] Add task spec usage for endpoint work:
  - `quiet-curation-web/tasks/TEMPLATE.yaml`
  - `quiet-curation-web/tasks/W1D3_curation_recommend_api.yaml`
- [ ] Build and persist `context_bundle` per job (agent-readable):
  - `prompt_version`, `schema_version`, `constraints_version`, `literature_source_id`, `candidate_count`

### Day 4 — Agentic validation loop + minimal DB persistence
- [ ] Add DB migrations (minimum):
  - `curation_job`
  - `curation_candidate`
- [ ] Store 3–10 candidates per job and return to UI payload
- [ ] Persist audit/trace fields:
  - `model`, `prompt_version`, `schema_version`, `constraints_version`, `latency_ms`, `error_code`, `raw_response_json`
- [ ] Add pass/fail release gate script:
  - `quiet-curation-web/scripts/qa/run-curator-gate.mjs`
  - checks: schema validity, source license gate, excerpt/tone constraints, dry-run success

### Day 5 — Agentic tooling + admin loop v1
- [ ] Add AI panel to `/admin/pairings` editor:
  - Generate button
  - Candidate list with risk badges
  - Import button per candidate
- [ ] Import action populates existing editor fields
- [ ] Import safety checks:
  - prevent duplicate `(pairing_date, locale)` conflicts
  - warn on unsaved editor divergence before import
- [ ] Add operator tooling command set:
  - `npm run curator:dry-run`
  - `npm run curator:gate`
  - `npm run curator:smoke`
- [ ] Document daily rehearsal in `docs/ops/daily_ops_routine_v1.md`
- [ ] Keep kill-switch behavior documented (`AI_CURATOR_TIER0_ENABLED`)

**Week 1 Deliverables**
- API: `/api/admin/curation/recommend`
- DB: `curation_job`, `curation_candidate`
- UI: Admin AI panel + Import to Draft
- Docs: output schema + minimal runbook note
- Security: admin-only access + rate-limit + feature flag

---

## Week 2 — Stabilize + Add Minimum Learning Traces (Still Tier 0)
**Outcome:** Fewer tone failures; enough logs to iterate without chaos

### Day 6 — Constraints SSOT (stop drift)
- [ ] Wire runtime validators to `docs/ops/content_constraints.json` only (no duplicate rules in code)
- [ ] Add CI check to fail if markdown/json constraints drift
- [ ] Ensure `constraints_version` is written to every `curation_job`

### Day 7 — Human feedback capture (agent learning signals)
- [ ] Add `reject_reason` enum (v1)
  - `off_theme`, `tone_not_quiet`, `weak_bridge`, `too_long`, `license_risk`, `duplicate`
- [ ] UI: allow “Reject” for candidates and require a reason
- [ ] Persist: `curation_candidate.status`, `rejection_reason`
- [ ] Add `accepted_without_edit` vs `accepted_with_edit` split
- [ ] Persist editor-diff metadata (`edited_fields_count`, `edited_excerpt_chars`)

### Day 8 — Compound quality loop (no fine-tune)
- [ ] Add prompt section forcing a 2-step bridge:
  - “literature theme → biblical lens → verse selection”
- [ ] Add “weak_bridge” heuristic:
  - if rationale lacks overlap with extracted themes → flag it
- [ ] Add small red-team set (10~20 prompts) for tone/safety regression check
- [ ] Add replay command for deterministic regression:
  - `npm run curator:redteam`

### Day 9 — KPI + compounding reports
- [ ] Log per job:
  - generated_count, imported_count, rejected_count
  - reject_reason distribution
- [ ] Compute edit distance between imported draft and final approved text
- [ ] Add ops KPI:
  - P50/P95 latency, per-job token usage and daily estimated cost
- [ ] Log hygiene:
  - redact PII and raw content where unnecessary (store IDs + hashes by default)
- [ ] Generate daily summary artifact:
  - `quiet-curation-mvp/docs/agents/reports/YYYY-MM-DD_curator_report.md`

### Day 10 — Final hardening + release gate
- [ ] Add feature flag to disable AI panel instantly if needed
- [ ] Run one-command final gate (`npm run curator:gate`) and save pass/fail log
- [ ] Final smoke test + confirm rollback path
- [ ] Write `docs/ai_curator/tier0_playbook.md` (1-page)
- [ ] Add migration rollback notes + “if API fails, continue manual approval flow” runbook

**Week 2 Deliverables**
- SSOT constraints enforcement + drift check
- Feedback-capture schema (reject reasons + edit-signal fields)
- Daily KPI/report artifact pipeline
- Tier 0 playbook + final release gate logs
- Red-team replay checklist + rollback guide

---

## What’s explicitly out of scope (to keep it 2 weeks)
- Auto-publish (Tier 2)
- Fine-tuning / SFT / DPO
- Web crawling for literature
- Full offline eval suite (we only do lightweight KPIs)

## Operational Risks to Watch (Tier 0)
- Prompt/schema drift causing silent quality drop
- License metadata missing in literature source records
- Admin over-trust (AI suggestion accepted without review)
- Cost spikes from repeated generation without rate controls
