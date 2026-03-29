---
title: "Agent Control Plane — Studio 웹 가이드"
title_alt: "Studio Web Guide (agent-control-plane)"
date: 2026-03-28
slug: agent-platform-studio-guide
tags: ["AI Agent", "Ontology", "sideseat", "Vite", "React", "guide"]
math: false
translationKey: agent-platform-studio-guide
---

**agent-control-plane**은 sideseat용 오픈 소스 컨트롤 플레인 저장소다. 에이전트는 DB에 직접 붙지 않고 Worker API(`WORKER_BASE_URL`)와 툴 레지스트리를 통해 동작하며, Studio(Vite + React)에서 Object·Link·Action과 워크플로를 그래프로 다룬다. 온톨로지·스캐폴딩 개념은 [AI Agent 스캐폴딩과 온톨로지](/2026/03/21/ai-agent-scaffolding-ontology/)를 먼저 보면 이 글의 UI 설명이 이어진다. 경로·환경 변수는 저장소 **README**를 따른다.

## 목차 {#toc}

- [저장소](#repo) · [Studio 화면](#studio-view) · [구성](#layout) · [Studio UI 둘러보기](#ui-tour)
- [로컬 실행](#local-run) · [아키텍처](#architecture) · [개발 메모](#dev-notes) · [참고](#refs)

## 저장소 {#repo}

<div class="link-bookmark">
  <a href="https://github.com/calicorone/agent-control-plane" target="_blank" rel="noopener noreferrer">agent-control-plane — GitHub</a>
  <div class="link-bookmark-url">https://github.com/calicorone/agent-control-plane</div>
  <p class="link-bookmark-meta">Vite+React Studio · Docker 역할 (ops/backend/support)</p>
</div>

---

## Studio 화면 {#studio-view}

<div class="studio-prose">

전형적인 비주얼 IDE 배치다.

- 왼쪽: sideseat CONTROL PLANE 내비게이션  
- 가운데: 도트 그리드 캔버스  
- 오른쪽: 노드별 프로퍼티 패널  

상단 바에는 `OPEN`, `NAME`, Save / Execute / Demo / Delete, 보내기(`.export.json`, `.workflow.xml`), API Bearer 토큰 입력이 한 줄에 붙어 있다.

<div class="hibiki-showcase">
  <img src="/images/agnet-homepage.png" alt="sideseat CONTROL PLANE — Studio 뷰: Ontology·Workflow 그래프, Meetup·Space·Link·Action·Agent·Deployed 노드" width="1200" height="800" loading="lazy" decoding="async">
  <p class="hibiki-showcase-caption">로컬 개발 서버 기준. Object·Link·Action과 workflow를 한 캔버스에 묶은 예시.</p>
</div>

캔버스 중앙은 Meetup 생성 예시다.

- 보라색 Object: `Meetup`, `Space`  
- 파란 Link: `atPlace`  
- 노란 Action: `CreateMeetup`  
- Agent 노드  
- 녹색 Deployed: `sideseat`  

오른쪽 패널에서 선택한 Object의 타입명·설명·프로퍼티(`id`, 제목, 시각, 정원 등)를 편집한다.

</div>

---

## 구성 {#layout}

| 구역 | 설명 |
|------|------|
| **Studio** | `platform-web` — 노드 에디터, 온톨로지·워크플로 시각화, 저장/실행/Demo·보내기 |
| **Worker / API** | 실행·툴 호출·정책; `WORKER_BASE_URL` 등으로 연결 |
| **온톨로지** | Object Type / Link Type / Action — 스키마·관계·허용 변이 |
| **Docker** | `ops` / `backend` / `support` 등 역할별 런타임·배포 경계 |

---

## Studio UI 둘러보기 {#ui-tour}

### 왼쪽 내비게이션

- **Studio** — 비주얼 편집기 (이 화면)
- **Agents** — 구성된 LLM 에이전트 (버전에 따라 UI 상이)
- **Overview** — 대시보드
- **Docs** — 문서 진입점

### 팔레트

| 섹션 | 노드 | 역할 |
|------|------|------|
| **ONTOLOGY** | Object Type, Link Type, Action | 스키마·관계·거버넌스 변이 |
| **WORKFLOW** | Start, Dataset, Stream/Transform, Agent | 파이프라인 + LLM 블록 |
| **TARGETS** | Deployed app, Notify | 배포 대상·알림/웹훅 |

### 캔버스·프로퍼티

노드를 **엣지**로 연결한다. 오른쪽 패널은 선택 노드 메타데이터(**PROPERTIES — OBJECT** 등)를 편집한다.

---

## 로컬에서 Studio 켜기 {#local-run}

```bash
git clone https://github.com/calicorone/agent-control-plane.git
cd agent-control-plane
cp .env.example .env   # WORKER_BASE_URL 등
npm install
```

UI는 **README** 기준(예: `npm run platform` → **http://localhost:3010**). Vite HMR은 `PLATFORM_API_ONLY=1 npm run platform`과 별도 터미널에서 `cd platform-web && npm run dev`. 포트·스크립트는 **README**·`docs/LOCAL_SETUP.md` 참고.

---

## 아키텍처 한 줄 {#architecture}

Studio의 **Object / Link / Action**은 에이전트가 공유하는 세계 모델을 UI에 고정해 준다. **Think → Act → Observe**는 Worker·모델 쪽 런타임에서 돌고, Studio는 그에 앞서 그래프·스키마·워크플로 **계약**을 잡는 편집기에 가깝다. 이론·용어는 [온톨로지 글](/2026/03/21/ai-agent-scaffolding-ontology/)로 넘긴다.

**스택(요약)**: TypeScript·React·Vite(프론트), Node·Docker(런타임/배포), Ollama·Anthropic 등(저장소 설정에 따름).

---

## 개발 메모 {#dev-notes}

- 클론 후 `npm install` 필요.
- Execute·보내기(json / workflow.xml)는 환경 간 그래프 이전에 유용.
- Bearer 토큰은 원격 Worker·보호 엔드포인트용.
- 스크린샷: `static/images/agnet-homepage.png`(기존 파일명).

---

## 참고 {#refs}

- [AI Agent 스캐폴딩과 온톨로지](/2026/03/21/ai-agent-scaffolding-ontology/)
- 비슷한 웹 가이드 형식: [GPT-2 124M 빌드·학습 가이드](/2026/03/19/hibiki-gpt2-124m-web-guide/) (hibiki)

그래프를 한 번 끝까지 연결한 뒤 Execute·export로 산출물을 확인하고 Worker 로그와 맞춰 보면 루프가 코드·UI 어디에 붙는지 빨리 보인다.
