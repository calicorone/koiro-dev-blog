---
title: "Agent Control Plane — Studio 웹 가이드"
title_alt: "Agent Control Plane — Studio Web Guide"
date: 2026-03-28
slug: agent-platform-studio-guide
tags: ["AI Agent", "Ontology", "sideseat", "Vite", "React", "guide"]
math: false
translationKey: agent-platform-studio-guide
---

**agent-control-plane**은 **sideseat**용 **에이전트 컨트롤 플레인 (Agent Control Plane)** 오픈 소스 저장소다. 에이전트는 DB에 직접 붙지 않고, **온톨로지(Ontology; Object·Link·Action)** 와 **역할 기반 툴 레지스트리 (role-based tool registry)**, **Worker API**(`WORKER_BASE_URL`)만 경유해 동작한다. **Think → Act → Observe** 루프와 함께, 아래에서 설명하는 **Vite + React Studio**에서 온톨로지(Ontology)와 워크플로(workflow)를 그래프로 설계·저장·실행 흐름까지 묶어 볼 수 있다.

**읽는 순서 제안**: 온톨로지·스캐폴딩 개념은 [AI Agent 스캐폴딩과 온톨로지 구조 (Scaffolding & Ontology)](/2026/03/21/ai-agent-scaffolding-ontology/)를 먼저 본 뒤 이 글의 UI 설명을 이어가면 맥락이 잡힌다. 폴더 경로·환경 변수는 반드시 저장소 **README**를 따른다.

## 목차 {#toc}

