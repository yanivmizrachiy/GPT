#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

msg="${1:-update}"

git pull --rebase origin main || true

./scripts/rules_check.sh
./scripts/build_rules.sh

git add -A

if git diff --cached --quiet; then
  echo "ℹ️ אין שינויים"
  exit 0
fi

git commit -m "$msg"
git push origin main
echo "✅ pushed safely"
