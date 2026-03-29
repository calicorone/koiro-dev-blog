---
layout: post
title: "What Is an AI Agent — structure and how it works"
title_alt: "AI Agent란 무엇인가 — 구조와 작동 원리"
date: 2026-03-15
author: Ahhyun Kim
tags: ["AI Agent", "LLM", "ReAct", "Architecture"]
translationKey: ai-agent-intro
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

<div class="post-lead">
<div class="tags">
  <span class="tag purple">AI Agent</span>
  <span class="tag teal">LLM</span>
  <span class="tag coral">ReAct</span>
  <span class="tag amber">Architecture</span>
</div>
<p class="intro">“AI agent” is everywhere, but it is still hard to define. This note separates agents from plain LLM calls, walks through the usual loop, memory, tools, and common frameworks—so you can reason about new stacks without re-learning from zero.</p>

<h2>1. Agent vs LLM — what’s different?</h2>
<p>An LLM answers once per prompt. An <strong>agent</strong> keeps acting until a goal is met. The core difference is the <strong>loop</strong>.</p>
<table class="compare">
  <tr><th></th><th>LLM (single shot)</th><th>AI agent</th></tr>
  <tr><td>Execution</td><td>One input → one output</td><td>Repeat until the goal is satisfied</td></tr>
  <tr><td>Tools</td><td>None</td><td>APIs, DBs, code runners, …</td></tr>
  <tr><td>Memory</td><td>Context window only</td><td>Short-term + long-term + vector stores</td></tr>
  <tr><td>Planning</td><td>None</td><td>Decomposes goals into subtasks</td></tr>
  <tr><td>Autonomy</td><td>Low</td><td>Higher—chooses next actions</td></tr>
</table>
<p>For “Summarize last week’s news,” a bare LLM answers from training data. An agent can search the web, read results, and iterate until the summary is grounded.</p>

<h2>2. Agent loop — ReAct pattern</h2>
<p>The dominant pattern is <strong>ReAct (Reasoning + Acting)</strong>: think, act, observe, repeat.</p>
<div class="loop">
  <div class="loop-row"><div class="loop-label">1. Perceive</div><div class="loop-desc">Take input—user message, webhook, schedule, …</div></div>
  <div class="loop-row"><div class="loop-label">2. Think</div><div class="loop-desc">The LLM analyzes state and picks the next action.</div></div>
  <div class="loop-row"><div class="loop-label">3. Act</div><div class="loop-desc">Invoke tools—search, HTTP, SQL, code, …</div></div>
  <div class="loop-row"><div class="loop-label">4. Observe</div><div class="loop-desc">Append tool output to working memory / context.</div></div>
  <div class="loop-row"><div class="loop-label">5. Evaluate</div><div class="loop-desc">Check goal satisfaction; if not, go back to Think.</div></div>
  <div class="loop-row"><div class="loop-label">6. Output</div><div class="loop-desc">Return, persist, or notify.</div></div>
</div>
<p>Sketch in code:</p>
<pre>while not goal_achieved:
    thought = llm.think(context, goal)
    action  = parse_action(thought)
    result  = execute_tool(action)
    context.add(result)
    goal_achieved = llm.evaluate(context)

return context.final_answer()</pre>

<h2>3. Memory layout</h2>
<p>Production agents mix three memory styles.</p>
<div class="memory-grid">
  <div class="mem-card purple"><h4>Short-term memory</h4><p>The live context window: chat turns and tool traces. Ephemeral to the session.</p></div>
  <div class="mem-card teal"><h4>Long-term memory</h4><p>Durable records—runs, preferences, facts—in Postgres, Redis, etc.</p></div>
  <div class="mem-card amber"><h4>Semantic memory</h4><p>Embeddings for “find similar” retrieval—pgvector, Pinecone, …</p></div>
</div>

