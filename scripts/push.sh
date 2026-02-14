#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
# --- PREPUSH (hard governance) ---
if [ -x "./scripts/prepush.sh" ]; then
  ./scripts/prepush.sh
fi


msg="${1:-update}"
what="${2:-}"
next="${3:-}"

# --- auto journal entry (unless user already wrote one just now) ---
./scripts/note.sh "$msg" "$what" "$next" >/dev/null 2>&1 || true

# --- normalize rules (dedupe) ---
python scripts/rules_normalize.py >/dev/null 2>&1 || true

# --- checks + build rules.html ---
./scripts/rules_check.sh
./scripts/build_rules.sh

# --- optionally rebuild index if script exists ---
[ -x scripts/rebuild_index.sh ] && ./scripts/rebuild_index.sh >/dev/null 2>&1 || true

git add -A
if git diff --cached --quiet; then
  echo "ℹ️ אין שינויים ל-commit"
  exit 0
fi

git commit -m "$msg" >/dev/null 2>&1 || true

# safe push (autostash + rebase + retry) — minimal, no $1 unbound
autostash(){
  if git diff --quiet && git diff --cached --quiet; then
    echo ""
    return 0
  fi
  git stash push -u -m "autostash: before rebase" >/dev/null 2>&1 || true
  echo "1"
}
unstash(){
  [ "${1:-}" = "1" ] && git stash pop >/dev/null 2>&1 || true
}

try_push(){
  git fetch origin >/dev/null 2>&1 || true
  git pull --rebase origin main >/dev/null 2>&1 || true
  git push origin main >/dev/null 2>&1
}

STASHED="$(autostash)"
git fetch origin >/dev/null 2>&1 || true
git pull --rebase origin main >/dev/null 2>&1 || true
unstash "$STASHED"

if try_push; then
  echo "✅ pushed safely"
  exit 0
fi

echo "⚠️ push failed once, retrying after rebase..."
git fetch origin >/dev/null 2>&1 || true
git pull --rebase origin main >/dev/null 2>&1 || true
try_push
echo "✅ pushed safely (retry)"
