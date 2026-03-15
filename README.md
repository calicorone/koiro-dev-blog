# koiro-dev-blog

> **Stack:** Jekyll + GitHub Pages + Cloudflare (blog.koiro.me)  
> **Cost:** 100% free — GitHub builds Jekyll natively.

개인 로드맵 기반 개발 블로그.

---

## blog.koiro.me에서 GitHub 404만 나올 때 (DNS는 이미 됨)

blog.koiro.me가 GitHub 404를 보여주면 **DNS는 정상**입니다. GitHub 쪽만 설정하면 됩니다.

1. **Repo가 있고 Jekyll 파일이 이미 push되어 있다면**
   - [github.com/calicorone/koiro-dev-blog](https://github.com/calicorone/koiro-dev-blog) → **Settings → Pages**
   - **Source:** Branch `master`, Folder **/ (root)** → **Save**
   - **Custom domain:** `blog.koiro.me` 입력 → **Save**
   - 1–2분 후 빌드되면 사이트가 뜹니다. 인증되면 **Enforce HTTPS** 체크.

2. **Repo가 비어 있거나 아직 없다면** 아래 "로컬에서 만든 뒤 GitHub에 올리기" 순서대로 진행.

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
   git branch -M master
   git remote add origin https://github.com/<your-username>/koiro-dev-blog.git
   git push -u origin master
   ```

3. **GitHub Pages 켜기**
   - Repo **Settings → Pages**
   - Source: Branch `master`, Folder `/ (root)` → Save

4. **커스텀 도메인 (GitHub Pages 설정)**
   - Repo 루트에 `CNAME` 파일 있음 (내용: `blog.koiro.me`)
   - Settings → Pages → Custom domain: `blog.koiro.me` 입력 후 Save
   - 도메인 인증 후 **Enforce HTTPS** 체크

5. **Cloudflare: DNS만 사용 (Cloudflare Pages 아님)**
   - **Cloudflare Pages는 사용하지 않습니다.** 호스팅은 GitHub Pages가 하고, Cloudflare는 DNS만 씁니다.
   - 경로: [dash.cloudflare.com](https://dash.cloudflare.com) → **koiro.me** 클릭 → 왼쪽 **DNS** → **Records** → **Add record**
   - `blog` 서브도메인용 **A 레코드 4개** 추가 (Proxy: **DNS only** — 회색 구름):
     - 185.199.108.153  
     - 185.199.109.153  
     - 185.199.110.153  
     - 185.199.111.153  
   - 이렇게 하면 blog.koiro.me가 GitHub 서버를 가리키고, GitHub Pages가 빌드한 사이트가 보입니다.

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
