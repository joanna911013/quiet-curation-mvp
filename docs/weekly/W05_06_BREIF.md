# Quiet Curation — Week 5–6 Tasks (Landing-First, Stronger Marketing Design)
Last updated: 2026-02-09  
Owner: Yoanna  
Repo: `quiet-curation-web`

## Assumptions (Locked)
- Routes + basic page structure already exist:
  - `/` = Login (existing)
  - `/landing` = Marketing landing (public)
  - `/subscribe` = Subscribe page (public; Week 5 uses external email-only form)
  - Optional: `/sample` = Public sample (if already present, keep)
- Week 5–6 priority is **marketing clarity + persuasion + conversion**, not backend integration.
- Landing visual system may differ from the in-app reading experience:
  - Landing can be **bolder / more expressive** (stronger hero, richer visuals, insight-driven sections),
  - while preserving brand tone: **quiet, premium, non-hype** (strong ≠ loud).

---

## Design Direction (for Landing Only)
**Objective:** First-time visitor gets (1) the pain, (2) the promise, (3) the proof, (4) the path to subscribe — within 30–60 seconds.

### Visual Targets
- Premium, editorial, modern; stronger contrast than the app is acceptable.
- Confident hero composition (typography-led) + one distinctive signature motif (e.g., subtle animated gradient, “screen loop” visual metaphor, or timeline strip).
- Still calm: no neon, no aggressive “growth-hack” UI, no clutter.

### Messaging Targets
- Core narrative: **screen-loop life → 3-minute dopamine detox → daily quiet invite (email)**
- “Insight” layer: short framework or observation about modern attention economy (1–2 sections).
- Social proof can be replaced (temporarily) by “principles + what you’ll get / won’t do” until real testimonials exist.

---

# WEEK 5 — Landing v1: Strong Visual + Persuasive Story
**Week 5 Goal:** A marketing-grade landing page that can carry Medium/LinkedIn traffic and convert via `/subscribe` → external email form.

## Day 1 — Lock Story + Build the Marketing Narrative (No UI polish yet)
**DESIGN**
- Lock the landing story arc (one page doc): O
  1) The problem (screen loop / attention rental)
  2) The promise (3-minute morning reset)
  3) The mechanism (what arrives, how often, how long)
  4) The proof (sample / principles)
  5) The path (subscribe)
- Define a landing-only visual system: O
  - Typography: 2–3 sizes for hero + body, stronger hierarchy than app
  - Color/contrast rules (what “strong but calm” means)
  - Signature motif concept (choose 1): gradient field, screen timeline, subtle motion line, etc.
- Choose Hero direction (1 of 3): O
  - “3 quiet minutes” value-first
  - “Before the first scroll” ritual-first
  - “Screen loop” problem-first
- Draft section headlines + subcopy (v0) for all core sections. O

**MKT**
- Tighten target persona statement for Week 5 distribution. O
- Prepare a “promise” statement (1 sentence) for reuse in posts + OG description. O
- Finalize the conversion-critical FAQs (5–6) and the “for/not for” bullets. O

**DEV (minimal)**
- Add placeholders/slots for the new sections (no styling perfection required): O
  - Insights section
  - Principles section
  - For/Not-for section
- Add optional anchors (e.g., `#how`, `#sample`, `#faq`) for internal navigation. O

**OPS**
- Confirm the “operational truth” to avoid overpromising: O (3분 운영 확인됨)
  - send frequency, unsubscribe reality, what counts as “3 minutes”.

**Deliverable**
- A locked narrative map + section copy draft that guides all design decisions.

---

## Day 2 — Start Concrete Design: Hero + Above-the-Fold Conversion
**DESIGN**
- Design and implement (in UI) the **Hero block** as the first “finished” area: O
  - Headline + subheadline + microcopy
  - Primary CTA to `/subscribe`
  - Secondary link to sample or “see how it works”
  - One signature motif integrated (strong but calm)
- Establish landing grid + spacing rhythm (marketing layout rules). O
- Define 2 CTA styles: O
  - Primary (solid)
  - Secondary (quiet link/button)

**MKT**
- Finalize CTA phrasing set:
  - Primary, sticky, final CTA (consistent but not repetitive)
- Write a 2-line credibility promise near CTA (unsubscribe/no spam/privacy).

**DEV**
- Implement hero styling + responsive behavior (phone/tablet/desktop). O
- Ensure fold behavior: CTA visible on common mobile heights. O
- Add basic click tracking hooks (optional): O
  - `lp_cta_subscribe_click`, `lp_cta_secondary_click`

**OPS**
- Prepare sample excerpt (short) + attribution snippet for later sections.

**Deliverable**
- A marketing-grade hero that looks intentional and converts.

---

## Day 3 — Build the Persuasive Middle: Insights + How It Works + Proof
**DESIGN**
- Design “Insights” section (the landing differentiator):
  - Short framework: “Screen Loop → Overstimulation → Quiet Reset”
  - Or “3-minute ritual beats infinite feeds”
  - Use strong typography and clear visual structure (cards, timeline, or steps).
- Design “How it works” (3 steps) with premium feel.
- Design “Proof” module:
  - Sample preview card (title + 2 lines + timestamp)
  - OR “principles” if sample is not public-ready

**MKT**
- Write the Insight copy (tight, punchy, non-hype).
- Draft 1–2 “pull quotes” (not testimonials; product claims framed as principles).

**DEV**
- Implement Insights + How It Works + Proof sections.
- Ensure responsive layout and consistent spacing rhythm.
- Add anchors for deep links from posts (e.g., `/landing#insights`).

**OPS**
- Verify sample content legality/attribution (if showing real text).
- If sample is risky, provide “safe sample” (structure only, minimal quote).

**Deliverable**
- Landing middle sections that justify the product logically and emotionally.

