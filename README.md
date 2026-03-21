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

- **날짜**: 새 글은 **항상 오늘 날짜**로 둡니다. 파일명과 front matter `date` 모두 같은 `YYYY-MM-DD`여야 합니다.
- **오늘 날짜 자동으로 넣기** (터미널):

  ```bash
  date +%Y-%m-%d
  ```

  출력값을 `date:` 값과 파일명 앞부분에 그대로 쓰면 됩니다.

- **스크립트로 스켈레톤 생성** (날짜·파일명 자동):

  ```bash
  chmod +x scripts/new-post.sh   # 최초 1회
  ./scripts/new-post.sh my-post-slug "글 제목"
  ```

  `content/posts/YYYY-MM-DD-my-post-slug.md`가 만들어지고, front matter의 `date`도 같은 날짜로 들어갑니다.

Front matter 예시 (`date`는 위 방법으로 **오늘** 값으로 채우기):

```yaml
---
title: "제목"
date: YYYY-MM-DD
slug: my-post
categories: [roadmap]
tags: [tag1, tag2]
---
```

파일명: `YYYY-MM-DD-slug.md`.

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
