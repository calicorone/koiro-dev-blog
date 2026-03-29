---
title: "Web guide for building & training GPT-2 124M (hibiki)"
title_alt: "GPT-2 124M 빌드·학습을 도와주는 웹 가이드"
date: 2026-03-19
slug: hibiki-gpt2-124m-web-guide
tags: ["GPT-2", "ML", "hibiki", "web", "guide"]
math: true
translationKey: hibiki-gpt2-124m-web-guide
---

**hibiki** is a from-scratch **GPT-2 124M** training repo with a companion **web UI** (`web/`). It follows Andrej Karpathy’s walkthroughs ([Let’s reproduce GPT-2 (124M)](https://youtu.be/wjZofJX0v4M), [Let’s build the GPT Tokenizer](https://youtu.be/l8pRSuU81PU)): Python training (`train_gpt2.py`) plus a Vite+React app for commands, diagrams, and study notes.

## Repository

<div class="link-bookmark">
  <a href="https://github.com/calicorone/hibiki" target="_blank" rel="noopener noreferrer">hibiki — GPT-2 124M from scratch</a>
  <div class="link-bookmark-url">https://github.com/calicorone/hibiki</div>
  <p class="link-bookmark-meta">Python 3.10+ · <code>train_gpt2.py</code> · Vite+React <code>web/</code> · KO/EN i18n</p>
</div>

---

## Home screen

Dark UI, gold accents, Overview / Build / Visualization / Learn / Attention paper nav, plus a **KO | EN** toggle.

<div class="hibiki-showcase">
  <img src="/images/hibiki-homepage.png" alt="hibiki web home — GPT-2 124M from scratch, Goals, Architecture" width="1200" height="675" loading="lazy" decoding="async">
  <p class="hibiki-showcase-caption">hibiki web UI — local <code>npm run dev</code> (Vite default port 5173)</p>
</div>

---

## Layout

| Path | Role |
|------|------|
| Repo root | `train_gpt2.py`, model/data/training (Python 3.10+) |
| `web/` | Vite + React — command builder, pipeline/architecture views, study guide, Attention paper |

---

## Python environment

```bash
pip install -e .
# Optional: Hugging Face checkpoint checks, etc.
pip install -e ".[pretrained]"
```

Copy generated commands from the **Build model** page or follow `train_gpt2.py --help`.

---

## Web UI (`web/`)

```bash
cd web
npm install
npm run dev
```

Open **http://localhost:5173**. Production build: `npm run build` → `web/dist/`.

### Main routes

| Route | Content |
|-------|---------|
| `/` | Overview, architecture/optim summary, quick start |
| `/build` | Modes & hyperparameters → pasteable `train_gpt2.py` command |
| `/viz` | Pipeline, GPT-2 block diagram, four pillars (embed · attention · MLP · unembed), interactive tokenizer tab |
| `/learn` | Step-by-step implementation/training concepts |
| `/attention-is-all-you-need` | [Attention Is All You Need](https://arxiv.org/abs/1706.03762) notes, KaTeX + SVG, links to viz |

Header **KO / EN** persists language in `localStorage`.

### Feature recap

- **Build**: overfit / pretrained / train modes, hyperparameters, one-line explanations per flag.
- **Learn**: chapters 1–8 + appendix—sequences, Pre-LN, loss, backward, AdamW, …
- **Visualization**: pipeline cards, 12 blocks, **Tokenization** tab (BPE, encode/decode diagrams, chapter links).

---

## Stack

- **Front**: React 18, TypeScript, Vite, React Router  
- **Styling**: CSS variables, dark global theme  
- **i18n**: custom ko/en + `localStorage`  

Training stays local via `train_gpt2.py` (no backend in the web app).

---

## Dev notes

- Run `cd web && npm install` after clone (`node_modules` not committed).  
- `.cursorrules` captures model/coding guidance (Pre-LN, weight tying, Flash Attention, …).

---

## Audience

- Anyone implementing GPT-2 124M from scratch with Karpathy-style guidance  
- Beginners tuning LR, batch size, gradient accumulation  
- Teams onboarding via **Build → Learn → Visualization**

---

## How an LLM works (short)

An autoregressive LM predicts the next token given prior context. Conceptually:

> **Tokenizer → token embedding → positional/context encoding → Transformer blocks → logits → softmax → sampling → decode**

**Tokenizer** maps text to subword IDs (often **BPE**). **Embeddings** turn IDs into vectors; **positional** information fixes order; **self-attention** mixes token representations; **FFN** refines each position; a final **linear + softmax** yields next-token probabilities. Training minimizes **cross-entropy** against the true next token; generation uses **greedy**, **top-k**, **top-p**, or **temperature** sampling.

For the full Korean walkthrough with tables, formulas ($p_j = \frac{e^{z_j}}{\sum_k e^{z_k}}$, etc.), and section-by-section detail, see the [Korean edition of this post](https://blog.koiro.me/2026/03/19/hibiki-gpt2-124m-web-guide/).

---

## References

<div class="link-bookmark">
  <a href="https://github.com/karpathy/nanoGPT" target="_blank" rel="noopener noreferrer">nanoGPT — Karpathy</a>
  <div class="link-bookmark-url">https://github.com/karpathy/nanoGPT</div>
  <p class="link-bookmark-meta">Minimal GPT training code—pairs well with hibiki and the lectures.</p>
</div>

<div class="link-bookmark">
  <a href="https://youtu.be/wjZofJX0v4M" target="_blank" rel="noopener noreferrer">Let’s reproduce GPT-2 (124M) — YouTube</a>
  <div class="link-bookmark-url">https://youtu.be/wjZofJX0v4M</div>
  <p class="link-bookmark-meta">Andrej Karpathy · model + training pipeline</p>
</div>

<div class="link-bookmark">
  <a href="https://youtu.be/l8pRSuU81PU" target="_blank" rel="noopener noreferrer">Let’s build the GPT Tokenizer — YouTube</a>
  <div class="link-bookmark-url">https://youtu.be/l8pRSuU81PU</div>
  <p class="link-bookmark-meta">Andrej Karpathy · BPE tokenizer build</p>
</div>

<div class="video-embed">
<iframe src="https://www.youtube.com/embed/wjZofJX0v4M" title="YouTube — Let’s reproduce GPT-2 (124M)" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen loading="lazy"></iframe>
</div>

<p class="video-caption"><a href="https://youtu.be/wjZofJX0v4M" target="_blank" rel="noopener noreferrer">Let’s reproduce GPT-2 (124M)</a> — YouTube</p>

<div class="video-embed">
<iframe src="https://www.youtube.com/embed/l8pRSuU81PU" title="YouTube — Let’s build the GPT Tokenizer" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen loading="lazy"></iframe>
</div>

<p class="video-caption"><a href="https://youtu.be/l8pRSuU81PU" target="_blank" rel="noopener noreferrer">Let’s build the GPT Tokenizer</a> — YouTube</p>

If commands feel heavy, follow **Build → Learn → Visualization** in the web app; flip **KO / EN** when sharing with a mixed team.
