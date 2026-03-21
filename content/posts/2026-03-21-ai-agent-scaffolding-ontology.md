---
layout: post
title: "AI Agent 스캐폴딩과 온톨로지 구조"
date: 2026-03-21
slug: ai-agent-scaffolding-ontology
author: Ahhyun Kim
tags: ["AI Agent", "Ontology", "Architecture", "RAG"]
---

<style>
  .post-content * { box-sizing: border-box; }
  .post-content .meta { color: #888; font-size: 0.88rem; margin-bottom: 44px; }
  .post-content .meta span { margin-right: 14px; }
  .post-content h1 { font-size: 2rem; font-weight: 700; letter-spacing: -0.02em; line-height: 1.25; margin-bottom: 14px; }
  .post-content h2 { font-size: 1.25rem; font-weight: 700; margin-top: 56px; margin-bottom: 16px; padding-bottom: 10px; border-bottom: 2px solid #e5e5e5; }
  .post-content h2:first-of-type { margin-top: 0; }
  .post-content h3 { font-size: 1rem; font-weight: 700; margin-top: 32px; margin-bottom: 10px; color: #3C3489; }
  .post-content p { margin-bottom: 18px; color: #333; }
  .post-content ul, .post-content ol { padding-left: 22px; margin-bottom: 18px; }
  .post-content li { margin-bottom: 8px; color: #444; font-size: 0.95rem; line-height: 1.7; }
  .post-content strong { color: #2C2C2A; }
  .post-content .tags { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 36px; }
  .post-content .tag { font-size: 0.78rem; padding: 4px 12px; border-radius: 20px; font-weight: 600; }
  .post-content .tag.purple { background: #EEEDFE; color: #3C3489; }
  .post-content .tag.teal { background: #E1F5EE; color: #085041; }
  .post-content .tag.coral { background: #FAECE7; color: #712B13; }
  .post-content .tag.amber { background: #FAEEDA; color: #633806; }
  .post-content .intro { font-size: 1.05rem; line-height: 1.95; color: #444; border-left: 3px solid #7F77DD; padding-left: 20px; margin-bottom: 48px; }
  .post-content .back-koiro { font-size: 0.82rem; margin-bottom: 1rem; }
  .post-content .back-koiro a { color: #888; text-decoration: none; font-weight: 500; }
  .post-content .back-koiro a:hover { color: #0f2e1d; }
  .post-content .s-label { font-size: 0.7rem; letter-spacing: 0.14em; text-transform: uppercase; color: #999; margin-bottom: 0.35rem; }
  .post-content pre { background: #F8F8F5; border: 1px solid #e5e5e5; border-radius: 8px; padding: 20px; overflow-x: auto; font-family: "JetBrains Mono", "Fira Code", monospace; font-size: 0.84rem; line-height: 1.75; margin: 16px 0 28px; color: #2C2C2A; white-space: pre-wrap; }
  .post-content code { font-family: "JetBrains Mono", "Fira Code", monospace; font-size: 0.87em; background: #F8F8F5; padding: 2px 6px; border-radius: 4px; border: 1px solid #e5e5e5; color: #3C3489; }
  .post-content hr { border: none; border-top: 1px solid #e5e5e5; margin: 52px 0; }
  .post-content footer { margin-top: 80px; padding-top: 24px; border-top: 1px solid #e5e5e5; color: #888; font-size: 0.84rem; }
</style>

<div class="post-lead">
<p class="back-koiro"><a href="https://koiro.me">← koiro.me</a></p>
<div class="tags">
  <span class="tag purple">AI Agent</span>
  <span class="tag teal">Ontology</span>
  <span class="tag coral">Architecture</span>
  <span class="tag amber">RAG</span>
</div>
<p class="intro">에이전트가 "생각"하는 환경 자체를 어떻게 설계하는가.
실행 루프, 도구 연결, 메모리 레이어부터
지식 표현의 뼈대인 온톨로지까지.</p>

{{< essay >}}
<div class="essay-agent-ontology">

  <div class="section">
    <p class="s-label">Part 1</p>
    <h2>스캐폴딩 — 에이전트의 실행 환경</h2>

    <p>
      스캐폴딩(Scaffolding)은 건축의 비계에서 따온 용어다.
      본 구조물을 세우기 전에 세워두는 가설 구조물처럼,
      AI Agent 개발에서 스캐폴딩은 LLM이 실제로 작동할 수 있는
      <strong>실행 환경 전체</strong>를 의미한다.
    </p>

    <p>
      LLM 자체는 입력을 받아 출력을 생성하는 함수에 불과하다.
      그것만으로는 아무것도 "하지" 않는다.
      스캐폴딩이 그 LLM을 루프 안에 넣고, 도구를 연결하고,
      메모리를 붙이고, 다른 에이전트와 조율하게 만든다.
    </p>

    <div class="note">
      LangChain, CrewAI, AutoGen 같은 프레임워크는
      스캐폴딩을 추상화한 도구다 — 스캐폴딩 자체가 아니라.
      프레임워크 없이도 스캐폴딩은 구현 가능하다.
    </div>

    <h3>5 Layer Structure</h3>

    <div class="scaffold-diagram" role="list">

      <div class="layer" data-l="1" role="listitem">
        <span class="layer-num">01</span>
        <div class="layer-body">
          <div class="layer-name">LLM — 추론 엔진</div>
          <div class="layer-desc">Claude · GPT · Gemini — 추론, 계획, 응답 생성</div>
        </div>
        <span class="layer-badge">Brain</span>
      </div>

      <div class="connector" aria-hidden="true"></div>

      <div class="layer" data-l="2" role="listitem">
        <span class="layer-num">02</span>
        <div class="layer-body">
          <div class="layer-name">Agent Loop — 실행 루프</div>
          <div class="layer-desc">Think → Act → Observe → Repeat</div>
        </div>
        <span class="layer-badge">Core</span>
      </div>

      <div class="connector" aria-hidden="true"></div>

      <div class="layer" data-l="3" role="listitem">
        <span class="layer-num">03</span>
        <div class="layer-body">
          <div class="layer-name">Tool Use — 도구 인터페이스</div>
          <div class="layer-desc">Web search · Code executor · External API · DB</div>
        </div>
        <span class="layer-badge">Interface</span>
      </div>

      <div class="connector" aria-hidden="true"></div>

      <div class="layer" data-l="4" role="listitem">
        <span class="layer-num">04</span>
        <div class="layer-body">
          <div class="layer-name">Memory &amp; Orchestrator</div>
          <div class="layer-desc">Short-term · Long-term · RAG &nbsp;|&nbsp; 멀티 에이전트 조율</div>
        </div>
        <span class="layer-badge">State</span>
      </div>

      <div class="connector" aria-hidden="true"></div>

      <div class="layer" data-l="5" role="listitem">
        <span class="layer-num">05</span>
        <div class="layer-body">
          <div class="layer-name">Guardrails / Eval</div>
          <div class="layer-desc">안전 필터 · 출력 검증 · 로깅 · 평가 루프</div>
        </div>
        <span class="layer-badge">Safety</span>
      </div>

    </div>

    <h3>Loop Mechanics</h3>

    <p>
      Agent Loop는 단순히 LLM을 반복 호출하는 것이 아니다.
      매 반복마다 <code>Observation</code>을 컨텍스트에 추가하고,
      다음 <code>Action</code>을 결정하는 구조다.
      이 루프가 멈추는 조건 — 목표 달성, 최대 스텝 초과, 에러 — 을
      스캐폴딩이 관리한다.
    </p>

    <p>
      Tool call은 LLM이 직접 실행하지 않는다.
      LLM은 "어떤 도구를 어떤 인자로 호출하라"는
      <em>의도(intent)</em>를 출력할 뿐이고,
      스캐폴딩이 그것을 실제 함수 호출로 변환한다.
    </p>

    <p>
      실무에서는 도구 스키마(JSON Schema 등)를 시스템 프롬프트나
      <code>tools</code> 파라미터로 넘겨, 모델 출력을 구조화된 tool call로
      파싱한 뒤 런타임에서 검증·실행하는 패턴이 일반적이다.
      MCP(Model Context Protocol)처럼 도구·리소스를 표준화해 두면,
      에이전트와 외부 시스템을 같은 스캐폴딩 계층에서 묶기 쉽다.
    </p>

    <h3>Guardrails — 안전과 품질</h3>

    <p>
      5번째 레이어는 "출력만 예쁘게"가 아니라
      정책 위반 차단, PII 마스킹, 할루시네이션 완화, A/B 평가까지 포함한다.
      스캐폴딩이 로그와 메트릭을 남겨야 나중에 프롬프트·도구·모델을
      같은 기준으로 개선할 수 있다.
    </p>
  </div>

  <hr>

  <div class="section">
    <p class="s-label">Part 2</p>
    <h2>온톨로지 — 지식의 뼈대</h2>

    <p>
      온톨로지(Ontology)는 원래 철학 용어다.
      "존재하는 것들의 분류와 관계"를 다루는 형이상학의 한 분야.
      컴퓨터 과학에서는 이것이 <strong>형식적 지식 표현 체계</strong>로 좁혀진다 —
      클래스, 프로퍼티, 인스턴스, 관계를 명시적으로 정의한 구조.
    </p>

    <p>
      AI Agent에서 온톨로지는 에이전트가 세계를 이해하는 방식을 정의한다.
      "사람"이 무엇인지, "조직"과 어떤 관계인지,
      어떤 속성을 가질 수 있는지를 기계가 추론할 수 있는 형태로 표현한다.
    </p>

    <p>
      OWL 외에도 <strong>SKOS</strong>(분류·사전·태깅)로 개념 계층만 정리하거나,
      <strong>SHACL</strong>로 RDF 그래프에 대한 제약·검증 규칙을 두는 식으로
      스택을 나눠 쓰는 경우가 많다. 전부 "온톨로지"라는 이름 아래에서
      엄격함과 운영 비용 사이의 균형을 맞추는 선택이다.
    </p>

    <h3>기본 구성 요소</h3>

    <div class="onto-tree">
      <div class="onto-root">
        <span>Ontology</span>
        <span style="font-size:10px;opacity:.5;letter-spacing:.08em">OWL 2 / RDF</span>
      </div>

      <ul class="onto-level">
        <li>
          <span class="onto-node">
            <span class="dot d-class"></span>
            <span class="node-label">Class</span>
            <span class="node-type">개념 분류</span>
          </span>
          <ul class="onto-level">
            <li><span class="onto-node"><span class="dot d-class"></span><span class="node-label">Person</span><span class="node-type">subClassOf Thing</span></span></li>
            <li><span class="onto-node"><span class="dot d-class"></span><span class="node-label">Organization</span><span class="node-type">subClassOf Agent</span></span></li>
            <li><span class="onto-node"><span class="dot d-class"></span><span class="node-label">Event</span><span class="node-type">subClassOf Occurrence</span></span></li>
          </ul>
        </li>
        <li>
          <span class="onto-node">
            <span class="dot d-prop"></span>
            <span class="node-label">Property</span>
            <span class="node-type">관계 / 속성 정의</span>
          </span>
          <ul class="onto-level">
            <li><span class="onto-node"><span class="dot d-rel"></span><span class="node-label">ObjectProperty</span><span class="node-type">worksFor, partOf</span></span></li>
            <li><span class="onto-node"><span class="dot d-prop"></span><span class="node-label">DatatypeProperty</span><span class="node-type">name, date, value</span></span></li>
          </ul>
        </li>
        <li>
          <span class="onto-node">
            <span class="dot d-inst"></span>
            <span class="node-label">Individual</span>
            <span class="node-type">실제 인스턴스</span>
          </span>
          <ul class="onto-level">
            <li><span class="onto-node"><span class="dot d-inst"></span><span class="node-label">ex:Ahhyun</span><span class="node-type">rdf:type Person</span></span></li>
            <li><span class="onto-node"><span class="dot d-inst"></span><span class="node-label">ex:POSCO_DX</span><span class="node-type">rdf:type Organization</span></span></li>
          </ul>
        </li>
        <li>
          <span class="onto-node">
            <span class="dot d-rel"></span>
            <span class="node-label">Axiom</span>
            <span class="node-type">추론 규칙 / 제약</span>
          </span>
          <ul class="onto-level">
            <li><span class="onto-node"><span class="dot d-rel"></span><span class="node-label">domain / range</span><span class="node-type">프로퍼티 타입 제약</span></span></li>
            <li><span class="onto-node"><span class="dot d-rel"></span><span class="node-label">equivalentClass</span><span class="node-type">동치 클래스</span></span></li>
          </ul>
        </li>
      </ul>
    </div>

    <h3>스택별 역할 비교</h3>

    <table class="compare-table">
      <thead>
        <tr>
          <th>Layer</th>
          <th>역할</th>
          <th>실제 사용</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>RDF</td>
          <td>트리플(주어–서술어–목적어)로 사실 표현</td>
          <td>데이터 교환 기반 레이어</td>
        </tr>
        <tr>
          <td>RDFS</td>
          <td>클래스·프로퍼티 계층 정의</td>
          <td>간단한 분류 체계</td>
        </tr>
        <tr>
          <td>OWL 2</td>
          <td>복잡한 제약·추론 규칙 표현</td>
          <td>엔터프라이즈 지식 그래프</td>
        </tr>
        <tr>
          <td>FOAF</td>
          <td>사람·조직 관계 표준 어휘</td>
          <td>소셜 그래프 / 프로필</td>
        </tr>
        <tr>
          <td>SPARQL</td>
          <td>온톨로지 쿼리 언어</td>
          <td>지식 그래프 검색·추론</td>
        </tr>
      </tbody>
    </table>
  </div>

  <hr>

  <div class="section">
    <p class="s-label">Part 3</p>
    <h2>둘의 교차점 — 지식 기반 에이전트</h2>

    <p>
      스캐폴딩이 에이전트의 <em>행동 구조</em>를 정의한다면,
      온톨로지는 에이전트가 가진 <em>세계 모델</em>을 정의한다.
      이 둘이 결합하면 단순 도구 호출을 넘어
      도메인 지식을 바탕으로 추론하는 에이전트가 된다.
    </p>

    <p>
      예를 들어 에너지 모니터링 시스템에서:
      스캐폴딩은 센서 데이터 수집 → 이상 감지 → 알람 생성의 루프를 관리하고,
      온톨로지는 "설비 A가 공정 B에 속하고, 공정 B의 정상 온도 범위는 X"라는
      도메인 지식을 에이전트가 추론에 활용할 수 있게 구조화한다.
    </p>

    <div class="note">
      현업에서는 온톨로지를 완전히 OWL 2로 구현하는 경우는 드물다.
      JSON-LD, Knowledge Graph DB(Neo4j 등), 또는 단순 스키마 정의로
      대체하는 경우가 많다. 핵심은 형식(format)이 아니라
      <em>개념 간 관계를 명시적으로 정의했는가</em>다.
    </div>

    <p>
      RAG(Retrieval-Augmented Generation)도 넓게 보면
      비정형 텍스트 코퍼스를 에이전트의 "지식 레이어"로 사용하는 방식이다.
      온톨로지 기반 접근과의 차이는 <strong>추론 가능성(inferability)</strong> —
      온톨로지는 명시적 관계를 통해 새로운 사실을 도출할 수 있다.
    </p>

    <p>
      <strong>Graph RAG</strong>나 온톨로지 정렬 임베딩을 쓰면,
      검색된 청크뿐 아니라 엔티티·관계 단위로 컨텍스트를 조립해
      스캐폴딩의 Memory 레이어와 자연스럽게 이어질 수 있다.
      에이전트 한 스텝이 "SPARQL/그래프 쿼리 → 근거 트리플 → LLM 요약"이 되는
      패턴도 자주 설계된다.
    </p>
  </div>

</div>
{{< /essay >}}

<footer><p>Ahhyun Kim · koiro.me · 2026.03.21</p></footer>
</div>