---

## Day 4 — Trust Layer: Principles + For/Not-for + FAQ (Objection Removal)
**DESIGN**
- Design Trust block (choose one structure):
  - A) “What you’ll get / What we won’t do” split layout
  - B) “Principles” cards (3–5 cards)
- Add “For / Not for” section (tight funneling).
- Design FAQ accordion with strong readability.

**MKT**
- Write “For / Not for” bullets (short, honest).
- Write FAQ answers (short, calm; remove anxiety).
- Draft footer promise line (unsubscribe + privacy).

**DEV**
- Implement Trust + For/Not-for + FAQ.
- Accessibility pass for accordion (keyboard, focus states).

**OPS**
- Confirm all trust statements match real ops.
- Prepare a micro “support” line (contact email or simple guidance).

**Deliverable**
- Landing removes objections and feels credible without testimonials.

---

## Day 5 — Conversion Polish + Share Preview + Distribution Readiness
**DESIGN**
- Full responsive polish:
  - line breaks, spacing, card stacking, touch targets (44px)
- Ensure the page feels “strong” but still calm (no visual noise).
- Final CTA section tuned for conversion (repeat the promise, not the features).

**MKT**
- Create distribution asset pack:
  - 2 LinkedIn posts (different angles)
  - Medium CTA block (short)
  - 3 short hook lines for comments/DM replies
- Link discipline:
  - all external links point to `/landing`
  - `/landing` primary CTA points to `/subscribe`

**DEV**
- OG/SEO finalize for `/landing`:
  - `title`, `description`, `og:image`, `og:title`, `og:description`
- Build/attach a simple OG image that matches the stronger landing style.
- Performance sanity pass (images, fonts).

**OPS**
- Confirm external form is ready and consistent in tone.
- Define daily/bi-daily opt-in review routine.

**Week 5 Exit Criteria**
- Landing reads as a confident marketing page (not a product UI clone)
- CTA flow works smoothly (landing → subscribe → external form)
- Share preview is clean on LinkedIn

---

# WEEK 6 — Landing v1.1: Iterate, Tighten, and Turn It Into a Funnel Machine
**Week 6 Goal:** Improve conversion and clarity with controlled iterations (no backend expansion).

## Day 1 — Review + Decide the Two Experiments (Only Two)
**MKT**
- Define two controlled tests:
  - Test 1: Hero headline variant (A/B)
  - Test 2: Insight section framing variant (A/B)
- Prepare two UTM links for distribution (`utm_content=heroA|heroB`).

**DESIGN**
- Ensure variants keep layout intact across breakpoints.
- Identify 1–2 visual improvements that reduce cognitive load (spacing, hierarchy, fewer words).

**DEV**
- Implement variant switching minimally:
  - `?v=a|b` OR two distinct landing URLs under the same route using query param.
- Add basic measurement tags per variant (even just UTM + click counts).

**OPS**
- Capture qualitative feedback from early viewers (DMs/comments); compile top objections.

**Deliverable**
- Two experiments ready to run without scope creep.

---

## Day 2 — Refine Above-the-Fold: Clarity, CTA, and Trust Microcopy
**DESIGN**
- Improve hero hierarchy:
  - shorten subheadline if needed
  - make CTA unmissable but quiet
- Adjust micro trust line placement for maximum reassurance.

**MKT**
- Rewrite CTA microcopy using “promise language” not “feature language”.
- Update FAQ answers based on feedback.

**DEV**
- Ship hero tweaks + ensure mobile fold is still correct.

**Deliverable**
- Higher clarity, less friction, improved CTA confidence.

---

## Day 3 — Strengthen the Insight Sections (Differentiation)
**DESIGN**
- Make Insights section more “shareable”:
  - clear visual structure (timeline/cards)
  - one memorable phrase
- Add a small “Why email, not an app (yet)” micro-section (optional).

**MKT**
- Write the “Why email” rationale in 3–4 calm sentences.
- Create 1 short share snippet that can be quoted in LinkedIn posts.

**DEV**
- Implement the micro-section and anchor it (`#why-email`).

**OPS**
- Ensure “why email” aligns with real delivery ops.

**Deliverable**
- Differentiation increases; visitors understand the product choice.

---

## Day 4 — Trust Upgrade Without Testimonials + Consistency Check
**DESIGN**
- Replace any weak placeholder blocks with “principles” cards or “promises” split.
- Ensure the landing is internally consistent (even if different from app).

**MKT**
- Add “who it is not for” honesty to prevent wrong signups.
- Draft 1 “founder note” paragraph (optional, short) for credibility.

**DEV**
- QA for accessibility + mobile.
- Verify share preview after changes.

**OPS**
- Validate claims vs reality (no overpromising).

**Deliverable**
- A credible landing that filters the right audience.

---

## Day 5 — Ship v1.1 + Weekly Readout + Next Iteration Plan
**MKT**
- Publish recap post (learning-based, quiet tone).
- Update pinned/profile links (ensure `/landing` is canonical).

**DESIGN**
- Final polish pass; document the landing visual system (so future edits stay coherent).

**DEV**
- Deploy v1.1.
- Collect a minimal weekly readout:
  - views, CTA clicks, subscribe clicks (even if approximate)

**OPS**
- Maintain opt-in sheet hygiene and note operational learnings.

**Week 6 Exit Criteria**
- Landing is clearly persuasive and distinct (strong design + insight-driven)
- Two experiments ran (or are ready) with measurable outcomes
- Conversion flow is stable and share previews remain correct

---

## Notes (Deliberately Out of Scope for Weeks 5–6)
- Supabase subscriber table + internal subscribe submission
- Automated welcome emails, segmentation, lifecycle messaging
- iOS app work (defer until delivery loop is proven)
