#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

msg="${1:-update}"

# 1) אם יש שינויים לא שמורים — stash זמני אוטומטי
STASHED=0
if ! git diff --quiet || ! git diff --cached --quiet; then
  git stash push -u -m "autostash: before rebase" >/dev/null
  STASHED=1
fi

# 2) מביא remote ומבצע rebase נקי
git fetch origin >/dev/null
git pull --rebase origin main >/dev/null

# 3) מחזיר את השינויים מה-stash אם היה
if [ "$STASHED" = "1" ]; then
  git stash pop >/dev/null || true
fi

# 4) בדיקות חובה + בנייה אוטומטית של rules.html
./scripts/rules_check.sh
./scripts/build_rules.sh

# 5) commit+push
git add -A
if git diff --cached --quiet; then
  echo "ℹ️ אין שינויים ל-commit"
  exit 0
fi

git commit -m "$msg"
git push origin main
echo "✅ pushed safely (autostash+rebase)"
