# Source Formatting Approval Gate

## Scope
- Applies to Today/Detail UI and Quiet Invite email.
- This checklist is pass/fail; any failed item blocks approval.

## Required Fields (Pass/Fail)
- [ ] Literature attribution has at least one non-empty field: `literature_author` or `literature_work`.
- [ ] Verse fields present and non-empty: `book`, `chapter`, `verse`, `canonical_ref`, `translation`, `verse_text`.
- [ ] `canonical_ref` matches `{Book} {Chapter}:{Verse}` and equals the composed values from `book`, `chapter`, `verse`.
- [ ] `canonical_ref` comparison must be performed after trimming leading/trailing whitespace.
- [ ] Stored `canonical_ref` should be normalized at write-time to avoid accidental mismatches.
- [ ] Minor whitespace differences must not cause approval failures.
- [ ] `translation` is the display label used in the reference line (version label required).
- [ ] Fields containing only whitespace are treated as empty and fail validation.

## Display Strings (Pass/Fail)

### Literature citation line
- [ ] Use a literal em dash prefix: `— ` (U+2014 + space).
- [ ] Author + title: `— {Author}, *{Title}*`
- [ ] Author only: `— {Author}`
- [ ] Title only: `— *{Title}*`
- [ ] Year is optional and only shown when title exists:
  - `— {Author}, *{Title}*, {Year}`
  - `— *{Title}*, {Year}`
- [ ] No extra labels or suffixes.

### Verse reference line
- [ ] Format exactly: `{Book} {Chapter}:{Verse} ({Translation})`
- [ ] `Book` uses canonical full names from the DB (no abbreviations).
- [ ] `Translation` label matches DB display label (e.g., "NIV").
- [ ] No extra punctuation or prefixes.

### Optional pairing section labels (UI only)
- [ ] Rationale heading: `Why this pairing?`
- [ ] Fallback label (safe set only): `Alternate pairing`
- [ ] Admin/debug label (not user-facing): `Approved`
- [ ] No other label strings.

## Missing/Empty Behavior (Pass/Fail)
- [ ] If verse `translation` is missing, the verse block must not render (treat as verse missing).
- [ ] If pairing is missing, omit the pairing section entirely (no placeholder text).
- [ ] If rationale is missing, omit the rationale section (no heading).

---

# Quiet Invite Subject Lines (EN/KR)

- EN: "A quiet pairing for today" / KR: "오늘의 조용한 만남"  
  Rationale: Calm and minimal, signals a gentle pairing without pressure.
- EN: "Today, a line and a verse" / KR: "오늘은 한 줄, 한 절"  
  Rationale: Descriptive and light; avoids marketing language.
- EN: "A small reading for today" / KR: "오늘의 짧은 읽기"  
  Rationale: Soft, low-stakes framing that fits the Quiet Invite tone.
- EN: "A quiet invite" / KR: "조용한 초대"  
  Rationale: Matches the product concept while staying understated.
- EN: "Today’s reading" / KR: "오늘의 읽기"  
  Rationale: Fully neutral and informational; safest option for long-term delivery and deliverability.


---

# Quiet Invite Pairing Snippet Rules (Email)

## Rules
- If pairing exists, include at most 2 lines: 1 short verse line + 1 short rationale line.
- Verse line format: `{Book} {Chapter}:{Verse} ({Translation}) - {short excerpt}`.
- Keep each line <= 90 characters, including spaces.
- Rationale line is optional; omit if missing.
- No section labels (do not include "Why this pairing?" in email).
- If pairing is missing, omit the pairing section entirely (no "missing" copy).
- Tone: gentle, reflective, not salesy, not moralizing, not "AI-sounding".
- Avoid guilt language, urgency, or CTAs.
- If the verse excerpt exceeds the 90-character limit, truncate at a word boundary and append an ellipsis ("…").
- Note: Truncation behavior should match UI preview truncation philosophy.

## Examples

**Good**
```
Matthew 11:28 (NIV) - Come to me, all you who are weary.
A quiet reminder to rest without hurry.
```

**Bad**
```
Why this pairing? Isaiah 40:31 (NIV) - Those who hope in the Lord will renew their strength and soar on wings like eagles; they will run and not grow weary.
You need this today. Do not miss it.
Click to read more now.
```
