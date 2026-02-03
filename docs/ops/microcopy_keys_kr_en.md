# Microcopy Keys (KR/EN) — Week 2 Day 4

## A) Microcopy Keys + Translations

| key | EN | KR | where shown | notes |
| --- | --- | --- | --- | --- |
| pairing.rationale_heading | Why this pairing? | 연결고리 설명 | Pairing Detail rationale heading | User-facing; shows only when rationale exists. |
| pairing.fallback_label | Alternate pairing | 다른 조합 | Pairing label (Today/Detail) | User-facing; show only when safe_fallback_used = true. |
| pairing.verse_missing_short | Verse unavailable right now. | 지금은 구절을 볼 수 없어요. | Pairing missing state | User-facing; conditional only. |
| pairing.verse_missing_hint | Pull to refresh or try again. | 아래로 당겨 새로고침하거나 다시 시도해 보세요. | Pairing missing state | User-facing; conditional only. |
| admin.banner.today_missing | Today pairing missing | 오늘 페어링 없음 | /admin banner | Admin-only; not used in v1 UI. |
| admin.badge.approved | Approved | 승인됨 | /admin badge | Admin-only; debug label, never user-facing. |
| admin.badge.draft | Draft | 초안 | /admin badge | Admin-only; not used in v1 UI. |
| admin.badge.scheduled | Scheduled | 예약됨 | /admin badge | Admin-only; not used in v1 UI. |

## B) Disclaimer Policy (Conditional Only)

### Triggers (boolean conditions)
- safe_fallback_used = true
  - Definition: No approved pairing for today; Safe Pairing Set is served.
- verse_missing = true
  - Definition: Translation missing or verse row missing.
- attribution_incomplete = true
  - Definition: Missing required literature attribution (author and work both empty).
  - Policy: Block approval; if surfaced, show admin-only warning.

### Exact Wording (EN + KR)
- safe_fallback_used
  - User-facing: pairing.fallback_label (EN "Alternate pairing" / KR "다른 조합")
  - Admin-facing: admin.banner.today_missing (EN "Today pairing missing" / KR "오늘 페어링 없음")
- verse_missing
  - User-facing:
    - pairing.verse_missing_short (EN "Verse unavailable right now." / KR "지금은 구절을 볼 수 없어요.")
    - pairing.verse_missing_hint (EN "Pull to refresh or try again." / KR "아래로 당겨 새로고침하거나 다시 시도해 보세요.")
- attribution_incomplete
  - Admin-only warning:
    - EN: "Attribution incomplete (author or title required)."
    - KR: "출처 정보 불완전 (저자 또는 작품명 필요)"
  - User-facing: none (block approval instead).

### Placement Guidance
- User-facing content must stay minimal and calm; no banners in the pairing block.
- safe_fallback_used: show only the small label above the verse block (no apology tone).
- verse_missing: show the two-line calm message where the verse block would render.
- attribution_incomplete: show only on /admin (never in user UI).

## C) DEV Handoff Notes
- Update i18n message files:
  - quiet-curation-web/messages/en.json
  - quiet-curation-web/messages/ko.json
- Key names must match exactly as listed above.
- admin.* keys are admin-only and must never render outside /admin.
