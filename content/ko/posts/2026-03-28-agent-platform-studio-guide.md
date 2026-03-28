---
title: "sideseat 에이전트 컨트롤 플레인 (Agent Control Plane) — Studio 웹 가이드"
title_alt: "sideseat Agent Control Plane — Studio Web Guide"
date: 2026-03-28
slug: agent-platform-studio-guide
tags: ["AI Agent", "Ontology", "sideseat", "Vite", "React", "guide"]
math: false
translationKey: agent-platform-studio-guide
---

**agent-platform-scaffolding**은 **sideseat**용 **에이전트 컨트롤 플레인 (Agent Control Plane)** 저장소다. 에이전트는 DB에 직접 붙지 않고, **온톨로지 (Ontology; Object·Link·Action)** 와 **역할 기반 툴 레지스트리 (role-based tool registry)**, **Worker API**(`WORKER_BASE_URL`)만 경유해 동작한다. **Think → Act → Observe** 루프와 함께, 아래에서 설명하는 **Vite + React Studio**에서 온톨로지(Ontology)와 워크플로(workflow)를 그래프로 설계·저장·실행 흐름까지 묶어 볼 수 있다.

## 저장소

<div class="link-bookmark">
  <a href="https://github.com/calicorone/agent-platform-scaffolding" target="_blank" rel="noopener noreferrer">agent-platform-scaffolding — GitHub</a>
  <div class="link-bookmark-url">https://github.com/calicorone/agent-platform-scaffolding</div>
  <p class="link-bookmark-meta">sideseat 에이전트 컨트롤 플레인 (Agent Control Plane) · Vite+React Studio · Docker 역할 (ops/backend/support)</p>
</div>

개념 정리(스캐폴딩(Scaffolding)·온톨로지(Ontology)·RAG 교차점)는 글 **[AI Agent 스캐폴딩과 온톨로지 구조 (Scaffolding & Ontology)](/2026/03/21/ai-agent-scaffolding-ontology/)**에서 이어진다.

---

## Studio 화면

왼쪽에 **sideseat CONTROL PLANE** 내비게이션, 가운데 **도트 그리드 캔버스**, 오른쪽에 **노드별 프로퍼티 패널**이 붙은 전형적인 “비주얼 IDE” 레이아웃이다. 상단에는 열린 프로젝트(**OPEN**), 이름(**NAME**), **Save / Execute / Demo / Delete**,보내기(**.export.json**, **.workflow.xml**), API **Bearer** 토큰 입력이 한 줄에 모여 있다.

<div class="hibiki-showcase">
  <img src="/images/agnet-homepage.png" alt="sideseat CONTROL PLANE — Studio 뷰: Ontology·Workflow 그래프, Meetup·Space·Link·Action·Agent·Deployed 노드" width="1200" height="800" loading="lazy" decoding="async">
  <p class="hibiki-showcase-caption">Studio — 온톨로지(Ontology) 객체·링크·액션(Object·Link·Action)과 워크플로(workflow)를 한 캔버스에서 연결한 예시 (로컬 개발 서버 기준 화면)</p>
</div>

스크린샷 중앙 그래프는 **Meetup** 생성 흐름을 보여 준다. 보라색 **OBJ Meetup**·**OBJ Space**, 파란 **LINK atPlace**(모임이 특정 공간에 열림), 노란 **Action: CreateMeetup**, **Agent** 노드, 마지막으로 녹색 **Deployed: sideseat** 타깃까지 이어진다. 오른쪽 패널은 선택된 **Object**의 타입명·설명·프로퍼티 목록(`id`, 제목, 시각, 정원 등)을 편집하는 형태다.

---

## 구성

저장소는 README와 폴더 구조를 기준으로 이해하면 된다. 대략적인 역할만 표로 정리한다(세부 경로·스크립트 이름은 클론 후 README를 따른다).

| 구역 | 설명 |
|------|------|
| **Studio (프론트)** | Vite + React — 노드 에디터, 온톨로지(Ontology)·워크플로(workflow) 시각화, 저장/실행/Demo·보내기 UI |
| **Worker / API 계층** | 에이전트 실행·툴 호출·플랫폼 정책이 실제로 도는 경로; `WORKER_BASE_URL` 등으로 연결 |
| **온톨로지 모델 (Ontology)** | Object Type / Link Type / Action — 스키마·관계·허용 변이 (governed mutation) 정의 |
| **Docker·역할** | `ops` / `backend` / `support` 등 역할별 정책으로 런타임·배포 경계를 나눔 |

