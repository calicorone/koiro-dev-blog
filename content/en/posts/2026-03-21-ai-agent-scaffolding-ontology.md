---
layout: post
title: "AI Agent Scaffolding & Ontology"
title_alt: "AI Agent 스캐폴딩과 온톨로지 구조"
date: 2026-03-21
slug: ai-agent-scaffolding-ontology
author: Ahhyun Kim
tags: ["AI Agent", "Ontology", "Architecture", "RAG"]
essay: true
translationKey: ai-agent-scaffolding-ontology
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
<p class="intro">How do you design the environment in which an agent “thinks”? From execution loops and tool wiring through memory layers to ontologies—the backbone of explicit knowledge.</p>

<p style="font-size:0.98rem;line-height:1.75;color:#555;margin:-28px 0 40px;padding-left:20px;border-left:3px solid #c9c4f0;">
  For implementation and UI, the <strong>sideseat</strong> repo <strong>agent-control-plane</strong> exposes a <strong>Studio</strong> (<code>platform-web</code>, Vite+React) where ontology and workflow are edited as graphs.
  Screenshots, local setup, and panel notes: <a href="/en/2026/03/28/agent-platform-studio-guide/">Agent Control Plane — Studio Web Guide</a> and
  <a href="https://github.com/calicorone/agent-control-plane">GitHub</a>.
</p>

