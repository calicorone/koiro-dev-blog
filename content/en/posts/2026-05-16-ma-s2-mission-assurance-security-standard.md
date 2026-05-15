---
layout: post
title: "MA-S2 Complete Guide — Palantir Mission Assurance Security Standard"
title_alt: "MA-S2 완전 가이드 — Palantir 미션 보증 보안 표준"
date: 2026-05-16
slug: ma-s2-mission-assurance-security-standard
author: Ahhyun Kim
tags: ["MA-S2", "Palantir", "Mission-Assurance", "Security-Standard"]
essay: true
translationKey: ma-s2-mission-assurance-security-standard
---

<style>
  .post-content * { box-sizing: border-box; }
  .post-content h2 { font-size: 1.25rem; font-weight: 700; margin-top: 56px; margin-bottom: 16px; padding-bottom: 10px; border-bottom: 2px solid #e5e5e5; }
  .post-content h2:first-of-type { margin-top: 0; }
  .post-content h3 { font-size: 1rem; font-weight: 700; margin-top: 32px; margin-bottom: 10px; color: #3C3489; }
  .post-content p { margin-bottom: 18px; color: #333; line-height: 1.75; }
  .post-content ul { padding-left: 22px; margin-bottom: 18px; }
  .post-content li { margin-bottom: 8px; color: #444; font-size: 0.95rem; line-height: 1.7; }
  .post-content strong { color: #2C2C2A; }
  .post-content .tags { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 36px; }
  .post-content .tag { font-size: 0.78rem; padding: 4px 12px; border-radius: 20px; font-weight: 600; }
  .post-content .tag.blue { background: #E6F1FB; color: #185FA5; }
  .post-content .tag.purple { background: #EEEDFE; color: #3C3489; }
  .post-content .tag.teal { background: #E1F5EE; color: #085041; }
  .post-content .tag.orange { background: #FAEEDA; color: #633806; }
  .post-content .intro { font-size: 1.05rem; line-height: 1.95; color: #444; border-left: 3px solid #4f9cf0; padding-left: 20px; margin-bottom: 32px; }
  .post-content .back-koiro { font-size: 0.82rem; margin-bottom: 1rem; }
  .post-content .back-koiro a { color: #888; text-decoration: none; font-weight: 500; }
  .post-content table { width: 100%; border-collapse: collapse; margin: 24px 0 32px; font-size: 0.88rem; }
  .post-content th { background: #f4f4f0; font-weight: 700; padding: 10px 14px; border: 1px solid #e5e5e5; text-align: left; }
  .post-content td { padding: 9px 14px; border: 1px solid #e5e5e5; color: #444; vertical-align: top; line-height: 1.6; }
  .post-content .callout { background: #E6F1FB; border-left: 4px solid #185FA5; padding: 16px 20px; border-radius: 0 8px 8px 0; margin: 28px 0; font-size: 0.93rem; line-height: 1.75; }
  .post-content .demo-embed { margin: 28px 0 36px; border: 1px solid #e5e5e5; border-radius: 12px; overflow: hidden; background: #fafaf8; }
  .post-content .demo-embed iframe { display: block; width: 100%; height: 7200px; border: 0; }
  .post-content .demo-embed .demo-bar { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 10px; margin: 0; padding: 10px 14px; font-size: 0.82rem; color: #888; background: #fafaf8; border-top: 1px solid #e5e5e5; }
  .post-content .demo-embed .demo-bar a { color: #185FA5; font-weight: 500; text-decoration: none; }
  .post-content .demo-embed .demo-bar a:hover { text-decoration: underline; }
  .post-content footer { margin-top: 80px; padding-top: 24px; border-top: 1px solid #e5e5e5; color: #888; font-size: 0.84rem; }
</style>

<div class="post-lead">
<p class="back-koiro"><a href="https://koiro.me">← koiro.me</a></p>
<div class="tags">
  <span class="tag blue">MA-S2</span>
  <span class="tag purple">Palantir</span>
  <span class="tag teal">Mission Assurance</span>
  <span class="tag orange">Security Standard</span>
</div>
<p class="intro"><strong>MA-S2 (Mission Assurance Security Standard)</strong>, published by Palantir in May 2026, is a new bar for software supply-chain security in the AI era. It defines <strong>4 control domains and 20 controls</strong>. It does not replace SOC 2 or FedRAMP—it layers on top of them. The full reference guide is embedded below.</p>
</div>

## MA-S2 at a glance

| Domain | Code | Controls | One-line summary |
|--------|------|----------|------------------|
| Continuous AI-augmented vulnerability scanning | **CVS** | 5 | Find holes continuously; auto-block Critical findings |
| Attack path modeling | **APM** | 4 | Model attacker chains, not isolated CVEs |
| Real-time software inventory | **INV** | 5 | Answer “what’s running?” in real time via SBOM + runtime |
| Autonomous remediation orchestration | **ARO** | 6 | Patch, rollback, and fleet deploy without human bottlenecks |

<div class="callout">
<strong>Why now:</strong> AI automates vulnerability discovery and chaining, making quarterly scans and CVSS-only triage insufficient—per Palantir CTO Shyam Sankar. Official site: <a href="https://ma-s2.com/#0.0" target="_blank" rel="noopener">ma-s2.com</a>
</div>

## Full reference guide (interactive)

Includes the architecture diagram, all 20 controls, disqualification criteria, attestation requirements, and seven procurement questions.

<div class="demo-embed">
  <iframe src="/demos/ma-s2-guide-en.html" title="MA-S2 Mission Assurance Security Standard full guide" loading="lazy"></iframe>
  <p class="demo-bar">
    <span>Scroll inside the frame for the full document</span>
    <a href="/demos/ma-s2-guide-en.html" target="_blank" rel="noopener">Open full screen in a new tab ↗</a>
  </p>
</div>

## Relationship to existing frameworks

MA-S2 is <strong>complementary</strong> to SOC 2, FedRAMP, DISA IL5/IL6, NIST 800-53, and ISO 27001. Existing frameworks ask whether basics are in place; MA-S2 adds whether you are safe in an AI-native threat landscape.

<div class="callout">
Self-attestation alone is not enough. You need supporting evidence: third-party audits, platform telemetry, architecture review, and contractual SLAs.
</div>

<footer>
  Ahhyun Kim · MA-S2 Complete Guide · 2026-05-16 · Based on Palantir public standard v1.0
</footer>
