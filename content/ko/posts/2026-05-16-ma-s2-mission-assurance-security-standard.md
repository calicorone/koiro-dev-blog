---
layout: post
title: "MA-S2 완전 가이드 — Palantir 미션 보증 보안 표준"
title_alt: "MA-S2 Complete Guide — Palantir Mission Assurance Security Standard"
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
  .post-content .demo-embed { margin: 28px 0 36px; border: 1px solid #e5e5e5; border-radius: 12px; overflow: hidden; background: #08090d; }
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
  <span class="tag teal">미션 보증</span>
  <span class="tag orange">보안 표준</span>
</div>
<p class="intro">Palantir가 2026년 5월 공개한 <strong>MA-S2(Mission Assurance Security Standard)</strong>는 AI 시대의 소프트웨어 공급망 보안을 다루는 새 기준입니다. 4개 통제 도메인·20개 컨트롤로 구성되며, SOC 2·FedRAMP를 대체하지 않고 그 위에 얹는 <strong>차세대 요구사항</strong>으로 설계되었습니다. 아래에 전체 레퍼런스 가이드를 임베드했습니다.</p>
</div>

## MA-S2 한눈에 보기

| 도메인 | 약어 | 컨트롤 수 | 핵심 한 줄 |
|--------|------|-----------|-----------|
| 지속적 AI 강화 취약점 스캐닝 | **CVS** | 5 | 구멍을 쉬지 않고 찾고, Critical은 자동으로 막아라 |
| 공격 경로 모델링 | **APM** | 4 | CVE 하나가 아니라 해커 입장의 연결 고리를 모델링하라 |
| 실시간 소프트웨어 인벤토리 | **INV** | 5 | 지금 무엇이 돌아가는지 SBOM·런타임으로 실시간 대답하라 |
| 자율 교정 오케스트레이션 | **ARO** | 6 | 패치·롤백·플릿 전체 배포를 사람 병목 없이 자동화하라 |

<div class="callout">
<strong>왜 나왔나:</strong> AI가 취약점 탐색·체이닝을 자동화하면서, 분기 1회 스캔·CVSS만 보는 전통 방식이 부족해졌다는 Palantir CTO Shyam Sankar의 메시지가 배경입니다. 공식 문서: <a href="https://ma-s2.com/#0.0" target="_blank" rel="noopener">ma-s2.com</a>
</div>

## 전체 레퍼런스 가이드 (인터랙티브)

아키텍처 다이어그램, 20개 컨트롤 상세, 실격 조건, 어테스테이션, 조달 평가 질문 7가지까지 포함한 전체 가이드입니다.

<div class="demo-embed">
  <iframe src="/demos/ma-s2-guide-ko.html" title="MA-S2 미션 보증 보안 표준 전체 가이드" loading="lazy"></iframe>
  <p class="demo-bar">
    <span>스크롤하여 전체 내용을 확인하세요</span>
    <a href="/demos/ma-s2-guide-ko.html" target="_blank" rel="noopener">새 탭에서 전체 화면으로 보기 ↗</a>
  </p>
</div>

## 기존 인증과의 관계

MA-S2는 SOC 2, FedRAMP, DISA IL5/IL6, NIST 800-53, ISO 27001과 **상호 보완**입니다. 기존 프레임워크가 “기본은 갖췄는가”를 본다면, MA-S2는 “AI 시대에 실제로 안전한가”를 추가로 묻습니다.

<div class="callout">
자기 어테스테이션만으로는 불충분합니다. 3rd-party 감사, 플랫폼 텔레메트리, 아키텍처 검토, SLA 계약 등 **지원 증거**가 필요합니다.
</div>

<footer>
  Ahhyun Kim · MA-S2 완전 가이드 · 2026-05-16 · Palantir 공개 표준 v1.0 기준 정리
</footer>
