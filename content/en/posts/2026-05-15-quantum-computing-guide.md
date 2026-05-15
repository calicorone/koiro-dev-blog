---
layout: post
title: "Quantum Computing Complete Guide — From Qubits to the NISQ Era"
title_alt: "양자 컴퓨팅 완전 가이드 — 큐비트부터 NISQ 시대까지"
date: 2026-05-15
slug: quantum-computing-guide
author: Ahhyun Kim
tags: ["Quantum-Computing", "Qubit", "NISQ", "Shor", "Post-Quantum"]
essay: true
translationKey: quantum-computing-guide
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
  .post-content pre { background: #F8F8F5; border: 1px solid #e5e5e5; border-radius: 8px; padding: 20px; overflow-x: auto; font-size: 0.84rem; line-height: 1.75; margin: 16px 0 28px; color: #2C2C2A; white-space: pre-wrap; }
  .post-content code { font-size: 0.87em; background: #F8F8F5; padding: 2px 6px; border-radius: 4px; border: 1px solid #e5e5e5; color: #3C3489; }
  .post-content hr { border: none; border-top: 1px solid #e5e5e5; margin: 52px 0; }
  .post-content table { width: 100%; border-collapse: collapse; margin: 24px 0 32px; font-size: 0.88rem; }
  .post-content th { background: #f4f4f0; font-weight: 700; padding: 10px 14px; border: 1px solid #e5e5e5; text-align: left; color: #2C2C2A; }
  .post-content td { padding: 9px 14px; border: 1px solid #e5e5e5; color: #444; vertical-align: top; line-height: 1.6; }
  .post-content tr:nth-child(even) td { background: #fafaf8; }
  .post-content .callout { background: #EEEDFE; border-left: 4px solid #3C3489; padding: 16px 20px; border-radius: 0 8px 8px 0; margin: 28px 0; font-size: 0.93rem; color: #2C2C2A; line-height: 1.75; }
  .post-content .callout.warn { background: #FAECE7; border-left-color: #712B13; }
  .post-content .figure { margin: 32px 0 40px; }
  .post-content .figure img { width: 100%; height: auto; border-radius: 10px; border: 1px solid #e5e5e5; }
  .post-content .figure figcaption { font-size: 0.82rem; color: #888; margin-top: 10px; text-align: center; }
  .post-content .demo-embed { margin: 28px 0 36px; border: 1px solid #e5e5e5; border-radius: 12px; overflow: hidden; background: #0a0a0f; }
  .post-content .demo-embed iframe { display: block; width: 100%; height: 860px; border: 0; }
  .post-content .demo-embed p { margin: 0; padding: 10px 14px; font-size: 0.82rem; color: #888; text-align: center; background: #fafaf8; border-top: 1px solid #e5e5e5; }
  .post-content footer { margin-top: 80px; padding-top: 24px; border-top: 1px solid #e5e5e5; color: #888; font-size: 0.84rem; }
</style>

<div class="post-lead">
<p class="back-koiro"><a href="https://koiro.me">← koiro.me</a></p>
<div class="tags">
  <span class="tag purple">Quantum Computing</span>
  <span class="tag teal">Qubit</span>
  <span class="tag coral">NISQ</span>
  <span class="tag amber">Post-Quantum</span>
</div>
<p class="intro">A classical bit is always 0 or 1. A qubit exists in superposition until measurement; entanglement and interference let algorithms cancel wrong paths and amplify correct ones. This post is a reference guide to quantum computing—core concepts in one infographic, plus gates, algorithms, applications, and today’s limits.</p>
</div>

<figure class="figure">
  <img src="/images/quantum-computing-guide.png" alt="Quantum computing key concepts — classical bit vs qubit, superposition, entanglement, interference, workflow, applications, NISQ limitations" width="1200" height="auto" loading="lazy" decoding="async">
  <figcaption>Quantum computing key concepts at a glance</figcaption>
</figure>

## 01 · Classical bit vs qubit

| | Classical bit | Qubit |
|---|---------------|-------|
| **State** | 0 or 1 (definite) | α\|0⟩ + β\|1⟩ (superposition, \|α\|²+\|β\|²=1) |
| **Nature** | Deterministic | Probabilistic — collapses on measurement |
| **Copying** | Allowed | Forbidden (no-cloning theorem) |
| **Parallelism** | n bits → n values | n qubits → 2ⁿ states at once |

Classical bits map to transistor voltage levels and do not change when read. Qubits are built from superconductors, ion traps, photons, electron spin, and more; the same circuit can yield different outcomes across runs.

---

## 02 · Three pillars of quantum mechanics

### Superposition

One qubit represents 0 and 1 at once. A Hadamard gate turns \|0⟩ into (|0⟩+|1⟩)/√2; n qubits can encode 2ⁿ states in principle. Measurement collapses the wavefunction to one outcome with a given probability.

### Entanglement

Two qubits share a single quantum state. In a Bell state such as (|00⟩+|11⟩)/√2, measuring one qubit instantly fixes the other—Einstein’s “spooky action at a distance,” confirmed by Bell tests. It does **not** allow faster-than-light messaging; only non-local correlation.

<div class="demo-embed">
  <iframe src="/demos/quantum-entanglement-simulator-en.html" title="Quantum entanglement interactive simulator" loading="lazy"></iframe>
  <p>Try it: create entanglement, then measure particles 11,000 km apart (Seoul ↔ New York) and watch correlation converge to 100%.</p>
</div>

### Interference

Probability amplitudes add like waves, constructively or destructively. Algorithm design hinges on tuning **phase** so correct paths amplify and wrong paths cancel—what separates quantum from classical computation.

---

## 03 · How a quantum computer runs

1. **Initialize** — Reset qubits to \|0⟩. Superconducting devices often run near ~15 mK, colder than the cosmic microwave background.
2. **Apply gates** — Build circuits with Hadamard (superposition), CNOT (entanglement), T/S/Z (phase), Toffoli (universal classical logic), and more.
3. **Control interference** — Shape phases so desired outputs gain amplitude and others fade.
4. **Measure** — Superposition collapses to 0 or 1. Algorithms are run many times to estimate outcome statistics.

---

## 04 · Key quantum gates

| Gate | Role |
|------|------|
| **H (Hadamard)** | \|0⟩ → equal superposition |
| **CNOT** | Flip target when control is \|1⟩; core 2-qubit gate for entanglement |
| **T · S · Z** | Phase rotations by π/4, π/2, π; fine interference control |
| **Toffoli (CCNOT)** | Flip target when both controls are \|1⟩; universal classical logic |

---

## 05 · Major quantum algorithms

| Algorithm | Problem | Speed / note |
|-----------|---------|--------------|
| **Shor (1994)** | Integer factorization | Exponential → polynomial time; threatens RSA/ECC; drives post-quantum crypto (PQC) |
| **Grover (1996)** | Unstructured search | O(N) → O(√N); quadratic speedup, many practical uses |
| **VQE** | Molecular ground energy | Hybrid quantum–classical; **NISQ-friendly**; drug and materials science |
| **QAOA** | Combinatorial optimization | Approximate solutions to NP-hard problems; logistics, portfolios |
| **HHL (2009)** | Linear system Ax=b | Conditional exponential speedup; QML and simulation; I/O overhead debated |
| **Quantum teleportation** | State transfer | Entanglement + classical channel; QKD and quantum internet protocols |

<div class="callout warn">
<strong>Shor vs practice:</strong> Shor could reduce factoring 2048-bit RSA from millennia to hours in theory, but only with large, error-corrected machines. The nearer risk is harvest-now-decrypt-later. NIST finalized post-quantum standards (e.g. CRYSTALS-Kyber) in 2024.
</div>

---

## 06 · Application areas

| Area | Focus |
|------|--------|
| **Cryptography** | Shor threatens public-key schemes · QKD for eavesdrop-proof channels · PQC migration |
| **Drugs & materials** | Molecular and protein-folding simulation; caffeine (C₈H₁₀N₄O₂) needs ~10⁴⁸ classical variables |
| **Finance & optimization** | Portfolios, risk, scheduling; PoCs at JPMorgan, Goldman Sachs, IBM Q Network |
| **Quantum ML** | VQCs, quantum kernels, HHL-based regression; TensorFlow Quantum, PennyLane; still early |

---

## 07 · The NISQ era and its limits

**NISQ** (Noisy Intermediate-Scale Quantum) describes today’s noisy, mid-size devices.

| Metric | Status (~2025) |
|--------|----------------|
| Physical qubits | 1,000+ (e.g. IBM Condor 1121q) |
| Fault-tolerant QC | ~10⁶ physical qubits per logical qubit (estimate) |
| Quantum supremacy | Google Sycamore ~200 s vs ~10,000 years classical (disputed) |

**Main challenges**

- **Decoherence** — Environment destroys quantum state; coherence often tens to hundreds of μs.
- **High error rates** — Two-qubit gates at 0.1–1%; practical work needs ≪0.001%.
- **Cryogenics & scale** — Superconductors near ~15 mK; more qubits mean control, crosstalk, and connectivity pain.

| Player | Notes |
|--------|-------|
| **IBM** | Eagle(127q) → Condor(1121q); 100k-qubit roadmap by 2033; Qiskit |
| **Google** | Willow(105q, 2024); scaling with falling error rates |
| **IonQ** | Ion trap, high fidelity |
| **Korea** | ETRI, national quantum-internet roadmap; Samsung, SK hynix on quantum memory |

<div class="callout">
Quantum computers are not general replacements for classical machines—they are **accelerators for specific problem classes**. Today, hybrid NISQ algorithms (VQE, QAOA) and preparing for a quantum era (PQC) are closer to real engineering work than running Shor at scale.
</div>

<footer>
  Ahhyun Kim · Quantum Computing Complete Guide · 2026-05-15 · A fast-moving research field; details evolve quickly
</footer>
