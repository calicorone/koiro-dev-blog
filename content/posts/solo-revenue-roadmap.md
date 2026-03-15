---
title: "Solo revenue roadmap — what to touch now"
date: 2026-03-16
categories: [roadmap, sideseat, quant]
tags: [roadmap, sideseat, quant, cursor, mac-mini, agents]
---

A realistic solo revenue roadmap based on what's actually in progress: SideSeat + Quant, 3–4 hrs/day after work, Cursor and agents in the loop.

![Solo revenue roadmap diagram — Phase 1–4, targets, agents](/assets/solo-revenue-roadmap.svg)

---

## Phase 1 is the only thing you should touch right now

**SideSeat is ~80% done.** The participation API (join / accept / reject), notifications (email or push with Supabase), and reviews + reports (trust foundation) are maybe **2 weeks in Cursor**. Ship it first and get real users before building anything new.

---

## Mac mini timing: wait until Phase 3

You don't need a Mac mini for SideSeat at all — **Cloudflare + Supabase** handle everything. Buy it when you're ready to run a **24hr local trading pipeline**. That way the purchase has immediate purpose (Quant data + backtest runner), not "someday."

---

## Revenue sequence

1. **SideSeat generates cash first** — freemium → host badges → venue deals.
2. That **funds quant capital**. Quant comes second because it needs real money to matter: even a 20% annual return on ₩1M is nothing. You want **₩5–10M+** in the strategy before it feels real.

---

## Agents throughout: add one small agent per phase

You don't build a big "agent system" upfront. Each phase adds **one small agent** — moderation bot, backtest runner, alert sender. They compound over time.

**Agents running in background (all phases):**

- Data collector  
- Backtest runner  
- Moderation  
- Telegram alerts  

---

## What to tackle first?

- **Option A:** Knock out the Phase 1 SideSeat APIs in Cursor (participation, notifications, reviews).  
- **Option B:** Sketch the quant data pipeline structure (KRX / yfinance → Postgres) so it's ready when you hit Phase 3.

Which one do you want to start with?
