#!/usr/bin/env bash
# Hugo 설치 (macOS)
# 방법 1: Homebrew (권장) — 터미널에서 한 번만 권한 수정 후 실행
# 방법 2: .pkg 수동 설치

set -e
BLOG_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$BLOG_ROOT"

echo "=== Hugo 설치 (macOS) ==="
echo ""

if command -v hugo &>/dev/null; then
  echo "Hugo가 이미 설치되어 있습니다: $(hugo version)"
  exit 0
fi

# Homebrew로 시도
if command -v brew &>/dev/null; then
  echo "Homebrew로 설치를 시도합니다..."
  if brew install hugo 2>/dev/null; then
    echo "설치 완료: $(hugo version)"
    exit 0
  fi
  echo ""
  echo "Homebrew 권한 오류가 났다면, 터미널에서 아래를 실행한 뒤 다시 실행하세요:"
  echo "  sudo chown -R \$(whoami) /opt/homebrew /Users/\$USER/Library/Logs/Homebrew"
  echo "  brew install hugo"
  echo ""
fi

# .pkg 다운로드
HUGO_VERSION="0.157.0"
PKG_URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_darwin-universal.pkg"
PKG_NAME="hugo_${HUGO_VERSION}_darwin-universal.pkg"

echo "Homebrew 설치가 안 되면 .pkg로 설치할 수 있습니다."
echo "다운로드: $PKG_URL"
echo ""
read -p ".pkg를 다운로드할까요? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  mkdir -p bin
  curl -sL "$PKG_URL" -o "bin/$PKG_NAME"
  echo "다운로드 완료: bin/$PKG_NAME"
  echo "설치: 더블클릭하거나 터미널에서 실행: open bin/$PKG_NAME"
  open "bin/$PKG_NAME" 2>/dev/null || true
fi
