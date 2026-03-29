#!/usr/bin/env bash
# Create KO + EN post skeletons (same basename) for bilingual blog.
# Usage: ./scripts/new-post.sh my-post-slug "Post title"
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SLUG="${1:?Usage: $0 <slug> [title_ko]}"
TITLE_KO="${2:-New post}"
TITLE_EN="${3:-$TITLE_KO (EN)}"
TODAY="$(date +%Y-%m-%d)"
FILE_KO="${ROOT}/content/ko/posts/${TODAY}-${SLUG}.md"
FILE_EN="${ROOT}/content/en/posts/${TODAY}-${SLUG}.md"

if [[ -e "$FILE_KO" || -e "$FILE_EN" ]]; then
  echo "Already exists: $FILE_KO or $FILE_EN" >&2
  exit 1
fi

FM_KO() {
  cat <<EOF
---
title: "${TITLE_KO}"
title_alt: "${TITLE_EN}"
date: ${TODAY}
slug: ${SLUG}
tags: []
translationKey: ${SLUG}
---

본문 (KO)
EOF
}

FM_EN() {
  cat <<EOF
---
title: "${TITLE_EN}"
title_alt: "${TITLE_KO}"
date: ${TODAY}
slug: ${SLUG}
tags: []
translationKey: ${SLUG}
---

Body (EN)
EOF
}

FM_KO > "$FILE_KO"
FM_EN > "$FILE_EN"

echo "Created:"
echo "  $FILE_KO"
echo "  $FILE_EN"
echo "date: ${TODAY}"
echo "translationKey: ${SLUG}"
