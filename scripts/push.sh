#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
msg="${1:-update}"

autostash(){
  if ! git diff --quiet || ! git diff --cached --quiet; then
    git stash push -u -m "autostash: before sync" >/dev/null
    echo "1"
  else
    echo "0"
  fi
}

unstash(){
  if [ "${1:-0}" = "1" ]; then
    git stash pop >/dev/null || true
  fi
}

try_push(){
  # checks + build rules
  ./scripts/rules_check.sh
  ./scripts/build_rules.sh

  git add -A
  if git diff --cached --quiet; then
    echo "ℹ️ אין שינויים ל-commit"
    return 0
  fi

  git commit -m "$msg" >/dev/null || true

  # rebase again right before push (handles Actions commits)
  git fetch origin >/dev/null
  git pull --rebase origin main >/dev/null

  git push origin main
}

STASHED="$(autostash)"

# initial sync
git fetch origin >/dev/null
git pull --rebase origin main >/dev/null

unstash "$STASHED"

# push with 2 attempts
if try_push; then
  echo "✅ pushed safely"
  exit 0
fi

echo "⚠️ push failed once, retrying after rebase..."
git fetch origin >/dev/null
git pull --rebase origin main >/dev/null
try_push

echo "✅ pushed safely (retry)"
