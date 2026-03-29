# koiro-dev-blog

**Stack:** Hugo, GitHub Actions, GitHub Pages (blog.koiro.me)

개인 로드맵 기반 개발 블로그.

---

## 구조

- **content/ko/posts/** — 기본 언어(한국어) 마크다운 글
- **content/en/posts/** — 영어 글 (**파일명은 KO와 동일**해야 `posts.json`·언어 전환이 맞음)
- **layouts/** — Hugo 템플릿 (baseof, index, single, index.json)
- **static/** — CSS, CNAME, 이미지 등
- **config.yaml** — Hugo 다국어 설정 (`languages.ko` / `languages.en`)

## 배포

- `master`에 push하면 GitHub Action이 **KO/EN 짝 검사** 후 Hugo로 빌드하고 **gh-pages**에 배포합니다.
- Repo **Settings → Pages**: Source **Deploy from a branch** → Branch **gh-pages** / (root).
- Custom domain: `blog.koiro.me`

## 새 글 쓰기 (KO + EN 항상 같이)

1. **스크립트 (권장):** KO·EN에 같은 날짜·슬러그 파일을 한 번에 만듭니다.

   ```bash
   chmod +x scripts/new-post.sh   # 최초 1회
   ./scripts/new-post.sh my-post-slug "한글 제목" "English title"
   ```

   - `content/ko/posts/YYYY-MM-DD-my-post-slug.md`
   - `content/en/posts/YYYY-MM-DD-my-post-slug.md`
   - 둘 다 front matter에 `translationKey: my-post-slug`가 들어갑니다.

2. **수동:** KO에만 추가했다면 EN에 **동일 파일명**으로 글을 추가하거나, 임시 스텁 생성:

   ```bash
   node scripts/sync-en-stubs.js
   ```

3. **검증 (로컬 / CI 동일):**

   ```bash
   node scripts/verify-en-parity.js
   ```

   KO `posts`에 있는 모든 `.md`에 대해 `content/en/posts/`에 같은 이름의 파일이 있어야 합니다.

Front matter 예시:

```yaml
---
title: "제목"
title_alt: "English title"
date: YYYY-MM-DD
slug: my-post
tags: [tag1, tag2]
translationKey: my-post
---
```

- **`translationKey`**: Hugo가 번역 쌍으로 묶는 데 사용합니다. 보통 `slug`와 같게 두면 됩니다.
- 파일명: `YYYY-MM-DD-slug.md` (KO·EN 동일).

## Hugo 설치 (로컬)

**Homebrew:** `brew install hugo` (extended 권장)  
또는 `./scripts/install-hugo.sh` / [Hugo Releases](https://github.com/gohugoio/hugo/releases).

## 로컬 빌드

```bash
hugo server -D
```

빌드만: `hugo --minify` → `public/`.
