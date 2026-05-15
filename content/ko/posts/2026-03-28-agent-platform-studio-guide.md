---
title: "Agent Control Plane — Studio 웹 가이드"
title_alt: "Studio Web Guide (agent-control-plane)"
date: 2026-03-28
slug: agent-platform-studio-guide
tags: ["AI Agent", "Ontology", "sideseat", "Vite", "React", "guide"]
math: false
translationKey: agent-platform-studio-guide
deep_guide: true
---

<div class="studio-deep-guide">

<div class="studio-deep-banner">
  <p class="studio-deep-kicker">Technical guide</p>
  <p class="studio-deep-tagline">싱글턴·컨텍스트 프롬프팅, 서브/스킬 에이전트, Ontology 레이어 같은 개념은 <a href="/2026/03/21/ai-agent-scaffolding-ontology/">온톨로지 글</a>에서 정리해 두었고, 여기서는 <strong>agent-control-plane</strong>의 <strong>Studio UI</strong>에 초점을 맞춘다.</p>
  <div class="studio-deep-pills">
    <span>Vite</span>
    <span>React</span>
    <span>Ontology</span>
    <span>Worker API</span>
  </div>
</div>

<p class="studio-deep-lead"><strong>agent-control-plane</strong>은 sideseat용 오픈 소스 컨트롤 플레인이다. 에이전트는 DB에 직접 붙지 않고 <code>WORKER_BASE_URL</code>·툴 레지스트리를 경유하고, Studio에서 Object·Link·Action과 워크플로를 그래프로 설계·저장·보낸다. 폴더·환경 변수는 저장소 <strong>README</strong>를 따른다.</p>

## 목차 {#toc}

