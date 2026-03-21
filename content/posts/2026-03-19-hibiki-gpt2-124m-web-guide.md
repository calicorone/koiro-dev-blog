---
title: "GPT-2 124M 빌드·학습을 도와주는 웹 가이드"
date: 2026-03-19
slug: hibiki-gpt2-124m-web-guide
tags: ["GPT-2", "ML", "hibiki", "web", "guide"]
---

**hibiki**는 GPT-2 **124M**을 처음부터 구현·학습하는 저장소다. Andrej Karpathy의 GPT 재현·토크나이저 강의([Let’s reproduce GPT-2 (124M)](https://youtu.be/wjZofJX0v4M), [Let’s build the GPT Tokenizer](https://youtu.be/l8pRSuU81PU)) 흐름을 따르며, 학습 스크립트(`train_gpt2.py`)와 함께 **설정·시각화·개념 정리용 웹 UI**(`web/`)를 둔다.

---

## 홈 화면

다크 배경에 골드 악센트 버튼, Overview / Build / Visualization / Learn / Attention paper 내비게이션, **KO | EN** 토글이 한 화면에 모여 있다.

<div class="hibiki-showcase">
  <img src="/images/hibiki-homepage.png" alt="hibiki 웹 홈 — GPT-2 124M from scratch, Goals, Architecture 요약" width="1200" height="675" loading="lazy" decoding="async">
  <p class="hibiki-showcase-caption">hibiki 웹 UI — 로컬 <code>npm run dev</code> (Vite 기본 포트 5173)</p>
</div>

---

## 구성

| 경로 | 설명 |
|------|------|
| 프로젝트 루트 | `train_gpt2.py`, 모델·데이터·학습 로직 (Python 3.10+) |
| `web/` | Vite + React — 빌드 명령 생성, 파이프라인/아키텍처 시각화, 학습 가이드, Attention 논문 안내 |

---

## Python 환경

```bash
pip install -e .
# 선택: Hugging Face 체크포인트 검증 등
pip install -e ".[pretrained]"
```

학습 예시는 웹 **Build model** 페이지에서 모드·하이퍼파라미터를 고른 뒤 생성되는 명령을 복사하거나, 저장소의 `train_gpt2.py` 도움말을 참고하면 된다.

---

## 웹 UI (`web/`)

```bash
cd web
npm install
npm run dev
```

브라우저에서 **http://localhost:5173** — 프로덕션 정적 파일은 `npm run build` 후 `web/dist/`에 생성된다.

### 주요 화면

| 경로 | 내용 |
|------|------|
| `/` | 개요, 아키텍처·최적화 요약, 빠른 시작 |
| `/build` | 학습 모드·하이퍼파라미터 → 터미널에 붙여 넣을 명령 생성 |
| `/viz` | 학습 파이프라인, GPT-2 블록 다이어그램, 핵심 4구성(임베딩·어텐션·MLP·언임베딩), 토큰화(인터랙티브 BPE·YouTube 참고) |
| `/learn` | 구현·학습 개념을 단계별로 정리 |
| `/attention-is-all-you-need` | [Attention Is All You Need](https://arxiv.org/abs/1706.03762) 요약, KaTeX 수식·SVG 도식, 시각화 탭의 어텐션 그리드로 연결 |

언어 전환은 헤더의 **KO / EN** 토글이다.

### 기능 요약 (기존 상세)

- **Build**: overfit / pretrained / train 모드와 하이퍼파라미터 → `train_gpt2.py`용 명령·설명 한 줄씩.
- **Learn**: 1장~8장·부록 형태로 배치, 시퀀스, Pre-LN, 손실, 역전파, AdamW 등.
- **Visualization**: 파이프라인 카드, 12블록 구조, **토큰화** 탭(BPE·encode/decode 다이어그램, 강의 챕터 링크).

---

## 기술 스택

- **프론트**: React 18, TypeScript, Vite, React Router  
- **스타일**: CSS 변수, 다크 톤(홈·전역 테마)  
- **언어**: 자체 i18n(ko/en), `localStorage`에 언어 저장  

백엔드는 없고 학습은 로컬에서 `train_gpt2.py`로 실행한다.

---

## 개발 메모

- `web/node_modules`는 저장소에 포함하지 않는다. 클론 후 `cd web && npm install` 필요.
- `.cursorrules`에 Pre-LN, weight tying, Flash Attention 등 모델·코딩 가이드가 정리되어 있다.

---

## 대상 독자

- GPT-2 124M을 처음부터 구현·학습해 보고 싶은 사람  
- 학습률·배치·gradient accumulation을 막 쓰기 시작한 사람  
- 빌드 옵션이나 Learn 용어가 낯선 사람  

---

## 저장소·참고

- **GitHub**: [github.com/calicorone/hibiki](https://github.com/calicorone/hibiki)  
- [nanoGPT](https://github.com/karpathy/nanoGPT)  

---

## 참고 영상

Karpathy 강의와 hibiki 흐름을 같이 보면 이해가 빠르다.

<div class="video-embed">
<iframe src="https://www.youtube.com/embed/wjZofJX0v4M" title="YouTube — Let’s reproduce GPT-2 (124M)" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen loading="lazy"></iframe>
</div>

<p class="video-caption"><a href="https://youtu.be/wjZofJX0v4M" target="_blank" rel="noopener noreferrer">Let’s reproduce GPT-2 (124M)</a> — YouTube</p>

<div class="video-embed">
<iframe src="https://www.youtube.com/embed/l8pRSuU81PU" title="YouTube — Let’s build the GPT Tokenizer" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen loading="lazy"></iframe>
</div>

<p class="video-caption"><a href="https://youtu.be/l8pRSuU81PU" target="_blank" rel="noopener noreferrer">Let’s build the GPT Tokenizer</a> — YouTube</p>

---

명령어나 개념이 부담되면 **Build → Learn → Visualization** 순으로 hibiki 웹을 따라가 보길 권한다. 팀과 공유할 때는 한·영 토글로 맞춰 두면 된다.
