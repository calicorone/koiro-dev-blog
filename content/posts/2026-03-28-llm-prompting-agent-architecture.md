---
layout: post
title: "LLM 프롬프팅 & 에이전트 아키텍처 완전 정리"
date: 2026-03-28
slug: llm-prompting-agent-architecture
author: Ahhyun Kim
tags: ["LLM", "Prompting", "Agent", "Architecture", "Ontology", "LangChain", "MCP", "Palantir AIP"]
read_time: "25 min"
---

**Technical deep-dive.** 싱글턴 · 컨텍스트 · 서브에이전트 · 스킬에이전트 · 오케스트레이터 · Ontology Layer — Palantir AIP 구조를 참조한 설계 관점의 통합 정리.

---

## 목차

1. [전체 아키텍처 구조도](#전체-아키텍처-구조도)
2. [싱글턴 프롬프팅](#싱글턴-프롬프팅)
3. [컨텍스트 프롬프팅](#컨텍스트-프롬프팅)
4. [에이전트 아키텍처](#에이전트-아키텍처-개념)
5. [Ontology Layer](#ontology-layer)
6. [서브에이전트](#서브에이전트-sub-agent)
7. [스킬 에이전트](#스킬-에이전트-skill-agent)
8. [구현 패턴 & 설계 원칙](#구현-패턴)
9. [실패 패턴 & 결론](#자주-생기는-실패-패턴)

---

## 전체 아키텍처 구조도

### Palantir AIP 참조 아키텍처

**LLM System Architecture — Ontology-Centered Design**

| 레이어 | 역할 |
|--------|------|
| **AI Products Layer** | Prebuilt / Custom AI Products → 사용자가 접하는 최종 제품 |
| **Ontology Layer ★** | Object · Relation · Action → 모든 에이전트가 공유하는 세계 모델 |
| **Data Services** | RAG · Vector DB · External DB · API · Memory |
| **AI Services** | Sub-Agent · Skill Agent · LLM 추론 · Embedding · 분류 |
| **Workflow Services** | Orchestrator · Pipeline · Task Routing · 알림 발송 |
| **Security & Governance** | 접근 제어 · 감사 로그 · 정책 · 권한 → Ontology Action 범위 검증 |
| **Software Delivery** | 배포 · 버전 관리 · 인프라 · 모니터링 |

> 핵심: 오케스트레이터는 Ontology Layer를 기준으로 요청을 해석하고 라우팅한다. 서브에이전트는 Object·Relation을 참조해 사고하고, 스킬에이전트는 Action 정의에 따라 실행한다.

---

## Part 1 — 싱글턴 vs 컨텍스트

### 개요

| 항목 | 싱글턴 프롬프팅 | 컨텍스트 프롬프팅 |
|------|------------------|-------------------|
| 방식 | 하나의 독립 입력으로 완결된 응답 | 이전 대화·상태·추가 정보를 누적 |
| 상태 | Stateless | Stateful-like |
| 재현성 | 높음 | 낮음 / 유연성 높음 |
| Ontology | 프롬프트 내 명시적 정의 | 공유 컨텍스트로 지속 참조 |

### 싱글턴 프롬프팅

하나의 프롬프트에 필요한 정보를 모두 넣어 **단일 요청으로 결과**를 내는 방식. 입력·출력 1:1, 이전 대화·상태 미고려.

**장점**

- 명확성, 재현성, 디버깅 용이, API 단발 요청에 유리

**단점**

- 긴 입력, 복잡 작업에서 비효율, 상태 유지 불가

**실무형 템플릿**

```text
[Role]
너는 B2B SaaS 분석가다.

[Task]
다음 제품 소개서를 읽고 핵심 가치제안을 정리하라.

[Constraints]
- 5개 bullet 이내
- 마케팅 문구보다 실제 기능 중심
- 추정은 명시적으로 표시

[Output Format]
{
  "product_name": "",
  "target_customer": "",
  "core_value_props": []
}

[Input]
...
```

> 핵심 구성: **Role + Task + Constraints + Output Format** — 한 번에 끝낸다.

**싱글턴으로 처리하기 어려운 예**

- 첨부 다수 비교 + 리스크 + 누락 체크
- 최신 동향 조사 후 전략안
- 코드베이스 읽고 버그 추론·수정안

### 컨텍스트 프롬프팅

이전 대화·시스템 지시·외부 정보를 포함해 **맥락을 누적**하며 응답. 실질적으로 **상태 기반 추론**에 가깝다.

**컨텍스트에 자주 포함되는 것**

- 시스템 프롬프트, 대화 히스토리, 사용자 선호
- **Ontology: 객체·관계·허용 행동**
- 도구 실행 결과, 검색·초안, 메모리, 워크플로 상태

> 실무에서는 컨텍스트를 무조건 쌓지 않고 **선별적으로 압축·요약·리셋**(Context Pruning).

### 핵심 비교

| 항목 | 싱글턴 | 컨텍스트 |
|------|--------|----------|
| 구조 | 단일 요청 | 다중 턴 |
| 상태 | 없음 | 있음 |
| 재현성 | 높음 | 낮음 |
| 복잡도 대응 | 낮음 | 높음 |
| 디버깅 | 쉬움 | 어려움 |
| 토큰 | 상대적 효율 | 누적 |
| Ontology | 프롬프트 내 명시 | 공유 컨텍스트 |
| 대표 용도 | 단순 작업·파이프라인 | 대화형·복잡 작업·개인화 |

---

## Part 2 — 에이전트 아키텍처 개념

### Ontology Layer

에이전트가 세계를 이해하는 **공통 언어**. 스키마만이 아니라 **관계와 허용 행동**까지 포함한다.

```text
# Ontology = Object + Relation + Action

Object:   고객, 주문, 제품, 설비, 직원
Relation: 고객 → 주문 (생성), 주문 → 제품 (포함), 설비 → 담당직원 (배정)
Action:   분석 가능, 승인 가능, 알림 발송 가능
          # 수정/삭제는 허용 범위 외일 수 있음
```

**Ontology 없을 때**

- 에이전트마다 "고객" 정의가 달라짐, 구조 불일치, 비허용 행동 시도, 통합 시 충돌

**Ontology 있을 때**

- 동일 객체 정의 공유, 인터페이스 정합, Action에 Governance, 오케스트레이터가 Ontology 기준 라우팅

> 서브에이전트는 **Object·Relation**으로 사고하고, 스킬에이전트는 **Action 정의**에 따라 실행한다.

### 서브에이전트 (Sub-Agent)

복잡한 문제를 **분해**하고 영역별로 처리하는 에이전트. Task decomposition — 역할 경계를 좁출수록 품질이 올라가는 경우가 많다.

**대표 패턴**

| 패턴 | 구성 |
|------|------|
| A | Planner → Executor → Reviewer |
| B | Researcher → Synthesizer → Critic |
| C | Tech / Biz / UX / Risk 등 Specialist 분해 |
| D | Tree-of-Thought: Branch A/B → Merge |

**프롬프트 예시 (분석 담당)**

```text
역할: 너는 요구사항 분석가다.
목표: 사용자 요청을 실행 가능한 작업 단위로 분해하라.
참조: Ontology의 Object / Action 정의를 기준으로 분류하라.
출력:
  - 목표
  - 필요한 입력
  - 불확실성
  - 하위 작업 목록
제약:
  - 구현은 하지 말고 분석만 수행
```

### 스킬 에이전트 (Skill Agent)

특정 **기능(툴·API·계산)**을 수행하는 실행 단위. Ontology Action 범위 내에서만 동작 → Governance 적용이 쉬워진다.

**스킬 유형 × AIP 레이어**

| 스킬 유형 | 레이어 | 예시 |
|-----------|--------|------|
| Search | Data Services | 웹 검색, RAG, Vector DB |
| Code Execution | AI Services | Python/SQL, 테스트 |
| API Call | Data Services | CRM, 캘린더, 결제 |
| Memory Access | Data Services | 단기/장기 메모리 |
| Calculation | AI Services | 수치·통계·시뮬 |
| Pipeline Trigger | Workflow Services | 자동화 파이프라인 |
| Notification | Workflow Services | 알림·이벤트 |

**서브 vs 스킬**

| 항목 | 서브에이전트 | 스킬에이전트 |
|------|-------------|-------------|
| 본질 | 역할 기반 추론 | 기능 기반 실행 |
| 초점 | Reasoning | Action |
| Ontology | Object·Relation로 분해 | Action으로 실행 |
| 출력 | 계획·검토·초안 | 검색·계산·API 응답 |
| 실패 | 논리 비약·누락 | 호출 실패·포맷 오류 |
| 레이어 | AI Services | Data / AI / Workflow |

---

## Part 3 — 구현 패턴

### 흐름 요약

```text
Pattern 1: User Input → LLM → Final Answer

Pattern 2: User Input → LLM Router → Tool Call → Tool Result → LLM Finalization

Pattern 3: User Input → Orchestrator → Planner → Research Skill → Draft → Review → Final

Pattern 4 (Ontology 포함):
User Input → Context Loader → Ontology Layer (Object/Relation/Action)
→ Orchestrator → Sub-Agents → Skills (Data/AI/Workflow)
→ Security & Governance (Action 허용 여부) → Memory Update → Final Answer
```

### 프롬프트를 어떻게 나눌 것인가

| 프롬프트 유형 | 포함 내용 | AIP 레이어 |
|----------------|-----------|------------|
| 시스템 | 역할, 금지, 스타일, 안전 | Security & Governance |
| Ontology | Object/Relation/Action 주입 | Ontology Layer |
| 오케스트레이션 | 요청 분류·라우팅 | AI Services |
| 서브에이전트 | 역할별 입출력 엄격화 | AI Services |
| 스킬 호출 스키마 | 함수명·파라미터·반환 형식 | Data / Workflow |
| 최종 응답 | 사용자 친화 통합 | AI Products |

**라우팅 프롬프트 예시**

```text
사용자 요청과 Ontology를 참조하여 아래 중 하나로 분류하라.
- direct_answer
- research_needed
- multi_step_analysis
- tool_execution

출력 JSON:
{
  "intent": "",
  "related_objects": [],
  "required_actions": [],
  "requires_web": true/false,
  "requires_decomposition": true/false
}
```

**의사코드 (Python 스타일)**

```python
def handle_user_request(user_input, context, ontology):
    onto_context = ontology.resolve(user_input)
    route = classify_request(user_input, context, onto_context)

    if route.intent == "direct_answer":
        return single_prompt_answer(user_input, context, onto_context)

    plan = make_plan(user_input, context, onto_context)
    results = {}

    for step in plan.steps:
        if not ontology.is_action_allowed(step.required_action):
            raise GovernanceError(f"Action {step.required_action} not permitted")

        if step.required_skill:
            results[step.step_id] = call_skill(step.required_skill, step)
        else:
            results[step.step_id] = run_subagent(step, results, context, onto_context)

    draft = synthesize_results(results, context, onto_context)
    review = review_draft(draft, context, onto_context)
    return revise_draft(draft, review)
```

---

## Part 4 — 설계 원칙 / 실패 / 결론

### 자주 생기는 실패 패턴

| 문제 | 원인 | 대응 |
|------|------|------|
| 역할 경계 모호 | 서브에이전트 업무 중복·충돌 | 책임·입출력 명시 |
| 툴 호출 기준 불명확 | 추정으로 답함 | 최신성/정확성 조건, 특정 유형은 강제 툴 |
| 컨텍스트 과적재 | 무한 누적 | 요약·상태만 유지·오래된 문맥 제거 |
| 형식적 검토 | 리뷰가 허수아비 | 검토 기준·오류 유형·수정 제안 요구 |
| 중간 결과 포맷 불일치 | 통합 단계 붕괴 | JSON schema 고정·인터페이스 표준화 |
| Ontology 없이 운용 | 객체/행동 해석 불일치 | Ontology Layer 분리 설계 |
| 비허용 Action | Governance 미적용 | Action 범위 검증 단계 |

### 좋은 설계 원칙

- 단순하게 시작: `direct_answer` / `research` / `review` 등 소수 intent로 시작. Ontology도 핵심 Object 3~5개부터.
- 출력 구조화: 자유서술보다 schema 고정이 안정적.
- 검증은 별도 단계: 생성과 검증을 한 단계에 몰지 않기.
- 툴은 필요한 순간에만: Ontology Action 기준으로 호출 여부 판단.
- Ontology는 독립 레이어: 프롬프트에 묻히지 않는 단일 소스.
- 최종 응답은 사용자 언어로 재구성.

### 최종 종합

| 요소 | 역할 | 레이어 | 한 줄 |
|------|------|--------|--------|
| 싱글턴 프롬프팅 | 독립 단일 호출 | AI Services 내부 | 한 번에 정확히 끝내기 |
| 컨텍스트 프롬프팅 | 누적 상태 처리 | Ontology + AI Services | 대화로 점진적 완성 |
| Ontology Layer | 공통 세계 모델 | 독립 레이어 | 같은 언어로 세계 이해 |
| 서브에이전트 | 역할별 분해 | AI Services | 문제를 나눔 (추론) |
| 스킬 에이전트 | 실행 | Data / AI / Workflow | 행동 수행 |
| 오케스트레이터 | 흐름·통합 | AI Services + Ontology | 전체 조율 |
| Security & Governance | 정책·감사 | 독립 레이어 | 허용 범위 보장 |

---

## 결론

좋은 LLM 시스템은 “프롬프트만 잘 쓰는 시스템”이 아니라, **Ontology로 세계를 정의**하고, 문제를 올바르게 **분해**하고, 필요한 **도구를 적절히 호출**하고, 결과를 **검증**해 다시 **조립**하는 시스템에 가깝다.

*Singleton Prompting · Contextual Prompting · Ontology Layer · Sub-Agent · Skill Agent · Orchestrator*