<h2>4. Tools (function calling)</h2>
<p>Tools let the model delegate what text alone cannot do. The LLM emits structured intents; your runtime validates and executes.</p>
<div class="tool-grid">
  <div class="tool-card"><h4>Information</h4><ul><li>Web search</li><li>Crawl / fetch</li><li>SQL</li><li>Files</li></ul></div>
  <div class="tool-card"><h4>Compute</h4><ul><li>Python sandbox</li><li>Math</li><li>Vision APIs</li><li>External HTTP</li></ul></div>
  <div class="tool-card"><h4>Comms</h4><ul><li>Email</li><li>Slack / Telegram</li><li>Calendar</li><li>Push notifications</li></ul></div>
  <div class="tool-card"><h4>Control</h4><ul><li>Browser automation</li><li>Shell (careful!)</li><li>Other agents</li><li>Workflow triggers</li></ul></div>
</div>
<p>Example tool schema (Claude-style):</p>
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
    messages=[{"role": "user", "content": "Summarize recent AI agent news"}]
)</pre>

<h2>5. Agent shapes</h2>
<div class="agent-types">
  <div class="agent-row"><div class="agent-badge purple">ReAct agent</div><div class="agent-desc"><strong>Default single-agent loop</strong><span>Tool-using loop for one objective. Common in LangChain / LlamaIndex starters.</span></div></div>
  <div class="agent-row"><div class="agent-badge teal">Plan-and-execute</div><div class="agent-desc"><strong>Plan first, then run steps</strong><span>Good for long pipelines—planner emits a task list, executor runs items.</span></div></div>
  <div class="agent-row"><div class="agent-badge coral">Multi-agent</div><div class="agent-desc"><strong>Several agents collaborate</strong><span>Orchestrator routes work to specialists—AutoGen / CrewAI patterns.</span></div></div>
  <div class="agent-row"><div class="agent-badge amber">Autonomous agent</div><div class="agent-desc"><strong>Long-running, low touch</strong><span>Scheduled jobs, monitoring, always-on pipelines.</span></div></div>
</div>

<h2>6. Framework cheat sheet</h2>
<table class="fw-table">
  <tr><th>Framework</th><th>Language</th><th>Notes</th></tr>
  <tr><td>LangChain</td><td>Python / JS</td><td>Largest ecosystem; agents, chains, memory, tools.</td></tr>
  <tr><td>LlamaIndex</td><td>Python</td><td>Strong for RAG + structured data connectors.</td></tr>
  <tr><td>AutoGen</td><td>Python</td><td>Microsoft—multi-agent chat workflows.</td></tr>
  <tr><td>CrewAI</td><td>Python</td><td>Role-based teams of agents.</td></tr>
  <tr><td>LangGraph</td><td>Python</td><td>Graph-shaped control flow on top of LangChain ideas.</td></tr>
  <tr><td>n8n</td><td>No-code</td><td>Visual orchestration; quick integrations.</td></tr>
</table>
<div class="callout">Pick n8n for simple automation, LangChain/LangGraph when you need code-level control, CrewAI/AutoGen when multiple personas must coordinate.</div>

<h2>7. Design checklist</h2>
<h3>Iteration caps</h3>
<p>Agents can spin—set max steps (often 10–20) and graceful failure paths.</p>
<h3>Tool errors</h3>
<p>External APIs fail; teach the loop to retry, switch tools, or exit safely.</p>
<h3>Context growth</h3>
<p>Summarize or prune old observations so you stay inside token limits.</p>
<h3>Cost</h3>
<p>Each loop tick can invoke a large model—cache, route to smaller models, batch when possible.</p>
<h3>Human-in-the-loop</h3>
<p>Gate payments, outbound email, destructive writes behind explicit approval.</p>

<hr>
<p>Agents are still a fast-moving layer. If you internalize <strong>loop + tools + memory</strong>, swapping frameworks stops feeling like starting over.</p>
<footer><p>Ahhyun Kim · koiro.me · 2026.03.15</p></footer>
</div>
