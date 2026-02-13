#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
msg="${1:-update: pages + rules}"
# לפני הכל: בודק סתירות + בונה rules.html (נאכף גם ב-pre-commit)
./scripts/rules_check.sh
./scripts/build_rules.sh

git add -A
if git diff --cached --quiet; then
  echo "ℹ️ אין שינויים ל-commit"
  exit 0
fi

git commit -m "$msg"
git push -u origin main
echo "✅ pushed"
