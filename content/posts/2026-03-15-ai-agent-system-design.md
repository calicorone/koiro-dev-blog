---
layout: post
title: "AI Agent 시스템 설계 — 혼자 운영하는 자동화 아키텍처"
date: 2026-03-15
author: Ahhyun Kim
---

<style>
  :root {
    --bg: #ffffff;
    --text: #1a1a1a;
    --muted: #666666;
    --border: #e5e5e5;
    --purple-bg: #EEEDFE;
    --purple-text: #3C3489;
    --teal-bg: #E1F5EE;
    --teal-text: #085041;
    --coral-bg: #FAECE7;
    --coral-text: #712B13;
    --gray-bg: #F5F5F2;
    --gray-text: #2C2C2A;
    --code-bg: #F8F8F5;
  }
  .post-content * { box-sizing: border-box; }
  .post-content h1 { font-size: 2rem; font-weight: 700; letter-spacing: -0.02em; line-height: 1.2; margin-bottom: 12px; }
  .post-content h2 { font-size: 1.3rem; font-weight: 600; margin-top: 56px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 1px solid var(--border); }
  .post-content h3 { font-size: 1.05rem; font-weight: 600; margin-top: 36px; margin-bottom: 10px; color: var(--purple-text); }
  .post-content p { margin-bottom: 16px; color: #333; }
  .post-content .meta { color: var(--muted); font-size: 0.9rem; margin-bottom: 48px; }
  .post-content .meta span { margin-right: 16px; }
  .post-content .intro { font-size: 1.1rem; line-height: 1.9; color: #444; border-left: 3px solid var(--purple-text); padding-left: 20px; margin-bottom: 48px; }
  .post-content .loop { display: flex; flex-direction: column; gap: 0; margin: 24px 0 32px; }
  .post-content .loop-step { display: flex; align-items: stretch; }
  .post-content .loop-label { background: var(--purple-bg); color: var(--purple-text); font-weight: 600; font-size: 0.85rem; min-width: 110px; display: flex; align-items: center; padding: 12px 16px; border: 1px solid #CECBF6; border-bottom: none; }
  .post-content .loop-step:last-child .loop-label { border-bottom: 1px solid #CECBF6; }
  .post-content .loop-step:last-child .loop-desc { border-bottom: 1px solid var(--border); }
  .post-content .loop-desc { flex: 1; padding: 12px 16px; background: #FAFAF8; border: 1px solid var(--border); border-left: none; border-bottom: none; font-size: 0.95rem; color: #444; display: flex; align-items: center; }
  .post-content .agent-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin: 24px 0 32px; }
  .post-content .agent-card { border-radius: 10px; padding: 20px; border: 1px solid transparent; }
  .post-content .agent-card.teal { background: var(--teal-bg); border-color: #9FE1CB; }
  .post-content .agent-card.coral { background: var(--coral-bg); border-color: #F5C4B3; }
  .post-content .agent-card h4 { font-size: 0.95rem; font-weight: 700; margin-bottom: 6px; }
  .post-content .agent-card.teal h4 { color: var(--teal-text); }
  .post-content .agent-card.coral h4 { color: var(--coral-text); }
  .post-content .agent-card .role { font-size: 0.85rem; color: #555; margin-bottom: 4px; }
  .post-content .agent-card .stack { font-size: 0.82rem; font-family: monospace; color: #888; }
  .post-content .infra-table { width: 100%; border-collapse: collapse; margin: 20px 0 32px; font-size: 0.93rem; }
  .post-content .infra-table th { background: var(--gray-bg); color: var(--gray-text); font-weight: 600; padding: 10px 14px; text-align: left; border: 1px solid var(--border); font-size: 0.85rem; }
  .post-content .infra-table td { padding: 10px 14px; border: 1px solid var(--border); vertical-align: top; color: #444; line-height: 1.6; }
  .post-content .infra-table tr:nth-child(even) td { background: #FAFAF8; }
  .post-content .infra-table td:first-child { font-weight: 600; color: var(--gray-text); white-space: nowrap; width: 140px; }
  .post-content pre { background: var(--code-bg); border: 1px solid var(--border); border-radius: 8px; padding: 20px; overflow-x: auto; font-family: "JetBrains Mono", "Fira Code", monospace; font-size: 0.85rem; line-height: 1.7; margin: 16px 0 28px; color: #2C2C2A; }
  .post-content code { font-family: "JetBrains Mono", "Fira Code", monospace; font-size: 0.88em; background: var(--code-bg); padding: 2px 6px; border-radius: 4px; border: 1px solid var(--border); color: #3C3489; }
  .post-content .steps { display: flex; flex-direction: column; gap: 0; margin: 20px 0 32px; counter-reset: step; }
  .post-content .step { display: flex; gap: 0; counter-increment: step; }
  .post-content .step-num { background: var(--purple-text); color: white; font-weight: 700; font-size: 0.82rem; min-width: 70px; display: flex; align-items: center; justify-content: center; padding: 14px 10px; border-bottom: 1px solid rgba(255,255,255,0.1); }
  .post-content .step:first-child .step-num { border-radius: 8px 0 0 0; }
  .post-content .step:last-child .step-num { border-radius: 0 0 0 8px; }
  .post-content .step-body { flex: 1; padding: 14px 18px; background: var(--gray-bg); border: 1px solid var(--border); border-left: none; border-top: none; }
  .post-content .step:first-child .step-body { border-top: 1px solid var(--border); border-radius: 0 8px 0 0; }
  .post-content .step:last-child .step-body { border-radius: 0 0 8px 0; }
  .post-content .step-body strong { display: block; font-size: 0.9rem; color: var(--gray-text); margin-bottom: 4px; }
  .post-content .step-body span { font-size: 0.88rem; color: #666; }
  .post-content .tags { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 32px; }
  .post-content .tag { font-size: 0.78rem; padding: 4px 12px; border-radius: 20px; font-weight: 500; }
  .post-content .tag.purple { background: var(--purple-bg); color: var(--purple-text); }
  .post-content .tag.teal { background: var(--teal-bg); color: var(--teal-text); }
  .post-content .tag.coral { background: var(--coral-bg); color: var(--coral-text); }
  .post-content hr { border: none; border-top: 1px solid var(--border); margin: 48px 0; }
  .post-content ul { padding-left: 20px; margin-bottom: 16px; }
  .post-content li { margin-bottom: 8px; color: #444; font-size: 0.95rem; }
  .post-content .callout { background: var(--purple-bg); border-left: 3px solid var(--purple-text); border-radius: 0 8px 8px 0; padding: 16px 20px; margin: 24px 0; font-size: 0.93rem; color: var(--purple-text); }
  .post-content footer { margin-top: 80px; padding-top: 24px; border-top: 1px solid var(--border); color: var(--muted); font-size: 0.85rem; }
</style>

<div class="post-content">
<p class="meta">
  <span>2026.03.15</span>
  <span>Ahhyun Kim</span>
  <span>koiro.me</span>
</p>

<h1>AI Agent 시스템 설계<br>— 혼자 운영하는 자동화 아키텍처</h1>

<div class="tags">
  <span class="tag purple">AI Agent</span>
  <span class="tag teal">Automation</span>
  <span class="tag teal">Python</span>
  <span class="tag coral">LangChain</span>
  <span class="tag purple">n8n</span>
  <span class="tag coral">Claude API</span>
</div>

<p class="intro">
  회사를 다니면서 혼자 수익화 시스템을 만들어보려고 합니다. 핵심은 반복 작업을 에이전트에게 위임하는 것입니다. 이 글은 AI Agent의 개념부터 실제 제 시스템 설계까지, 직접 구현하면서 정리한 내용입니다.
</p>

<h2>1. AI Agent란 무엇인가</h2>

<p>AI Agent는 <strong>목표를 주면 스스로 계획하고, 툴을 호출하고, 결과를 보고, 루프를 반복</strong>하는 자율 실행 시스템입니다. ChatGPT에 질문하면 한 번 답하고 끝납니다. Agent는 목표가 달성될 때까지 계속 행동합니다.</p>

<p>가장 널리 쓰이는 패턴은 <code>ReAct (Reasoning + Acting)</code>입니다. 생각하고 → 행동하고 → 관찰하는 루프를 반복합니다.</p>

<div class="loop">
  <div class="loop-step">
    <div class="loop-label">1. Perceive</div>
    <div class="loop-desc">입력 수신 — 트리거, 데이터, 메시지, 스케줄 등</div>
  </div>
  <div class="loop-step">
    <div class="loop-label">2. Think</div>
    <div class="loop-desc">LLM이 현재 상태를 분석하고 다음 행동을 결정 (reasoning)</div>
  </div>
  <div class="loop-step">
    <div class="loop-label">3. Act</div>
    <div class="loop-desc">툴 호출 — API 요청, DB 쿼리, 코드 실행, 웹 검색 등</div>
  </div>
  <div class="loop-step">
    <div class="loop-label">4. Observe</div>
    <div class="loop-desc">툴 실행 결과를 받아서 컨텍스트에 추가</div>
  </div>
  <div class="loop-step">
    <div class="loop-label">5. Repeat</div>
    <div class="loop-desc">목표 달성 여부 판단 → 미완이면 2번으로 돌아감</div>
  </div>
  <div class="loop-step">
    <div class="loop-label">6. Output</div>
    <div class="loop-desc">최종 결과 저장 / 알림 / 리포트 생성</div>
  </div>
</div>

<h3>메모리 종류</h3>
<p>Agent는 3가지 메모리를 조합합니다.</p>
<ul>
  <li><strong>Short-term</strong> — 현재 실행 중인 컨텍스트 윈도우. 대화 기록, 툴 결과가 여기 쌓임.</li>
  <li><strong>Long-term</strong> — PostgreSQL 등 DB에 저장된 영구 기록. 과거 백테스트 결과, 사용자 행동 이력.</li>
  <li><strong>Vector (semantic)</strong> — 텍스트를 임베딩으로 변환해 저장. 의미 기반 검색에 사용 (<code>pgvector</code> 또는 Pinecone).</li>
</ul>

<hr>

<h2>2. 내 시스템의 4가지 Agent</h2>

<p>현재 설계 중인 개인 자동화 시스템은 4개의 Agent로 구성됩니다. 각자 독립적으로 실행되고, n8n Orchestrator가 스케줄과 흐름을 관리합니다.</p>

<div class="agent-grid">
  <div class="agent-card teal">
    <h4>Data Collector</h4>
    <p class="role">KRX · yfinance · 뉴스 자동 수집</p>
    <p class="stack">Python · pandas · PostgreSQL</p>
  </div>
  <div class="agent-card teal">
    <h4>Backtest Agent</h4>
    <p class="role">트레이딩 전략 자동 평가</p>
    <p class="stack">Python · backtrader · PostgreSQL</p>
  </div>
  <div class="agent-card coral">
    <h4>Moderation Agent</h4>
    <p class="role">SideSeat meetup 자동 검토</p>
    <p class="stack">Claude API · Cloudflare Workers · Supabase</p>
  </div>
  <div class="agent-card coral">
    <h4>Alert Agent</h4>
    <p class="role">일일 리포트 · Telegram 알림</p>
    <p class="stack">Python · Telegram Bot API</p>
  </div>
</div>

<h3>Data Collector</h3>
<p>매일 새벽 주식 데이터, 뉴스, 경제 지표를 자동 수집해서 PostgreSQL에 저장합니다. 모든 분석의 기반이 되는 레이어입니다.</p>

<pre>
# 간단한 구조 예시
import yfinance as yf
import psycopg2

def collect_market_data(tickers: list[str]) -> None:
    data = yf.download(tickers, period="1d", interval="1d")
    # PostgreSQL market_data 테이블에 저장
    save_to_db(data)

# n8n에서 매일 오전 6시에 트리거
</pre>

<h3>Backtest Agent</h3>
<p>수집된 데이터를 바탕으로 트레이딩 전략을 자동으로 백테스트하고 성과 리포트를 생성합니다. LLM이 결과를 해석해서 "이번 주 가장 좋은 전략은 X" 형태로 요약합니다.</p>

<h3>Moderation Agent</h3>
<p>SideSeat에 새로 생성된 meetup을 Claude API로 자동 검토합니다. 판단 결과에 따라 status를 업데이트하고 호스트에게 알림을 보냅니다.</p>

<pre>
// Cloudflare Worker 예시
const result = await anthropic.messages.create({
  model: "claude-sonnet-4-20250514",
  messages: [{
    role: "user",
    content: `다음 meetup 내용을 검토해주세요: ${meetup.title} — ${meetup.description}
    분류: normal / review_needed / remove
    JSON으로만 응답하세요.`
  }]
});
</pre>

<h3>Alert Agent</h3>
<p>모든 시스템의 실행 결과를 취합해서 매일 저녁 Telegram으로 요약 리포트를 보냅니다. "오늘 수집한 데이터 2,400개, 백테스트 탑 전략 Momentum +2.3%, SideSeat 신규 meetup 5개" 같은 형식입니다.</p>

<hr>

<h2>3. 공유 인프라</h2>

<p>4개의 Agent가 모두 공유하는 하부 레이어입니다. 이 설계가 제대로 돼야 Agent들이 데이터를 주고받을 수 있습니다.</p>

<table class="infra-table">
  <tr><th>컴포넌트</th><th>역할</th></tr>
  <tr>
    <td>PostgreSQL</td>
    <td>모든 에이전트의 영구 저장소. market_data, strategies, meetups, agent_logs 테이블. Supabase 또는 Mac mini 로컬.</td>
  </tr>
  <tr>
    <td>pgvector</td>
    <td>Postgres 확장. 뉴스 요약, 리서치 노트를 임베딩으로 저장. 의미 검색 및 추천 시스템에 활용.</td>
  </tr>
  <tr>
    <td>Claude API</td>
    <td>Agent의 두뇌. 판단, 분류, 요약, 생성 작업. <code>claude-sonnet-4-20250514</code> 기본 사용.</td>
  </tr>
  <tr>
    <td>n8n</td>
    <td>Orchestrator. 모든 Agent의 스케줄, 트리거, 에러 처리 담당. Mac mini에서 Docker로 셀프 호스팅.</td>
  </tr>
  <tr>
    <td>Mac mini M2 Pro</td>
    <td>Phase 3부터 도입. 24시간 로컬 브레인. 트레이딩 봇, 데이터 파이프라인, n8n 운영.</td>
  </tr>
  <tr>
    <td>Cloudflare Workers</td>
    <td>SideSeat API 및 Moderation Agent 엔드포인트. 서버리스, 글로벌 엣지.</td>
  </tr>
</table>

<div class="callout">
  핵심 설계 원칙: Agent들은 서로 직접 통신하지 않습니다. 모두 PostgreSQL을 통해 데이터를 주고받습니다. 이렇게 하면 한 Agent가 죽어도 다른 Agent에 영향이 없습니다.
</div>

<hr>

<h2>4. 구축 순서</h2>

<p>모든 걸 동시에 만들면 아무것도 완성되지 않습니다. 아래 순서대로 하나씩 만들고 실제로 돌아가는 걸 확인한 뒤 다음 단계로 넘어갑니다.</p>

<div class="steps">
  <div class="step">
    <div class="step-num">Step 1<br>1주</div>
    <div class="step-body">
      <strong>Data Collector 구현</strong>
      <span>yfinance로 KOSPI 200 데이터 수집 → Postgres 저장. 가장 단순하고 즉시 가치가 보임.</span>
    </div>
  </div>
  <div class="step">
    <div class="step-num">Step 2<br>2주</div>
    <div class="step-body">
      <strong>Alert Agent 구현</strong>
      <span>Telegram Bot 연결 → 매일 수집 현황 리포트. 시스템이 살아있다는 피드백 루프 생성.</span>
    </div>
  </div>
  <div class="step">
    <div class="step-num">Step 3<br>4주</div>
    <div class="step-body">
      <strong>Backtest Agent 구현</strong>
      <span>Momentum 전략 하나를 매일 자동 평가. 실제 신호가 나오기 시작.</span>
    </div>
  </div>
  <div class="step">
    <div class="step-num">Step 4<br>2개월</div>
    <div class="step-body">
      <strong>Moderation Agent 구현</strong>
      <span>SideSeat MVP 출시 후 콘텐츠 자동 검토 파이프라인 추가.</span>
    </div>
  </div>
  <div class="step">
    <div class="step-num">Step 5<br>3개월+</div>
    <div class="step-body">
      <strong>n8n Orchestrator 통합</strong>
      <span>4개 Agent를 하나의 파이프라인으로 연결. Mac mini 구매 및 로컬 배포.</span>
    </div>
  </div>
</div>

<hr>

<h2>5. 기술 스택 요약</h2>

<table class="infra-table">
  <tr><th>영역</th><th>스택</th></tr>
  <tr><td>언어</td><td>Python (에이전트, 데이터 파이프라인) + TypeScript (Cloudflare Workers, SideSeat)</td></tr>
  <tr><td>LLM</td><td>Claude API (<code>claude-sonnet-4-20250514</code>) — 분류, 요약, 판단</td></tr>
  <tr><td>Orchestration</td><td>n8n (셀프 호스팅, Docker)</td></tr>
  <tr><td>Database</td><td>PostgreSQL + pgvector (Supabase 또는 로컬)</td></tr>
  <tr><td>Deployment</td><td>Mac mini M2 Pro (로컬) + Cloudflare Workers (엣지)</td></tr>
  <tr><td>Alerting</td><td>Telegram Bot API</td></tr>
  <tr><td>Data sources</td><td>KRX Open API · yfinance · 네이버 금융 · arXiv RSS</td></tr>
</table>

<hr>

<p>아직 Step 1도 시작 전입니다. 만들면서 계속 업데이트할 예정입니다. SideSeat 프로젝트는 <a href="https://koiro.me">koiro.me</a>에서 볼 수 있습니다.</p>

<footer>
  <p>Ahhyun Kim · koiro.me · 2026.03.15</p>
</footer>
</div>
