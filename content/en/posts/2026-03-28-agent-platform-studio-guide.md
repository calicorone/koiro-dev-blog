---
title: "Agent Control Plane — Studio Web Guide"
title_alt: "Studio 웹 가이드 (agent-control-plane)"
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
  <p class="studio-deep-tagline">Singleton vs contextual prompting, sub/skill agents, and the ontology layer are covered in <a href="/2026/03/21/ai-agent-scaffolding-ontology/">Scaffolding &amp; Ontology</a> (KO). This note focuses on the <strong>agent-control-plane</strong> <strong>Studio UI</strong>.</p>
  <div class="studio-deep-pills">
    <span>Vite</span>
    <span>React</span>
    <span>Ontology</span>
    <span>Worker API</span>
  </div>
</div>

<p class="studio-deep-lead"><strong>agent-control-plane</strong> is the open-source control plane for sideseat. Agents reach the stack through <code>WORKER_BASE_URL</code> and the tool registry—not the DB directly—and Studio is where you edit Object·Link·Action graphs and workflows. Paths and env follow the repo <strong>README</strong>.</p>

## On this page {#toc}

- [Repository · stack](#repo) · [Studio view](#studio-view) · [UI tour](#ui-tour)
- [Local run](#local-run) · [Architecture](#architecture) · [Dev notes](#dev-notes) · [References](#refs)

<div class="studio-deep-part">
  <span class="studio-deep-part-num" aria-hidden="true">01</span>
  <div class="studio-deep-part-head">
    <p class="studio-deep-kicker-small">Part 1</p>
    <h2 id="repo">Repository &amp; runtime stack</h2>
  </div>
</div>

<div class="studio-deep-stack">
  <div class="studio-deep-stack-titlebar">
    <span class="dot dot--r" aria-hidden="true"></span>
    <span class="dot dot--y" aria-hidden="true"></span>
    <span class="dot dot--g" aria-hidden="true"></span>
    <span class="studio-deep-stack-label">Studio ↔ Ontology ↔ Worker (overview)</span>
  </div>
  <div class="studio-deep-stack-body">
    <div class="studio-deep-layer studio-deep-layer--products">
      <span class="layer-label">Products &amp; workflows</span>
      <span class="layer-desc">Runtime outcomes and automation—contracts you define in Studio flow here</span>
    </div>
    <div class="studio-deep-flow" aria-hidden="true">⇅</div>
    <div class="studio-deep-layer studio-deep-layer--studio">
      <span class="layer-label">★ Studio — platform-web</span>
      <span class="layer-desc">Node editor · Object / Link / Action · workflow view · Save / Execute / Demo / export</span>
    </div>
    <div class="studio-deep-flow" aria-hidden="true">⇅</div>
    <div class="studio-deep-grid3">
      <div class="studio-deep-layer studio-deep-layer--worker">
        <span class="layer-label">Worker / API</span>
        <span class="layer-desc">Think → Act → Observe · tools · policy</span>
      </div>
      <div class="studio-deep-layer studio-deep-layer--worker">
        <span class="layer-label">Ontology contract</span>
        <span class="layer-desc">Schema, links, allowed actions—pinned as a graph</span>
      </div>
      <div class="studio-deep-layer studio-deep-layer--worker">
        <span class="layer-label">Docker roles</span>
        <span class="layer-desc">ops / backend / support boundaries</span>
      </div>
    </div>
    <div class="studio-deep-flow" aria-hidden="true">⇅</div>
    <div class="studio-deep-layer studio-deep-layer--gov">
      <span class="layer-label">Governance</span>
      <span class="layer-desc">Only allowed actions via Worker/registry—same idea as “no direct DB”</span>
    </div>
  </div>
</div>

<div class="studio-deep-callout">
  How orchestrators, sub-agents, and skill agents read the ontology matches the same mental model as long-form “architecture guide” layouts. Here, <strong>Studio is the tool that pins that contract in the UI</strong>.
</div>

<div class="link-bookmark">
  <a href="https://github.com/calicorone/agent-control-plane" target="_blank" rel="noopener noreferrer">agent-control-plane — GitHub</a>
  <div class="link-bookmark-url">https://github.com/calicorone/agent-control-plane</div>
  <p class="link-bookmark-meta">Vite+React Studio · Docker roles (ops/backend/support)</p>
</div>

<div class="studio-deep-part">
  <span class="studio-deep-part-num" aria-hidden="true">02</span>
  <div class="studio-deep-part-head">
    <p class="studio-deep-kicker-small">Part 2</p>
    <h2 id="studio-view">Studio view</h2>
  </div>
</div>

<div class="studio-prose">

A typical visual IDE layout.

- Left: sideseat CONTROL PLANE navigation  
- Center: dot-grid canvas  
- Right: per-node properties panel  

The top bar lines up `OPEN`, `NAME`, Save / Execute / Demo / Delete, export (`.export.json`, `.workflow.xml`), and the API Bearer token field.

<div class="hibiki-showcase">
  <img src="/images/agnet-homepage.png" alt="sideseat CONTROL PLANE — Studio: ontology and workflow graph" width="1200" height="800" loading="lazy" decoding="async">
  <p class="hibiki-showcase-caption">Local dev. Object·Link·Action and workflow on one canvas.</p>
</div>

The center graph is a Meetup-creation example.

- Purple Object nodes: `Meetup`, `Space`  
- Blue Link: `atPlace`  
- Yellow Action: `CreateMeetup`  
- Agent node  
- Green Deployed target: `sideseat`  

The right panel edits the selected Object’s type, description, and properties (`id`, title, time, capacity, etc.).

</div>

<div class="studio-deep-part">
  <span class="studio-deep-part-num" aria-hidden="true">03</span>
  <div class="studio-deep-part-head">
    <p class="studio-deep-kicker-small">Part 3</p>
    <h2 id="layout">Layout · UI tour</h2>
  </div>
</div>

### Layout {#layout}

| Area | Role |
|------|------|
| **Studio** | `platform-web` — node editor, ontology·workflow visualization, save/run/demo/export |
| **Worker / API** | Execution, tools, policy; connect via `WORKER_BASE_URL`, etc. |
| **Ontology** | Object Type / Link Type / Action — schema, relations, governed mutations |
| **Docker** | Role-based runtime/deploy split (`ops` / `backend` / `support`) |

### Studio UI tour {#ui-tour}

#### Left navigation

- **Studio** — this editor  
- **Agents** — configured LLM agents (UI may vary by version)  
- **Overview** — dashboard  
- **Docs** — docs entry  

#### Palette

| Section | Nodes | Role |
|---------|-------|------|
| **ONTOLOGY** | Object Type, Link Type, Action | Schema, relations, governed changes |
| **WORKFLOW** | Start, Dataset, Stream / Transform, Agent | Pipeline + LLM blocks |
| **TARGETS** | Deployed app, Notify | Deploy targets, webhooks |

#### Canvas & properties

Connect nodes with **edges**. The properties panel edits metadata for the selection (**PROPERTIES — OBJECT**, etc.).

<div class="studio-deep-part">
  <span class="studio-deep-part-num" aria-hidden="true">04</span>
  <div class="studio-deep-part-head">
    <p class="studio-deep-kicker-small">Part 4</p>
    <h2 id="closing">Local run · architecture · wrap-up</h2>
  </div>
</div>

### Local run {#local-run}

```bash
git clone https://github.com/calicorone/agent-control-plane.git
cd agent-control-plane
cp .env.example .env   # WORKER_BASE_URL, etc.
npm install
```

Run the platform UI per **README** (e.g. `npm run platform` → **http://localhost:3010**). For Vite HMR, use `PLATFORM_API_ONLY=1 npm run platform` plus `cd platform-web && npm run dev` in a second terminal. Ports and scripts: **README** and `docs/LOCAL_SETUP.md`.

### Architecture in brief {#architecture}

<div class="studio-deep-terminal">
  <div class="studio-deep-stack-titlebar">
    <span class="dot dot--r" aria-hidden="true"></span>
    <span class="dot dot--y" aria-hidden="true"></span>
    <span class="dot dot--g" aria-hidden="true"></span>
    <span class="studio-deep-stack-label">contract vs runtime</span>
  </div>
  <pre>Studio          → edit graph·schema·workflow <strong>contracts</strong>
Worker / models → <strong>run</strong> Think → Act → Observe
Shared language → Object · Link · Action (see ontology essay)</pre>
</div>

**Stack (short)**: TypeScript, React, Vite (front end); Node.js, Docker (runtime/deploy); Ollama, Anthropic, etc. per repo config.

### Dev notes {#dev-notes}

- Run `npm install` after clone.  
- JSON / workflow XML exports help move graphs across environments.  
- Bearer token: remote Worker or protected APIs only.  
- Screenshot: `static/images/agnet-homepage.png` (legacy filename).  

### References {#refs}

- [AI Agent Scaffolding & Ontology](/2026/03/21/ai-agent-scaffolding-ontology/) (KO)  
- Similar walkthrough: [hibiki GPT-2 124M web guide](/2026/03/19/hibiki-gpt2-124m-web-guide/) (KO)  

<div class="studio-deep-outro">
  <p class="outro-kicker">In one line</p>
  <p>Wire a graph end-to-end, then Execute or export and align with Worker logs—that maps the loop to code and UI fastest.</p>
</div>

</div>
