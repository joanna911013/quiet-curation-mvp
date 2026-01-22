## Week 1 Foundations — Dev Tooling & AI Workflow (Cursor + Codex)

### Why this setup
We are optimizing for:
- Fast iteration on UI + flows (wireframe-driven)
- Consistent code quality with small, reviewable changes
- Minimal tool switching (Cursor as the single cockpit)

---

### Tool Stack (Locked for MVP)
- **Framework:** Next.js (routing via `app/` or `pages/`)
- **IDE:** Cursor
- **AI assistant:** Codex extension (ChatGPT Plus)
- **Design source of truth:** `docs/design/` (wireframes + md)
- **Delivery mindset:** one flow at a time, ship small, ship often

---

### Operating Rules (Non-negotiables)
1. **Docs lead, code follows**
   - If UX changes: update `docs/design/*` first.
   - If architecture/data/auth changes: update TRD.
2. **One change set = one outcome**
   - Example: “Home → Detail routing” (only that)
3. **AI generates, human decides**
   - Never merge AI output without review.
4. **Security is not delegated**
   - Auth callback/session logic, RLS/policies, env keys: manual review required.
5. **No secrets in code**
   - `.env` only, document required env vars in `docs/`.

---

### Workflow (Daily Loop)
1) Pick a single target from the playbook (1–2 hours scope)
2) Ask Codex with strict boundaries (file scope + acceptance criteria)
3) Implement + run checks
4) Manual test the core flows
5) Commit with a clean message

---

### How we prompt Codex (high-signal template)
When requesting changes, always include:
- Goal (user-visible behavior)
- Constraints (what must not change)
- Allowed files (exact paths)
- Output format (unified diff / file-by-file edits)
- Acceptance criteria + manual test steps

**Prompt skeleton**
- “Modify only: `<path1>`, `<path2>`”
- “No new dependencies.”
- “Keep UI aligned with wireframes in `docs/design/wireframes/`”
- “Return changes as a unified diff.”
- “List manual test steps.”

---

### Done Criteria (MVP)
A task is done only when:
- UI matches wireframes (`docs/design/wireframes/`)
- Build/typecheck passes
- Manual flows pass:
  - Login → Home → Detail → Save → Saved → Detail
  - Settings → Sign out

---

### Copy-ready Prompts
**(A) Routing**
“Implement navigation Home → Detail and Saved → Detail. Modify only routing files. Keep UI unchanged. Return a unified diff + manual test steps.”

**(B) Bookmark state (local-first)**
“Implement bookmark toggle on Detail and a Saved list using local state only. Keep types strict. Return a unified diff + test steps.”

**(C) Supabase auth callback**
“Add email link callback handling. Do not change UI except loading/error states. Include security notes + test steps.”
