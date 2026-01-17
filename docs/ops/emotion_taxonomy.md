# docs/ops/emotion_taxonomy.md
# Emotion Taxonomy (MVP v1)

## 0) Purpose
This taxonomy exists to power a **fast, non-judgmental daily flow**:
**Open → Read (Curation) → Choose Emotion → (Optional) 1–2 lines memo → Done**
Target: Christians (incl. beginners). **No guilt. No gamification. Quiet presence.**
Supports **KO/EN** with **1:1 mapping** between emotions.

## 1) Non-Negotiables
- **Anti-Guilt:** no “streak loss”, no shame language.
- **Fast:** user completes check-in in **~60–120 seconds** (MVP).
- **Low cognitive load:** 9 emotions max in MVP.
- **Neutral tone:** emotions are “states”, not “labels”.
- **i18n:** exact mapping KO ↔ EN, stable keys.

## 2) MVP Emotion Set (9)
Use these as stable keys (do not rename keys after launch).

| Key (EN)     | Label (KO) | Label (EN) | UI 1-liner (KO) | UI 1-liner (EN) |
|--------------|------------|------------|------------------|-----------------|
| peace        | 평안        | Peace      | 마음이 잠잠해지고, 현재에 머무를 수 있어요. | My mind is quiet; I can stay present. |
| anxiety      | 불안        | Anxiety    | 아직 오지 않은 일들이 마음을 흔들고 있어요. | The future feels loud and unsettling. |
| weariness    | 지침        | Weariness  | 애써왔지만 더 나아갈 힘이 부족해요. | I’ve tried hard; my strength feels low. |
| loneliness   | 외로움      | Loneliness | 혼자 감당하는 느낌이 크고, 연결이 필요해요. | I feel alone and need connection. |
| hope         | 소망        | Hope       | 작은 빛이 보이고, 다시 걸어갈 수 있을 것 같아요. | A small light is there; I can keep going. |
| gratitude    | 감사        | Gratitude  | 오늘도 감사할 이유를 발견했어요. | I can name a reason to be thankful today. |
| grief        | 슬픔        | Grief      | 잃음/실망/상처가 마음에 남아 있어요. | Loss or disappointment still hurts. |
| confusion    | 혼란        | Confusion  | 방향이 흐릿하고, 분별이 필요해요. | I’m unsure; I need clarity and discernment. |
| joy          | 기쁨        | Joy        | 조용한 기쁨이 마음에 차오르고 있어요. | Quiet joy is rising in me. |

## 3) UI Rules (MVP)
### 3.1 Display
- Show emotions as **Choice Chips** (single select).
- Default selection: **none** (user must choose).
- A short helper line:  
  - KO: “지금 마음은 어떤가요?”  
  - EN: “How is your heart right now?”

### 3.2 Interaction
- Tap selects one emotion (toggle allowed).
- **Save** becomes enabled only after a selection.
- After Save: go to **Done** screen.

### 3.3 Optional Memo (MVP)
- Memo is optional; show after emotion selection.
- Limit: **1–2 sentences** or **max 160 chars** (per language).
- Placeholder:
  - KO: “한두 문장으로 남겨보세요 (선택)”  
  - EN: “Add 1–2 lines (optional)”

## 4) Analytics / Events (for Ops)
Track minimal events to avoid creepiness:
- `curation_viewed` (date, locale)
- `emotion_selected` (emotion_key, date, locale)
- `memo_added` (boolean only, not content)
- `checkin_completed` (date, locale)

## 5) Future Expansion (Not MVP)
- Emotion intensity (1–3)
- Multi-select or “secondary emotion”
- Custom emotion tags
- Time-of-day check-ins
