# koiro-dev-blog

**Stack:** Hugo, GitHub Actions, GitHub Pages (blog.koiro.me)

개인 로드맵 기반 개발 블로그.

---

## 구조

- **content/posts/** — 마크다운 글. 파일명: `YYYY-MM-DD-slug.md` 또는 `slug.md`
- **layouts/** — Hugo 템플릿 (baseof, index, single, index.json)
- **static/** — CSS, CNAME, 이미지 등
- **config.yaml** — Hugo 설정

## 배포

- `master`에 push하면 GitHub Action이 Hugo로 빌드 후 **gh-pages** 브랜치에 배포합니다.
- Repo **Settings → Pages**: Source를 **Deploy from a branch**로 두고, Branch **gh-pages** / (root) 로 설정.
- Custom domain: `blog.koiro.me` (Actions 워크플로에 cname 설정됨)

## 새 글 쓰기

1. **포트폴리오에서:** koiro.me → Dev Blog → blog.koiro.me에 글쓰기 → GitHub로 게시 (OAuth)
2. **수동:** `content/posts/`에 마크다운 추가 후 push

Front matter 예시:

```yaml
---
title: "제목"
date: 2026-03-15
slug: my-post
categories: [roadmap]
tags: [tag1, tag2]
---
```

## Hugo 설치 (로컬에서 미리보기/빌드할 때)

**방법 1 — Homebrew (권장)**  
권한 오류가 나면 한 번만 아래 실행 후 `brew install hugo`:

```bash
sudo chown -R $(whoami) /opt/homebrew /Users/$(whoami)/Library/Logs/Homebrew
brew install hugo
```

**방법 2 — 설치 스크립트**  
`./scripts/install-hugo.sh` 실행 후 안내에 따르거나, [Hugo Releases](https://github.com/gohugoio/hugo/releases)에서 macOS용 `.pkg` 다운로드 후 설치.

## 로컬 빌드

```bash
hugo server -D
```

빌드만: `hugo --minify` → `public/` 생성.
