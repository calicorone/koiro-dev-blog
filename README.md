# koiro-dev-blog

> **Stack:** Jekyll + GitHub Pages + Cloudflare (blog.koiro.me)  
> **Cost:** 100% free — GitHub builds Jekyll natively.

개인 로드맵 기반 개발 블로그.

---

## 로컬에서 만든 뒤 GitHub에 올리기

1. **GitHub에서 빈 저장소 만들기**
   - [github.com/new](https://github.com/new)
   - Repository name: `koiro-dev-blog`
   - Public, "Add a README file" 선택 후 Create

2. **이 폴더를 새 repo로 push**
   ```bash
   cd koiro-dev-blog
   git init
   git add .
   git commit -m "Initial Jekyll site for blog.koiro.me"
   git branch -M main
   git remote add origin https://github.com/<your-username>/koiro-dev-blog.git
   git push -u origin main
   ```

3. **GitHub Pages 켜기**
   - Repo **Settings → Pages**
   - Source: Branch `main`, Folder `/ (root)` → Save

4. **커스텀 도메인**
   - Repo 루트에 `CNAME` 파일 있음 (내용: `blog.koiro.me`)
   - Settings → Pages → Custom domain: `blog.koiro.me` 입력 후 Save
   - Cloudflare에서 `blog` 서브도메인 A 레코드 4개 (185.199.108.153, 185.199.109.153, 185.199.110.153, 185.199.111.153) — **DNS only**
   - 도메인 인증 후 **Enforce HTTPS** 체크

---

## 새 글 쓰기

`_posts/` 안에 파일 추가. 파일명 형식: `YYYY-MM-DD-제목.md`

```markdown
---
layout: post
title: "Your Post Title"
date: YYYY-MM-DD
categories: [roadmap, til, project]
tags: [react, typescript]
---

본문은 마크다운으로.
```

---

## 폴더 구조

```
koiro-dev-blog/
├── _config.yml      # 사이트 설정
├── CNAME            # blog.koiro.me
├── index.md         # 홈
├── README.md
└── _posts/
    └── 2026-03-15-hello-world.md
```

완료 후 라이브 주소: **https://blog.koiro.me**