- [저장소 · 스택](#repo) · [Studio 화면](#studio-view) · [UI 둘러보기](#ui-tour)
- [로컬 실행](#local-run) · [아키텍처](#architecture) · [개발 메모](#dev-notes) · [참고](#refs)

<div class="studio-deep-part">
  <span class="studio-deep-part-num" aria-hidden="true">01</span>
  <div class="studio-deep-part-head">
    <div class="studio-deep-kicker-small">Part 1</div>
    <h2 id="repo">저장소와 런타임 스택</h2>
  </div>
</div>

<div class="studio-deep-stack">
  <div class="studio-deep-stack-titlebar">
    <span class="dot dot--r" aria-hidden="true"></span>
    <span class="dot dot--y" aria-hidden="true"></span>
    <span class="dot dot--g" aria-hidden="true"></span>
    <span class="studio-deep-stack-label">Studio ↔ Ontology ↔ Worker (요약)</span>
  </div>
  <div class="studio-deep-stack-body">
    <div class="studio-deep-layer studio-deep-layer--products">
      <span class="layer-label">제품·워크플로</span>
      <span class="layer-desc">실행 결과·자동화 파이프라인 — Studio에서 정의한 그래프·계약이 여기로 이어짐</span>
    </div>
    <div class="studio-deep-flow" aria-hidden="true">⇅</div>
    <div class="studio-deep-layer studio-deep-layer--studio">
      <span class="layer-label">★ Studio — platform-web</span>
      <span class="layer-desc">노드 에디터 · Object / Link / Action · 워크플로 시각화 · Save / Execute / Demo / export</span>
    </div>
    <div class="studio-deep-flow" aria-hidden="true">⇅</div>
    <div class="studio-deep-grid3">
      <div class="studio-deep-layer studio-deep-layer--worker">
        <span class="layer-label">Worker / API</span>
        <span class="layer-desc">Think → Act → Observe · 툴 호출 · 정책</span>
      </div>
      <div class="studio-deep-layer studio-deep-layer--worker">
        <span class="layer-label">온톨로지 계약</span>
        <span class="layer-desc">스키마·링크·허용 Action — 그래프로 고정</span>
      </div>
      <div class="studio-deep-layer studio-deep-layer--worker">
        <span class="layer-label">Docker 역할</span>
        <span class="layer-desc">ops / backend / support 경계</span>
      </div>
    </div>
    <div class="studio-deep-flow" aria-hidden="true">⇅</div>
    <div class="studio-deep-layer studio-deep-layer--gov">
      <span class="layer-label">거버넌스</span>
      <span class="layer-desc">허용된 Action만 Worker·레지스트리로 — DB 직접 접근 없음과 같은 전제</span>
    </div>
  </div>
</div>

<div class="studio-deep-callout">
  오케스트레이터·서브에이전트·스킬 에이전트가 Ontology를 참조하는 방식은, 레이어 다이어그램으로 풀어 쓴 장문 가이드와 같은 축이다. 여기서는 그 <strong>계약을 UI에 박아 두는 도구</strong>가 Studio라고 보면 된다.
</div>

<div class="link-bookmark">
  <a href="https://github.com/calicorone/agent-control-plane" target="_blank" rel="noopener noreferrer">agent-control-plane — GitHub</a>
  <div class="link-bookmark-url">https://github.com/calicorone/agent-control-plane</div>
  <p class="link-bookmark-meta">Vite+React Studio · Docker 역할 (ops/backend/support)</p>
</div>

<div class="studio-deep-part">
  <span class="studio-deep-part-num" aria-hidden="true">02</span>
  <div class="studio-deep-part-head">
    <div class="studio-deep-kicker-small">Part 2</div>
    <h2 id="studio-view">Studio 화면</h2>
  </div>
</div>

<div class="studio-prose">

전형적인 비주얼 IDE 배치다.

- 왼쪽: sideseat CONTROL PLANE 내비게이션  
- 가운데: 도트 그리드 캔버스  
- 오른쪽: 노드별 프로퍼티 패널  

상단 바에는 `OPEN`, `NAME`, Save / Execute / Demo / Delete, 보내기(`.export.json`, `.workflow.xml`), API Bearer 토큰 입력이 한 줄에 붙어 있다.

<div class="hibiki-showcase">
  <img src="/images/agent-homepage.png" alt="sideseat CONTROL PLANE — Studio 뷰: Ontology·Workflow 그래프, Meetup·Space·Link·Action·Agent·Deployed 노드" width="1200" height="800" loading="lazy" decoding="async">
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

<div class="studio-deep-part">
  <span class="studio-deep-part-num" aria-hidden="true">03</span>
  <div class="studio-deep-part-head">
    <div class="studio-deep-kicker-small">Part 3</div>
    <h2 id="layout">구성 · UI 둘러보기</h2>
  </div>
</div>

### 구성 {#layout}

| 구역 | 설명 |
|------|------|
| **Studio** | `platform-web` — 노드 에디터, 온톨로지·워크플로 시각화, 저장/실행/Demo·보내기 |
| **Worker / API** | 실행·툴 호출·정책; `WORKER_BASE_URL` 등으로 연결 |
| **온톨로지** | Object Type / Link Type / Action — 스키마·관계·허용 변이 |
| **Docker** | `ops` / `backend` / `support` 등 역할별 런타임·배포 경계 |

### Studio UI 둘러보기 {#ui-tour}

#### 왼쪽 내비게이션

- **Studio** — 비주얼 편집기 (이 화면)
- **Agents** — 구성된 LLM 에이전트 (버전에 따라 UI 상이)
- **Overview** — 대시보드
- **Docs** — 문서 진입점

#### 팔레트

| 섹션 | 노드 | 역할 |
|------|------|------|
| **ONTOLOGY** | Object Type, Link Type, Action | 스키마·관계·거버넌스 변이 |
| **WORKFLOW** | Start, Dataset, Stream/Transform, Agent | 파이프라인 + LLM 블록 |
| **TARGETS** | Deployed app, Notify | 배포 대상·알림/웹훅 |

#### 캔버스·프로퍼티

노드를 **엣지**로 연결한다. 오른쪽 패널은 선택 노드 메타데이터(**PROPERTIES — OBJECT** 등)를 편집한다.

<div class="studio-deep-part">
  <span class="studio-deep-part-num" aria-hidden="true">04</span>
  <div class="studio-deep-part-head">
    <div class="studio-deep-kicker-small">Part 4</div>
    <h2 id="closing">로컬 · 아키텍처 · 마무리</h2>
  </div>
</div>

### 로컬에서 Studio 켜기 {#local-run}

```bash
git clone https://github.com/calicorone/agent-control-plane.git
cd agent-control-plane
cp .env.example .env   # WORKER_BASE_URL 등
npm install
```

UI는 **README** 기준(예: `npm run platform` → **http://localhost:3010**). Vite HMR은 `PLATFORM_API_ONLY=1 npm run platform`과 별도 터미널에서 `cd platform-web && npm run dev`. 포트·스크립트는 **README**·`docs/LOCAL_SETUP.md` 참고.

### 아키텍처 한 줄 {#architecture}

<div class="studio-deep-terminal">
  <div class="studio-deep-stack-titlebar">
    <span class="dot dot--r" aria-hidden="true"></span>
    <span class="dot dot--y" aria-hidden="true"></span>
    <span class="dot dot--g" aria-hidden="true"></span>
    <span class="studio-deep-stack-label">contract vs runtime</span>
  </div>
  <pre>Studio          → 그래프·스키마·워크플로 <strong>계약</strong> 편집
Worker / 모델    → Think → Act → Observe <strong>실행</strong>
공통 언어        → Object · Link · Action (온톨로지 글 참고)</pre>
</div>

**스택(요약)**: TypeScript·React·Vite(프론트), Node·Docker(런타임/배포), Ollama·Anthropic 등(저장소 설정에 따름).

### 개발 메모 {#dev-notes}

- 클론 후 `npm install` 필요.
- Execute·보내기(json / workflow.xml)는 환경 간 그래프 이전에 유용.
- Bearer 토큰은 원격 Worker·보호 엔드포인트용.
- 스크린샷: `static/images/agent-homepage.png`(기존 파일명).

### 참고 {#refs}

- [AI Agent 스캐폴딩과 온톨로지](/2026/03/21/ai-agent-scaffolding-ontology/)
- 웹 가이드 형식 참고: [GPT-2 124M 빌드·학습 가이드](/2026/03/19/hibiki-gpt2-124m-web-guide/) (hibiki)

<div class="studio-deep-outro">
  <p class="outro-kicker">한 줄로</p>
  <p>그래프를 끝까지 연결한 뒤 Execute·export로 산출물을 보고 Worker 로그와 맞추면, 루프가 코드·UI 어디에 붙는지 빨리 잡힌다.</p>
</div>

</div>