- [저장소](#repo) · [Studio 화면](#studio-view) · [구성](#layout) · [Studio UI 둘러보기](#ui-tour)
- [로컬 실행](#local-run) · [아키텍처 연결](#architecture) · [기술 스택](#stack) · [개발 메모](#dev-notes) · [대상 독자](#audience) · [참고](#refs)

## 저장소 {#repo}

<div class="link-bookmark">
  <a href="https://github.com/calicorone/agent-control-plane" target="_blank" rel="noopener noreferrer">agent-control-plane — GitHub</a>
  <div class="link-bookmark-url">https://github.com/calicorone/agent-control-plane</div>
  <p class="link-bookmark-meta">sideseat 에이전트 컨트롤 플레인 (Agent Control Plane) · Vite+React Studio · Docker 역할 (ops/backend/support)</p>
</div>

개념 정리(스캐폴딩(Scaffolding)·온톨로지(Ontology)·RAG 교차점)는 글 **[AI Agent 스캐폴딩과 온톨로지 구조 (Scaffolding & Ontology)](/2026/03/21/ai-agent-scaffolding-ontology/)**에서 이어진다.

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
  <p class="hibiki-showcase-caption">로컬 개발 서버 기준 화면. Object·Link·Action 온톨로지와 workflow를 한 캔버스에 묶은 예시다.</p>
</div>

캔버스 중앙은 Meetup을 만드는 흐름을 보여 준다.

- 보라색 Object 노드: `Meetup`, `Space`  
- 파란 Link: `atPlace` (모임이 특정 공간에서 열림)  
- 노란 Action: `CreateMeetup`  
- Agent 노드  
- 녹색 Deployed 타깃: `sideseat`  

오른쪽 패널에서는 선택한 Object의 타입명, 설명, 프로퍼티(`id`, 제목, 시각, 정원 등)를 편집한다.

</div>

---

## 구성 {#layout}

저장소는 README와 폴더 구조를 기준으로 이해하면 된다. 대략적인 역할만 표로 정리한다(세부 경로·스크립트 이름은 클론 후 README를 따른다).

| 구역 | 설명 |
|------|------|
| **Studio (프론트)** | `platform-web`(Vite + React) — 노드 에디터, 온톨로지(Ontology)·워크플로(workflow) 시각화, 저장/실행/Demo·보내기 UI |
| **Worker / API 계층** | 에이전트 실행·툴 호출·플랫폼 정책이 실제로 도는 경로; `WORKER_BASE_URL` 등으로 연결 |
| **온톨로지 모델 (Ontology)** | Object Type / Link Type / Action — 스키마·관계·허용 변이 (governed mutation) 정의 |
| **Docker·역할** | `ops` / `backend` / `support` 등 역할별 정책으로 런타임·배포 경계를 나눔 |

---

## Studio UI 둘러보기 {#ui-tour}

### 왼쪽 내비게이션

- **Studio** — 현재 화면과 같은 비주얼 편집기.
- **Agents** — 구성해 둔 LLM 에이전트 목록·관리(저장소 버전에 따라 세부 UI는 다를 수 있음).
- **Overview** — 대시보드·요약 뷰.
- **Docs** — 플랫폼 문서 진입점.

### 왼쪽 팔레트 (드래그 소스)

| 섹션 | 노드 유형 | 역할 |
|------|-----------|------|
| **ONTOLOGY** | Object Type | 타입 스키마·프로퍼티 정의 |
| | Link Type | 객체 간 방향 관계 |
| | Action | API/업데이트 등 **거버넌스가 걸린** 변이 |
| **WORKFLOW** | Start, Dataset, Stream / Transform | 파이프라인 입·중간 처리 |
| | + Agent | 특정 태스크 템플릿을 가진 LLM 에이전트 블록 |
| **TARGETS** | Deployed app, Notify | 배포 대상(예: sideseat)·알림/웹훅 스텁 |

### 캔버스

그리드 위에 노드를 놓고 **엣지로 연결**한다. 온톨로지(Ontology) 그래프(무엇이 무엇과 어떻게 연결되는가)와 실행 흐름(액션 이후 에이전트, 배포 타깃)을 한 눈에 맞출 수 있다.

### 오른쪽 프로퍼티 패널

선택한 노드의 메타데이터(이름, 라벨/별칭, 설명, 프로퍼티 행 추가 등)를 편집한다. Object를 고르면 스크린샷처럼 **PROPERTIES — OBJECT** 헤더 아래 필드가 채워진다.

---

## 로컬에서 Studio 켜기 {#local-run}

```bash
git clone https://github.com/calicorone/agent-control-plane.git
cd agent-control-plane
cp .env.example .env   # WORKER_BASE_URL 등 설정
npm install
```

플랫폼 UI(Studio·Agents 등)는 저장소 **README** 기준으로 예를 들어 `npm run platform` 후 **http://localhost:3010** 에서 연다. Vite 핫 리로드는 `PLATFORM_API_ONLY=1 npm run platform`과 별도 터미널에서 `cd platform-web && npm install && npm run dev` 조합을 쓴다. 세부 포트·스크립트는 **README**·`docs/LOCAL_SETUP.md`를 따른다.

---

## 아키텍처와 Studio의 연결 {#architecture}

- **온톨로지 (Ontology)** 는 Palantir **AIP**(*Artificial Intelligence Platform*, 기업용 데이터·온톨로지 중심 스택)을 참고한 말로, 넓게는 “에이전트가 공유하는 세계 모델 (shared world model)”에 해당한다. Studio의 **Object / Link / Action** 노드가 그 뼈대를 시각적으로 고정해 준다.
- **에이전트** 노드는 싱글턴·컨텍스트 프롬프팅(singleton / contextual prompting) 같은 텍스트 전략을 코드·템플릿으로 묶은 실행 단위로 이해할 수 있고, **Action**과의 연결은 “어떤 허용된 변이 뒤에 추론이 붙는가”를 드러낸다.
- **Think → Act → Observe** 루프는 Studio 밖의 런타임(Worker, Ollama·Anthropic 등 연동)에서 돌아가고, Studio는 그 이전 단계에서 **그래프·스키마·워크플로 계약(contract)**을 정리해 두는 설계 도구에 가깝다.
- 운영 측면에서는 **허용된 Action만** Worker·툴 레지스트리를 통해 실행되도록 경계를 두는 것이 기본 전제다(DB 직접 접근 없음과 같은 맥락).

자세한 개념 정리는 [AI Agent 스캐폴딩과 온톨로지 구조 (Scaffolding & Ontology)](/2026/03/21/ai-agent-scaffolding-ontology/)를 참고한다.

---

## 기술 스택 {#stack}

- **프론트**: TypeScript, React, Vite  
- **런타임·배포**: Node.js, Docker, 역할 기반 정책  
- **모델·추론**: Ollama, Anthropic(Claude) 등 — 저장소 설정에 따름  
- **통합**: Worker API, 온톨로지(Ontology)·툴 레지스트리(tool registry) — 에이전트는 DB에 직접 붙지 않음

---

## 개발 메모 {#dev-notes}

- `node_modules`는 저장소에 포함되지 않는 것이 일반적이다. 클론 후 Studio 패키지에서 `npm install`이 필요하다.
- Execute·Demo·보내기(**json** / **workflow.xml**)는 CI나 다른 환경으로 그래프를 옮길 때 유용하다.
- Bearer 토큰은 **원격 Worker**나 보호된 엔드포인트를 쓸 때만 주입하면 된다.
- 이 글의 스크린샷은 `static/images/agnet-homepage.png`를 쓴다(파일명은 기존 자산 경로 그대로이며, 필요하면 `agent-homepage.png` 등으로 바꾼 뒤 본문·배포 경로를 같이 맞추면 된다).

---

## 대상 독자 {#audience}

- sideseat·유사 제품에 **온톨로지(Ontology) 기반 에이전트**를 얹고 싶은 백엔드·플랫폼 엔지니어  
- “에이전트 스캐폴딩(Agent scaffolding)”이 코드만이 아니라 **UI로 어떻게 잡히는지** 보고 싶은 사람  
- [AI Agent 스캐폴딩과 온톨로지 구조 (Scaffolding & Ontology)](/2026/03/21/ai-agent-scaffolding-ontology/)를 읽고 **구현 화면**을 이어 붙이고 싶은 사람  

---

## 저장소·참고 {#refs}

- **개념 글**: [AI Agent 스캐폴딩과 온톨로지 구조 (Scaffolding & Ontology)](/2026/03/21/ai-agent-scaffolding-ontology/)  
- 비슷한 “웹으로 제품을 풀어 쓴” 형식의 글: [GPT-2 124M 빌드·학습을 도와주는 웹 가이드](/2026/03/19/hibiki-gpt2-124m-web-guide/) (hibiki)

---

Studio에서 그래프를 한 번 끝까지 연결해 본 뒤, Execute·export로 산출물을 확인하고 Worker 로그와 맞춰 보면 Think → Act → Observe가 코드·UI 어디에 대응하는지 빨리 잡힌다.
