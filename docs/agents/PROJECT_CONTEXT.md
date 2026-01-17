# Quiet Curation — PROJECT_CONTEXT (v1)

## 0) One-liner
A quiet curation app for Scripture × Literature that prioritizes reflection, restraint, and intentional sharing.

---

## 1) Purpose
- Help users collect, write, and organize curated excerpts (Scripture, literature, quotes, links).
- Encourage calm, meaningful reflection rather than engagement-driven behavior.
- Enable optional sharing of curated *results* while protecting personal and intermediate data.

---

## 2) MVP Scope (v1)
### Must-have
- Auth: Email (OTP / Magic Link) only
- Core objects:
  - profiles (auth.users extension)
  - items (curation unit)
  - collections (groupings)
  - collection_items (mapping + ordering)
- Privacy: RLS enforced owner-based access control
- UI: Minimal pages for login + create/list/detail

### Explicitly Out-of-Scope (v1)
- Social network features (followers, likes, comments, public feed ranking)
- Collaboration/multi-owner editing
- Unlisted/share-by-link (v2+)
- Payments/subscription
- Storage (image uploads) and Edge Functions (unless unavoidable)
- Scheduled/automated agent runs

---

## 3) Data Privacy Principles (Non-negotiable)
### Always private (never public)
- User identity & profile data (beyond what is required for the app to function)
- Any LLM prompt inputs, intermediate texts, drafts, raw reflections
- Safety/guardrail text, system prompts, internal evaluation logs
- Any internal scoring, ranking, confidence traces

### Conditionally public (user-controlled)
- Curated results (items/collections) only when the user explicitly sets `visibility = public`
- Even when public:
  - owner_id remains stored
  - only owner can update/delete

### Default
- Everything defaults to `private`
- Public is always an explicit action by the user

---

## 4) Visibility Model (v1)
- `private`: owner only (default)
- `public`: readable by anyone (anon or logged-in), but writable only by owner

Notes:
- `unlisted` (link-share) is intentionally postponed to v2.

---

## 5) Tech Stack (v1)
- Frontend: Next.js (App Router)
- Backend: Supabase (Postgres + RLS)
- Auth: Supabase Email OTP (Magic Link)
- Styling: Tailwind CSS
- LLM: prompts/rules are defined in markdown, but agent automation is not required in v1.

---

## 6) Supabase & Security Rules
- Use anon key in client apps only.
- Never expose service role key to browser/client code.
- RLS must be enabled on all tables that contain user data.
- RLS policy model:
  - Owner can CRUD own records.
  - Public can read only records explicitly marked public.
  - Mapping tables must not allow bypassing privacy via joins.

---

## 7) Naming & Project Structure (workspace-level)
Recommended workspace structure:
- `quiet-curation-web/` : Next.js app (runtime)
- `quiet-curation-mvp/` : docs/specs/prompts (planning)

Docs conventions:
- `docs/ops/` : operational notes, constraints, taxonomy
- `docs/agents/` : agent context and rules (future use)
- `docs/db/` : schema and RLS SQL versions

---

## 8) Engineering Priorities (Order Matters)
1) Correctness & safety (RLS, privacy, data model integrity)
2) Fast feedback loops (simple UI, quick CRUD)
3) Minimalism (avoid premature features)
4) Maintainability (clear folder structure, small modules)

---

## 9) Agent Philosophy (v1)
- Agents assist curation, not replace human judgment.
- Agent outputs are drafts by default.
- Human approval is required before saving/publishing curated results.
- Constraints in `content_constraints.md` are treated as hard rules.

---

## 10) Reference Docs
- `docs/ops/emotion_taxonomy.md`
- `docs/ops/content_constraints.md`
- `docs/ops/llm_curation_prompts.md`
