---
layout: post
title: "AI Agent란 무엇인가 — 구조와 작동 원리"
date: 2026-03-15
author: Ahhyun Kim
---

<style>
  .post-content * { box-sizing: border-box; }
  .post-content .meta { color: #888; font-size: 0.88rem; margin-bottom: 44px; }
  .post-content .meta span { margin-right: 14px; }
  .post-content h1 { font-size: 2rem; font-weight: 700; letter-spacing: -0.02em; line-height: 1.25; margin-bottom: 14px; }
  .post-content h2 { font-size: 1.25rem; font-weight: 700; margin-top: 56px; margin-bottom: 16px; padding-bottom: 10px; border-bottom: 2px solid #e5e5e5; }
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
  .post-content .compare { width: 100%; border-collapse: collapse; margin: 20px 0 32px; font-size: 0.92rem; }
  .post-content .compare th { background: #F5F5F2; color: #2C2C2A; font-weight: 700; padding: 10px 16px; text-align: left; border: 1px solid #e5e5e5; }
  .post-content .compare td { padding: 10px 16px; border: 1px solid #e5e5e5; color: #444; vertical-align: top; line-height: 1.6; }
  .post-content .compare tr:nth-child(even) td { background: #FAFAF8; }
  .post-content .compare td:first-child { font-weight: 600; color: #2C2C2A; width: 140px; }
  .post-content .loop { display: flex; flex-direction: column; margin: 20px 0 32px; }
  .post-content .loop-row { display: flex; }
  .post-content .loop-label { background: #EEEDFE; color: #3C3489; font-weight: 700; font-size: 0.82rem; min-width: 120px; display: flex; align-items: center; padding: 12px 16px; border: 1px solid #CECBF6; border-bottom: none; }
  .post-content .loop-row:last-child .loop-label { border-bottom: 1px solid #CECBF6; border-radius: 0 0 0 8px; }
  .post-content .loop-row:first-child .loop-label { border-radius: 8px 0 0 0; }
  .post-content .loop-desc { flex: 1; padding: 12px 18px; background: #FAFAF8; border: 1px solid #e5e5e5; border-left: none; border-bottom: none; font-size: 0.93rem; color: #444; display: flex; align-items: center; }
  .post-content .loop-row:first-child .loop-desc { border-radius: 0 8px 0 0; }
  .post-content .loop-row:last-child .loop-desc { border-bottom: 1px solid #e5e5e5; border-radius: 0 0 8px 0; }
  .post-content .memory-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px; margin: 20px 0 32px; }
  .post-content .mem-card { border-radius: 10px; padding: 18px; }
  .post-content .mem-card.purple { background: #EEEDFE; }
  .post-content .mem-card.teal { background: #E1F5EE; }
  .post-content .mem-card.amber { background: #FAEEDA; }
  .post-content .mem-card h4 { font-size: 0.88rem; font-weight: 700; margin-bottom: 6px; }
  .post-content .mem-card.purple h4 { color: #3C3489; }
  .post-content .mem-card.teal h4 { color: #085041; }
  .post-content .mem-card.amber h4 { color: #633806; }
  .post-content .mem-card p { font-size: 0.83rem; line-height: 1.65; color: #555; margin: 0; }
  .post-content .tool-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin: 20px 0 32px; }
  .post-content .tool-card { background: #F5F5F2; border-radius: 8px; padding: 16px; border: 1px solid #e5e5e5; }
  .post-content .tool-card h4 { font-size: 0.88rem; font-weight: 700; color: #2C2C2A; margin-bottom: 6px; }
  .post-content .tool-card ul { padding-left: 14px; margin: 0; }
  .post-content .tool-card li { font-size: 0.83rem; color: #666; margin-bottom: 3px; }
  .post-content .agent-types { display: flex; flex-direction: column; gap: 12px; margin: 20px 0 32px; }
  .post-content .agent-row { display: flex; gap: 12px; align-items: stretch; }
  .post-content .agent-badge { min-width: 130px; border-radius: 8px; padding: 14px 16px; display: flex; align-items: center; justify-content: center; text-align: center; font-weight: 700; font-size: 0.88rem; line-height: 1.4; }
  .post-content .agent-badge.purple { background: #EEEDFE; color: #3C3489; }
  .post-content .agent-badge.teal { background: #E1F5EE; color: #085041; }
  .post-content .agent-badge.coral { background: #FAECE7; color: #712B13; }
  .post-content .agent-badge.amber { background: #FAEEDA; color: #633806; }
  .post-content .agent-desc { flex: 1; background: #FAFAF8; border: 1px solid #e5e5e5; border-radius: 8px; padding: 14px 18px; }
  .post-content .agent-desc strong { display: block; font-size: 0.88rem; color: #2C2C2A; margin-bottom: 4px; }
  .post-content .agent-desc span { font-size: 0.85rem; color: #666; line-height: 1.6; }
  .post-content .fw-table { width: 100%; border-collapse: collapse; margin: 20px 0 32px; font-size: 0.91rem; }
  .post-content .fw-table th { background: #F5F5F2; color: #2C2C2A; font-weight: 700; padding: 10px 14px; text-align: left; border: 1px solid #e5e5e5; }
  .post-content .fw-table td { padding: 10px 14px; border: 1px solid #e5e5e5; color: #444; vertical-align: top; line-height: 1.6; }
  .post-content .fw-table tr:nth-child(even) td { background: #FAFAF8; }
  .post-content .fw-table td:first-child { font-weight: 700; color: #2C2C2A; white-space: nowrap; width: 130px; }
  .post-content .fw-table td:nth-child(2) { width: 120px; color: #888; font-size: 0.85rem; }
  .post-content pre { background: #F8F8F5; border: 1px solid #e5e5e5; border-radius: 8px; padding: 20px; overflow-x: auto; font-family: "JetBrains Mono", "Fira Code", monospace; font-size: 0.84rem; line-height: 1.75; margin: 16px 0 28px; color: #2C2C2A; white-space: pre-wrap; }
  .post-content code { font-family: "JetBrains Mono", "Fira Code", monospace; font-size: 0.87em; background: #F8F8F5; padding: 2px 6px; border-radius: 4px; border: 1px solid #e5e5e5; color: #3C3489; }
  .post-content .callout { background: #EEEDFE; border-left: 3px solid #7F77DD; border-radius: 0 8px 8px 0; padding: 16px 20px; margin: 24px 0 32px; font-size: 0.93rem; color: #3C3489; line-height: 1.7; }
  .post-content hr { border: none; border-top: 1px solid #e5e5e5; margin: 52px 0; }
  .post-content footer { margin-top: 80px; padding-top: 24px; border-top: 1px solid #e5e5e5; color: #888; font-size: 0.84rem; }
</style>

<div class="post-content">
<p class="meta"><span>2026.03.15</span> <span>Ahhyun Kim</span></p>
<h1>AI Agent란 무엇인가<br>— 구조와 작동 원리</h1>
<div class="tags">
  <span class="tag purple">AI Agent</span>
  <span class="tag teal">LLM</span>
  <span class="tag coral">ReAct</span>
  <span class="tag amber">Architecture</span>
</div>
<p class="intro">"AI Agent"라는 말이 많이 쓰이지만, 정확히 무엇인지 설명하기 어렵습니다. 단순히 ChatGPT를 자동화한 것과 무엇이 다른지, 어떤 구조로 작동하는지 개념부터 정리했습니다.</p>

<h2>1. Agent vs LLM — 무엇이 다른가</h2>
<p>LLM(Large Language Model)은 입력을 받으면 한 번 응답하고 끝납니다. Agent는 목표를 달성할 때까지 스스로 행동을 반복합니다. 핵심 차이는 <strong>루프</strong>입니다.</p>
<table class="compare">
  <tr><th></th><th>LLM (단발 호출)</th><th>AI Agent</th></tr>
  <tr><td>실행 방식</td><td>1회 입력 → 1회 출력</td><td>목표 달성까지 루프 반복</td></tr>
  <tr><td>툴 사용</td><td>없음</td><td>API, DB, 코드 실행 등 호출 가능</td></tr>
  <tr><td>메모리</td><td>컨텍스트 윈도우만</td><td>단기 + 장기 + 벡터 메모리</td></tr>
  <tr><td>계획</td><td>없음</td><td>목표를 서브태스크로 분해</td></tr>
  <tr><td>자율성</td><td>낮음</td><td>높음 (스스로 다음 행동 결정)</td></tr>
</table>
<p>예를 들어 "최근 1주일 뉴스를 요약해줘"라는 요청을 받았을 때, LLM은 학습 데이터 안에서만 답합니다. Agent는 웹 검색 툴을 호출하고, 결과를 읽고, 요약을 작성합니다. 필요하면 여러 번 검색을 반복합니다.</p>

<h2>2. Agent 실행 루프 — ReAct 패턴</h2>
<p>현재 가장 널리 쓰이는 Agent 패턴은 <strong>ReAct (Reasoning + Acting)</strong>입니다. 생각하고, 행동하고, 관찰하는 루프를 반복합니다.</p>
<div class="loop">
  <div class="loop-row"><div class="loop-label">1. Perceive</div><div class="loop-desc">입력 수신 — 사용자 요청, 트리거, 스케줄 이벤트 등</div></div>
  <div class="loop-row"><div class="loop-label">2. Think</div><div class="loop-desc">LLM이 현재 상태를 분석하고 다음 행동을 결정합니다.</div></div>
  <div class="loop-row"><div class="loop-label">3. Act</div><div class="loop-desc">툴 호출 — 웹 검색, API 요청, DB 쿼리, 코드 실행 등</div></div>
  <div class="loop-row"><div class="loop-label">4. Observe</div><div class="loop-desc">툴 실행 결과를 컨텍스트(메모리)에 추가합니다.</div></div>
  <div class="loop-row"><div class="loop-label">5. Evaluate</div><div class="loop-desc">목표 달성 여부를 판단하고, 미달이면 2번으로 돌아갑니다.</div></div>
  <div class="loop-row"><div class="loop-label">6. Output</div><div class="loop-desc">최종 결과를 반환·저장·알림합니다.</div></div>
</div>
<p>이 루프를 코드로 표현하면 아래와 같습니다.</p>
<pre>while not goal_achieved:
    thought = llm.think(context, goal)   # 2. 다음 행동 결정
    action  = parse_action(thought)       # 3. 툴 선택
    result  = execute_tool(action)        # 3. 툴 실행
    context.add(result)                   # 4. 결과를 메모리에 추가
    goal_achieved = llm.evaluate(context) # 5. 목표 달성 여부 판단

return context.final_answer()             # 6. 최종 출력</pre>

<h2>3. 메모리 구조</h2>
<p>Agent는 상황에 따라 3가지 메모리를 조합해서 사용합니다.</p>
<div class="memory-grid">
  <div class="mem-card purple"><h4>Short-term memory</h4><p>현재 실행 중인 컨텍스트 윈도우. 대화 기록, 툴 호출 결과가 쌓입니다. LLM이 직접 참조하며, 세션이 끝나면 사라집니다.</p></div>
  <div class="mem-card teal"><h4>Long-term memory</h4><p>DB에 저장된 영구 기록. 과거 실행 결과, 사용자 설정, 누적 데이터를 담습니다. PostgreSQL, Redis 등 사용.</p></div>
  <div class="mem-card amber"><h4>Semantic memory</h4><p>텍스트를 임베딩으로 저장합니다. "이것과 비슷한 내용 찾아줘" 같은 의미 기반 검색에 쓰입니다. pgvector, Pinecone 등.</p></div>
</div>

<h2>4. 툴 (Tool / Function Calling)</h2>
<p>Agent가 LLM 단독으로는 할 수 없는 일을 가능하게 하는 핵심 요소입니다. LLM은 "어떤 툴을 어떤 인자로 호출할지"를 결정하고, 실제 실행은 외부 시스템이 담당합니다.</p>
<div class="tool-grid">
  <div class="tool-card"><h4>정보 수집</h4><ul><li>웹 검색 (Google, Bing API)</li><li>웹 페이지 크롤링</li><li>DB 쿼리 (SQL)</li><li>파일 읽기·쓰기</li></ul></div>
  <div class="tool-card"><h4>실행·연산</h4><ul><li>Python 코드 실행</li><li>수학 계산</li><li>이미지 생성·분석</li><li>외부 API 호출</li></ul></div>
  <div class="tool-card"><h4>커뮤니케이션</h4><ul><li>이메일 전송</li><li>Slack·Telegram 메시지</li><li>캘린더 이벤트 생성</li><li>알림 발송</li></ul></div>
  <div class="tool-card"><h4>제어·자동화</h4><ul><li>브라우저 자동화 (Playwright)</li><li>CLI 명령 실행</li><li>다른 Agent 호출</li><li>워크플로우 트리거</li></ul></div>
</div>
<p>Function Calling은 LLM이 툴을 호출하는 방식을 표준화한 인터페이스입니다. Claude API 기준 예시입니다.</p>
<pre>tools = [{
    "name": "web_search",
    "description": "Search the web for recent information",
    "input_schema": {
        "type": "object",
        "properties": { "query": {"type": "string", "description": "Search query"} },
        "required": ["query"]
    }
}]

response = anthropic.messages.create(
    model="claude-sonnet-4-20250514",
    tools=tools,
    messages=[{"role": "user", "content": "최근 AI Agent 관련 뉴스를 요약해줘"}]
)
# LLM이 위 툴의 호출 여부와 query를 스스로 결정합니다</pre>

<h2>5. Agent의 종류</h2>
<p>구조와 목적에 따라 여러 유형으로 나뉩니다.</p>
<div class="agent-types">
  <div class="agent-row"><div class="agent-badge purple">ReAct Agent</div><div class="agent-desc"><strong>가장 일반적인 단일 Agent</strong><span>Reasoning + Acting 루프. 툴을 사용해 단일 목표를 달성합니다. LangChain, LlamaIndex의 기본 Agent 구조.</span></div></div>
  <div class="agent-row"><div class="agent-badge teal">Plan-and-Execute</div><div class="agent-desc"><strong>계획을 먼저 세우고 순서대로 실행</strong><span>복잡한 멀티스텝 태스크에 적합. Planner가 서브태스크 목록을 만들고 Executor가 하나씩 처리합니다.</span></div></div>
  <div class="agent-row"><div class="agent-badge coral">Multi-Agent</div><div class="agent-desc"><strong>여러 Agent가 협력하는 시스템</strong><span>Orchestrator가 태스크를 분배하고 Specialist Agent들이 각자 담당 영역을 처리합니다. AutoGen, CrewAI 패턴.</span></div></div>
  <div class="agent-row"><div class="agent-badge amber">Autonomous Agent</div><div class="agent-desc"><strong>사람 개입 없이 장기 실행</strong><span>스케줄로 트리거되어 스스로 목표를 설정하고 실행합니다. 24시간 운영되는 데이터 파이프라인·모니터링에 사용.</span></div></div>
</div>

<h2>6. 주요 프레임워크</h2>
<table class="fw-table">
  <tr><th>프레임워크</th><th>언어</th><th>특징</th></tr>
  <tr><td>LangChain</td><td>Python / JS</td><td>가장 널리 쓰임. Agent, Chain, Memory, Tool 추상화 제공. 레퍼런스와 생태계가 큼.</td></tr>
  <tr><td>LlamaIndex</td><td>Python</td><td>RAG(Retrieval-Augmented Generation)와 데이터 연결에 강점. 문서 기반 Agent에 적합.</td></tr>
  <tr><td>AutoGen</td><td>Python</td><td>Microsoft. Multi-Agent 대화 프레임워크. Agent끼리 대화하며 문제를 해결.</td></tr>
  <tr><td>CrewAI</td><td>Python</td><td>역할 기반 Multi-Agent. 각 Agent에 역할·목표·배경을 부여하고 팀처럼 협업.</td></tr>
  <tr><td>LangGraph</td><td>Python</td><td>LangChain 팀. 그래프로 Agent 흐름을 정의. 복잡한 상태 관리와 루프 제어에 적합.</td></tr>
  <tr><td>n8n</td><td>No-code</td><td>시각적 워크플로우. 코드 없이 Agent 오케스트레이션 가능. 셀프 호스팅 지원.</td></tr>
</table>
<div class="callout">프레임워크 선택 기준: 단순 자동화라면 n8n이 빠릅니다. Python으로 제어가 필요하면 LangChain 또는 LangGraph. 여러 Agent가 협업하는 구조라면 CrewAI나 AutoGen을 고려합니다.</div>

<h2>7. 설계할 때 고려할 것들</h2>
<h3>루프 제한 (Max iterations)</h3>
<p>Agent가 목표를 달성하지 못하면 무한 루프에 빠질 수 있습니다. 최대 반복 횟수를 반드시 두어야 합니다. 보통 10~20회로 제한합니다.</p>
<h3>툴 에러 처리</h3>
<p>외부 API는 언제든 실패할 수 있습니다. 툴 호출 실패 시 Agent가 다른 방법을 시도하거나, 우아하게 종료하도록 설계해야 합니다.</p>
<h3>컨텍스트 윈도우 관리</h3>
<p>루프가 반복될수록 컨텍스트가 쌓여 토큰 한도를 넘깁니다. 오래된 관찰 결과를 요약하거나 잘라 내는 전략이 필요합니다.</p>
<h3>비용 관리</h3>
<p>LLM API 호출은 루프마다 발생합니다. 복잡한 태스크는 수십 번 호출될 수 있으므로, 캐싱과 모델 선택(무거운 모델 vs 가벼운 모델)을 의도적으로 설계해야 합니다.</p>
<h3>Human-in-the-loop</h3>
<p>결제, 이메일 발송, DB 수정처럼 중요한 행동은 자동 실행 전에 사람 확인을 받도록 두는 것이 안전합니다.</p>

<hr>
<p>AI Agent는 아직 빠르게 발전하는 영역입니다. 지금의 패턴과 프레임워크가 1년 뒤에는 달라질 수 있습니다. "루프 + 툴 + 메모리"라는 본질을 이해하면, 어떤 프레임워크가 나와도 적응할 수 있습니다.</p>
<footer><p>Ahhyun Kim · koiro.me · 2026.03.15</p></footer>
</div>