{{< essay >}}
<div class="essay-agent-ontology">

  <div class="section">
    <p class="s-label">Part 1</p>
    <h2>Scaffolding — the agent runtime</h2>

    <p>
      “Scaffolding” comes from construction: temporary structure that supports the real build.
      In agent engineering, scaffolding is the <strong>full runtime</strong> that lets an LLM actually do work—not the model weights alone.
    </p>

    <p>
      A raw LLM is a function from prompt to completion.
      Scaffolding wraps it in a loop, attaches tools and memory, and coordinates other agents when needed.
    </p>

    <div class="note">
      LangChain, CrewAI, AutoGen, etc. are frameworks that <em>abstract</em> scaffolding—they are not scaffolding itself.
      You can implement scaffolding without any of them.
    </div>

    <h3>Five layers</h3>

    <div class="scaffold-diagram" role="list">

      <div class="layer" data-l="1" role="listitem">
        <span class="layer-num">01</span>
        <div class="layer-body">
          <div class="layer-name">LLM — reasoning engine</div>
          <div class="layer-desc">Claude · GPT · Gemini — plan, reason, answer</div>
        </div>
        <span class="layer-badge">Brain</span>
      </div>

      <div class="connector" aria-hidden="true"></div>

      <div class="layer" data-l="2" role="listitem">
        <span class="layer-num">02</span>
        <div class="layer-body">
          <div class="layer-name">Agent loop</div>
          <div class="layer-desc">Think → Act → Observe → repeat</div>
        </div>
        <span class="layer-badge">Core</span>
      </div>

      <div class="connector" aria-hidden="true"></div>

      <div class="layer" data-l="3" role="listitem">
        <span class="layer-num">03</span>
        <div class="layer-body">
          <div class="layer-name">Tool use</div>
          <div class="layer-desc">Web search · code · APIs · databases</div>
        </div>
        <span class="layer-badge">Interface</span>
      </div>

      <div class="connector" aria-hidden="true"></div>

      <div class="layer" data-l="4" role="listitem">
        <span class="layer-num">04</span>
        <div class="layer-body">
          <div class="layer-name">Memory &amp; orchestrator</div>
          <div class="layer-desc">Short-term · long-term · RAG &nbsp;|&nbsp; multi-agent routing</div>
        </div>
        <span class="layer-badge">State</span>
      </div>

      <div class="connector" aria-hidden="true"></div>

      <div class="layer" data-l="5" role="listitem">
        <span class="layer-num">05</span>
        <div class="layer-body">
          <div class="layer-name">Guardrails / eval</div>
          <div class="layer-desc">Safety filters · output checks · logging · eval loops</div>
        </div>
        <span class="layer-badge">Safety</span>
      </div>

    </div>

    <h3>Loop mechanics</h3>

    <p>
      The loop is not “call the LLM many times.”
      Each turn appends an <code>Observation</code> and selects the next <code>Action</code>.
      Scaffolding owns stop conditions—goal met, max steps, fatal errors.
    </p>

    <p>
      Tool calls are not executed inside the model.
      The model emits an <em>intent</em>; your runtime parses, validates, and executes real functions.
    </p>

    <p>
      In practice you pass JSON Schema (or provider-specific tool specs), parse structured calls, and execute in a sandbox.
      Protocols like <strong>MCP</strong> standardize how tools and resources attach to the same scaffolding layer.
    </p>

    <h3>Guardrails</h3>

    <p>
      The fifth layer is not cosmetic: policy blocks, PII handling, hallucination mitigation, and offline eval all live here.
      Without logs and metrics you cannot iterate prompts, tools, and models on a consistent ruler.
    </p>
  </div>

  <hr>

  <div class="section">
    <p class="s-label">Part 2</p>
    <h2>Ontology — the knowledge backbone</h2>

    <p>
      In philosophy, ontology is the study of what exists and how kinds relate.
      In computer science it narrows to a <strong>formal knowledge representation</strong>—classes, properties, instances, and explicit relations.
    </p>

    <p>
      For agents, an ontology defines how the system reads the world:
      what a “person” is, how it relates to an “organization,” which attributes are valid, and what can be inferred.
    </p>

    <p>
      Besides OWL, teams often use <strong>SKOS</strong> for lightweight taxonomies or <strong>SHACL</strong> to validate RDF graphs.
      These are all trade-offs between expressivity and operating cost under the same “ontology” umbrella.
    </p>

    <h3>Building blocks</h3>

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
            <span class="node-type">Concept taxonomy</span>
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
            <span class="node-type">Relations / attributes</span>
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
            <span class="node-type">Concrete instances</span>
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
            <span class="node-type">Inference / constraints</span>
          </span>
          <ul class="onto-level">
            <li><span class="onto-node"><span class="dot d-rel"></span><span class="node-label">domain / range</span><span class="node-type">Property typing</span></span></li>
            <li><span class="onto-node"><span class="dot d-rel"></span><span class="node-label">equivalentClass</span><span class="node-type">Class equivalence</span></span></li>
          </ul>
        </li>
      </ul>
    </div>

    <h3>Stack roles</h3>

    <table class="compare-table">
      <thead>
        <tr>
          <th>Layer</th>
          <th>Role</th>
          <th>Typical use</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>RDF</td>
          <td>Triple facts (subject–predicate–object)</td>
          <td>Interchange / integration layer</td>
        </tr>
        <tr>
          <td>RDFS</td>
          <td>Class and property hierarchies</td>
          <td>Simple taxonomies</td>
        </tr>
        <tr>
          <td>OWL 2</td>
          <td>Rich constraints and reasoning</td>
          <td>Enterprise knowledge graphs</td>
        </tr>
        <tr>
          <td>FOAF</td>
          <td>Vocabulary for people and orgs</td>
          <td>Profiles / social graphs</td>
        </tr>
        <tr>
          <td>SPARQL</td>
          <td>Query language</td>
          <td>Graph search &amp; inference</td>
        </tr>
      </tbody>
    </table>
  </div>

  <hr>

  <div class="section">
    <p class="s-label">Part 3</p>
    <h2>Intersection — knowledge-grounded agents</h2>

    <p>
      Scaffolding defines <em>how</em> the agent acts; ontology defines <em>what world model</em> it assumes.
      Together they move you beyond ad-hoc tool calls toward domain-grounded reasoning.
    </p>

    <p>
      Example: energy monitoring—scaffolding runs ingest → anomaly → alert, while ontology states “asset A belongs to process B; normal temperature is X,” facts the agent can query and reason over.
    </p>

    <div class="note">
      Full OWL 2 everywhere is rare.
      JSON-LD, property graph DBs, or even disciplined JSON schemas often stand in.
      What matters is whether relationships are explicit, not the file format.
    </div>

    <p>
      <strong>RAG</strong>, broadly, uses unstructured corpora as a knowledge layer.
      Ontology-first designs differ in <strong>inferability</strong>—explicit axioms yield new facts, not only similar chunks.
    </p>

    <p>
      <strong>Graph RAG</strong> and ontology-aligned embeddings let you assemble context by entity and relation, not only text slices—natural fuel for the memory layer in scaffolding.
      A common pattern: graph query → grounded triples → LLM summarization for the next loop step.
    </p>
  </div>

</div>
{{< /essay >}}

<footer><p>Ahhyun Kim · koiro.me · 2026.03.21</p></footer>
</div>
