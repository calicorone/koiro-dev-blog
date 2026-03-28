---
title: "Agent Control Plane — Studio Web Guide"
title_alt: "에이전트 컨트롤 플레인 (Agent Control Plane) — Studio 웹 가이드"
date: 2026-03-28
slug: agent-platform-studio-guide
tags: ["AI Agent", "Ontology", "sideseat", "Vite", "React", "guide"]
math: false
translationKey: agent-platform-studio-guide
---

**agent-control-plane** is an open-source **agent control plane** for **sideseat**. Agents never hit the database directly; they only go through an **ontology (Ontology; Object·Link·Action)**, a **role-based tool registry**, and the **Worker API** (`WORKER_BASE_URL`). Together with a **Think → Act → Observe** loop, the **Vite + React Studio** below lets you shape ontology and **workflow** as a graph and trace how that ties into execution.

**Suggested reading order**: read [AI Agent Scaffolding & Ontology (Korean)](/2026/03/21/ai-agent-scaffolding-ontology/) first for concepts, then this UI-focused note. Paths and env vars always follow the repo **README**.

## On this page {#toc}

- [Repository](#repo) · [Studio view](#studio-view) · [Layout](#layout) · [Studio UI tour](#ui-tour)
- [Local run](#local-run) · [Architecture link](#architecture) · [Stack](#stack) · [Dev notes](#dev-notes) · [Audience](#audience) · [References](#refs)

## Repository {#repo}

<div class="link-bookmark">
  <a href="https://github.com/calicorone/agent-control-plane" target="_blank" rel="noopener noreferrer">agent-control-plane — GitHub</a>
  <div class="link-bookmark-url">https://github.com/calicorone/agent-control-plane</div>
  <p class="link-bookmark-meta">sideseat agent control plane · Vite+React Studio · Docker roles (ops/backend/support)</p>
</div>

Conceptual background continues in the Korean essay **[AI Agent Scaffolding & Ontology](/2026/03/21/ai-agent-scaffolding-ontology/)** (KO).

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
  <p class="hibiki-showcase-caption">Local dev. Object·Link·Action ontology and workflow on one canvas.</p>
</div>

The center graph is a Meetup-creation example.

- Purple Object nodes: `Meetup`, `Space`  
- Blue Link: `atPlace` (event at a venue)  
- Yellow Action: `CreateMeetup`  
- Agent node  
- Green Deployed target: `sideseat`  

The right panel edits the selected Object’s type name, description, and properties (`id`, title, time, capacity, etc.).

</div>

---

## Layout {#layout}

| Area | Role |
|------|------|
| **Studio (front end)** | `platform-web` (Vite + React) — node editor, ontology·workflow visualization, save/run/demo/export |
| **Worker / API** | Where agents run, tools are called, and policy is enforced; connect via `WORKER_BASE_URL`, etc. |
| **Ontology model** | Object Type / Link Type / Action — schema, relations, governed mutations |
| **Docker·roles** | Split runtime·deploy boundaries (`ops` / `backend` / `support`) |

---

## Studio UI tour {#ui-tour}

### Left navigation

- **Studio** — this editor.
- **Agents** — manage configured LLM agents (UI may vary by version).
- **Overview** — dashboard.
- **Docs** — platform docs entry.

### Palette

| Section | Nodes | Role |
|---------|-------|------|
| **ONTOLOGY** | Object Type, Link Type, Action | Schema, relations, governed changes |
| **WORKFLOW** | Start, Dataset, Stream / Transform, + Agent | Pipeline + LLM blocks |
| **TARGETS** | Deployed app, Notify | e.g. sideseat, webhooks |

### Canvas & properties

Connect nodes with **edges**. The **properties** panel edits metadata for the selection (**PROPERTIES — OBJECT**, etc.).

---

## Local run {#local-run}

```bash
git clone https://github.com/calicorone/agent-control-plane.git
cd agent-control-plane
cp .env.example .env   # set WORKER_BASE_URL, etc.
npm install
```

Run the platform UI per **README** (e.g. `npm run platform` → **http://localhost:3010**). For Vite HMR, use `PLATFORM_API_ONLY=1 npm run platform` plus `cd platform-web && npm install && npm run dev` in a second terminal. See **README** and `docs/LOCAL_SETUP.md` for ports and scripts.

---

## Architecture link {#architecture}

- **Ontology** here follows the spirit of Palantir **AIP** (*Artificial Intelligence Platform*): a **shared world model** for agents. **Object / Link / Action** nodes pin that in the UI.
- **Agent** nodes bundle strategies such as **singleton / contextual prompting** into executable units; edges from **Action** show where reasoning attaches to governed mutations.
- **Think → Act → Observe** runs in the runtime (Worker, Ollama, Anthropic, …); Studio is where you shape **graph·schema·workflow contracts** before execution.
- Operationally, only **allowed Actions** should run through the Worker and tool registry (same boundary as “no direct DB”).

More theory: [AI Agent Scaffolding & Ontology](/2026/03/21/ai-agent-scaffolding-ontology/) (KO).

---

## Stack {#stack}

- **Front end**: TypeScript, React, Vite  
- **Runtime·deploy**: Node.js, Docker, role policy  
- **Models**: Ollama, Anthropic (Claude), … per repo  
- **Integration**: Worker API, ontology & tool registry — no direct DB from agents  

---

## Dev notes {#dev-notes}

- Expect `npm install` after clone; `node_modules` is not usually committed.
- JSON / workflow XML exports help move graphs across environments.
- Bearer token: only for remote Worker or protected APIs.
- Screenshot path: `static/images/agnet-homepage.png` (legacy filename; rename to e.g. `agent-homepage.png` if you clean up assets—update this post accordingly).

---

## Audience {#audience}

- Engineers adding **ontology-grounded agents** to sideseat-like products  
- Anyone who wants **agent scaffolding** as **UI**, not only code  
- Readers of the [ontology essay](/2026/03/21/ai-agent-scaffolding-ontology/) who want the **implementation surface**  

---

## References {#refs}

- **Concept (KO)**: [AI Agent Scaffolding & Ontology](/2026/03/21/ai-agent-scaffolding-ontology/)  
- Similar walkthrough style: [hibiki GPT-2 124M web guide](/2026/03/19/hibiki-gpt2-124m-web-guide/) (KO)  

---

Wire a graph end-to-end, then Execute or export and align with Worker logs—that maps **Think → Act → Observe** to code and UI fastest.
