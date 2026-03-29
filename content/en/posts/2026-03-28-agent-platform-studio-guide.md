---
title: "Agent Control Plane — Studio Web Guide"
title_alt: "Studio 웹 가이드 (agent-control-plane)"
date: 2026-03-28
slug: agent-platform-studio-guide
tags: ["AI Agent", "Ontology", "sideseat", "Vite", "React", "guide"]
math: false
translationKey: agent-platform-studio-guide
---

**agent-control-plane** is the open-source control plane for sideseat. Agents talk to the stack through the Worker API (`WORKER_BASE_URL`) and tool registry—not the DB directly—and Studio (Vite + React) is where you edit Object·Link·Action graphs and workflows. For concepts, read [AI Agent Scaffolding & Ontology (KO)](/2026/03/21/ai-agent-scaffolding-ontology/) first; paths and env follow the repo **README**.

## On this page {#toc}

- [Repository](#repo) · [Studio view](#studio-view) · [Layout](#layout) · [Studio UI tour](#ui-tour)
- [Local run](#local-run) · [Architecture](#architecture) · [Dev notes](#dev-notes) · [References](#refs)

## Repository {#repo}

<div class="link-bookmark">
  <a href="https://github.com/calicorone/agent-control-plane" target="_blank" rel="noopener noreferrer">agent-control-plane — GitHub</a>
  <div class="link-bookmark-url">https://github.com/calicorone/agent-control-plane</div>
  <p class="link-bookmark-meta">Vite+React Studio · Docker roles (ops/backend/support)</p>
</div>

---

## Studio view {#studio-view}

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

---

## Layout {#layout}

| Area | Role |
|------|------|
| **Studio** | `platform-web` — node editor, ontology·workflow visualization, save/run/demo/export |
| **Worker / API** | Execution, tools, policy; connect via `WORKER_BASE_URL`, etc. |
| **Ontology** | Object Type / Link Type / Action — schema, relations, governed mutations |
| **Docker** | Role-based runtime/deploy split (`ops` / `backend` / `support`) |

---

## Studio UI tour {#ui-tour}

### Left navigation

- **Studio** — this editor  
- **Agents** — configured LLM agents (UI may vary by version)  
- **Overview** — dashboard  
- **Docs** — docs entry  

### Palette

| Section | Nodes | Role |
|---------|-------|------|
| **ONTOLOGY** | Object Type, Link Type, Action | Schema, relations, governed changes |
| **WORKFLOW** | Start, Dataset, Stream / Transform, Agent | Pipeline + LLM blocks |
| **TARGETS** | Deployed app, Notify | Deploy targets, webhooks |

### Canvas & properties

Connect nodes with **edges**. The properties panel edits metadata for the selection (**PROPERTIES — OBJECT**, etc.).

---

## Local run {#local-run}

```bash
git clone https://github.com/calicorone/agent-control-plane.git
cd agent-control-plane
cp .env.example .env   # WORKER_BASE_URL, etc.
npm install
```

Run the platform UI per **README** (e.g. `npm run platform` → **http://localhost:3010**). For Vite HMR, use `PLATFORM_API_ONLY=1 npm run platform` plus `cd platform-web && npm run dev` in a second terminal. Ports and scripts: **README** and `docs/LOCAL_SETUP.md`.

---

## Architecture in brief {#architecture}

**Object / Link / Action** in Studio pins the shared world model in the UI. **Think → Act → Observe** runs in the Worker/model runtime; Studio is where you shape **graph·schema·workflow contracts** before that. Theory and terminology: [Scaffolding & Ontology (KO)](/2026/03/21/ai-agent-scaffolding-ontology/).

**Stack (short)**: TypeScript, React, Vite (front end); Node.js, Docker (runtime/deploy); Ollama, Anthropic, etc. per repo config.

---

## Dev notes {#dev-notes}

- Run `npm install` after clone.  
- JSON / workflow XML exports help move graphs across environments.  
- Bearer token: remote Worker or protected APIs only.  
- Screenshot: `static/images/agnet-homepage.png` (legacy filename).  

---

## References {#refs}

- [AI Agent Scaffolding & Ontology](/2026/03/21/ai-agent-scaffolding-ontology/) (KO)  
- Similar walkthrough: [hibiki GPT-2 124M web guide](/2026/03/19/hibiki-gpt2-124m-web-guide/) (KO)  

Wire a graph end-to-end, then Execute or export and align with Worker logs—that maps the loop to code and UI fastest.