---

## Studio UI 둘러보기

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

## 로컬에서 Studio 켜기

```bash
git clone https://github.com/calicorone/agent-platform-scaffolding.git
cd agent-platform-scaffolding
```

이후 **Studio 프론트** 디렉터리로 이동해 의존성을 설치하고 개발 서버를 띄운다. 정확한 폴더명·포트·환경 변수(`WORKER_BASE_URL`, Bearer 등)는 저장소 **README**와 `.env.example`(있다면)을 기준으로 맞춘다.

```bash
# 예시 — 실제 경로는 README 확인
cd <studio-or-web-directory>
npm install
npm run dev
```

브라우저에서 안내된 로컬 URL(예: Vite 기본 **http://localhost:5173**)로 접속한다. 프로덕션 빌드는 해당 패키지의 `npm run build`로 정적 산출물을 만든다.

---

## 아키텍처와 Studio의 연결

- **온톨로지 (Ontology)** 는 Palantir AIP식으로 넓게 보면 “에이전트가 공유하는 세계 모델 (shared world model)”에 해당한다. Studio의 **Object / Link / Action** 노드가 그 뼈대를 시각적으로 고정해 준다.
- **에이전트** 노드는 싱글턴·컨텍스트 프롬프팅 같은 텍스트 전략을 코드·템플릿으로 묶은 실행 단위로 이해할 수 있고, **Action**과의 연결은 “어떤 허용된 변이 뒤에 추론이 붙는가”를 드러낸다.
- **Think → Act → Observe** 루프는 Studio 밖의 런타임(Worker, Ollama·Anthropic 등 연동)에서 돌아가고, Studio는 그 전에 **그래프·스키마·워크플로契約**을 정리하는 설계 도구에 가깝다.

자세한 개념 정리는 [AI Agent 스캐폴딩과 온톨로지 구조 (Scaffolding & Ontology)](/2026/03/21/ai-agent-scaffolding-ontology/)를 참고한다.

---

## 기술 스택

- **프론트**: TypeScript, React, Vite  
- **런타임·배포**: Node.js, Docker, 역할 기반 정책  
- **모델·추론**: Ollama, Anthropic(Claude) 등 — 저장소 설정에 따름  
- **통합**: Worker API, 온톨로지(Ontology)·툴 레지스트리(tool registry) — 에이전트는 DB에 직접 붙지 않음

---

## 개발 메모

- `node_modules`는 저장소에 포함되지 않는 것이 일반적이다. 클론 후 Studio 패키지에서 `npm install`이 필요하다.
- Execute·Demo·보내기(**json** / **workflow.xml**)는 CI나 다른 환경으로 그래프를 옮길 때 유용하다.
- Bearer 토큰은 **원격 Worker**나 보호된 엔드포인트를 쓸 때만 주입하면 된다.

---

## 대상 독자

- sideseat·유사 제품에 **온톨로지(Ontology) 기반 에이전트**를 얹고 싶은 백엔드·플랫폼 엔지니어  
- “에이전트 스캐폴딩(Agent scaffolding)”이 코드만이 아니라 **UI로 어떻게 잡히는지** 보고 싶은 사람  
- [AI Agent 스캐폴딩과 온톨로지 구조 (Scaffolding & Ontology)](/2026/03/21/ai-agent-scaffolding-ontology/)를 읽고 **구현 화면**을 이어 붙이고 싶은 사람  

---

## 저장소·참고

- **개념 글**: [AI Agent 스캐폴딩과 온톨로지 구조 (Scaffolding & Ontology)](/2026/03/21/ai-agent-scaffolding-ontology/)  
- 비슷한 “웹으로 제품을 풀어 쓴” 형식의 글: [GPT-2 124M 빌드·학습을 도와주는 웹 가이드](/2026/03/19/hibiki-gpt2-124m-web-guide/) (hibiki)

---

Studio에서 그래프를 한 번 끝까지 연결해 본 뒤, Execute·export로 산출물을 확인하고 Worker 로그와 맞춰 보면 Think → Act → Observe가 코드·UI 어디에 대응하는지 빨리 잡힌다.
