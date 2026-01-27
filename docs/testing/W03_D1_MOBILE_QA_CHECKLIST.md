# W03_D1 Mobile QA Checklist (iOS Safe-Area + Overflow)

Goal: verify iOS safe-area/in-app browser behavior and catch overflow under worst-case content.

## 1) iOS Safe-Area Checklist
Devices/Browsers:
- iPhone Safari (latest iOS)
- iPhone Chrome (latest)
- iOS in-app browser (choose 1–2): Instagram / Gmail / KakaoTalk

Screens to check:
- Today (/)
- Detail (/c/[id])
- Saved (/saved)
- Emotion (/emotion)
- Login (/login)

Pass/Fail checks:
- Bottom CTA/input is never under the Safari bottom bar.
- Page content has bottom padding = 16px + env(safe-area-inset-bottom).
- Sticky footers (if any) include safe-area padding.
- Sticky headers do not overlap the status bar (top safe-area respected).
- Focused inputs (memo field) remain visible above the keyboard.

Notes to log:
- Device + browser version
- Page URL
- Any clipped content or overlap

## 2) Overflow Cases to Test
Content stress cases:
- Long verse reference: "1 Thessalonians 5:17 (New International Version)"
- Long book name + translation label combined
- Long verse text (multi-sentence)
- Long rationale (multi-paragraph)
- Long literature title / author line
- Long attribution line (source + work + author)
- Long emotion memo (160 chars)
- Locale switch (EN/KR) if applicable

Pass/Fail checks:
- Reference line: 1-line ellipsis (no wrap).
- Today verse excerpt: 2-line clamp with ellipsis; block height stays within 80–96px.
- Detail verse: full text, preserved line breaks, no container overflow.
- Rationale: full text renders without clipping (Detail only).
- Attribution: 1-line ellipsis, em dash prefix "— "; no multi-line expansion unless unavoidable.
- Buttons/labels remain 1 line (ellipsis if needed).

## 3) Capture
- Screenshot any failures (include device + browser info in filename).
- Note whether failure is iOS Safari-only, Chrome-only, or all iOS browsers.
