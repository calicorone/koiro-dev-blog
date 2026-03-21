#!/usr/bin/env bash
# 새 글 스켈레톤 — front matter의 date와 파일명에 오늘 날짜를 자동으로 넣습니다.
# 사용: ./scripts/new-post.sh my-post-slug ["글 제목"]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SLUG="${1:?Usage: $0 <slug> [title]}"
TITLE="${2:-New post}"
TODAY="$(date +%Y-%m-%d)"
FILE="${ROOT}/content/posts/${TODAY}-${SLUG}.md"

if [[ -e "$FILE" ]]; then
  echo "Already exists: $FILE" >&2
  exit 1
fi

cat > "$FILE" <<EOF
---
title: "${TITLE}"
date: ${TODAY}
slug: ${SLUG}
tags: []
---

본문을 여기에 작성합니다.
EOF

echo "Created: $FILE"
echo "date: ${TODAY} (today)"
