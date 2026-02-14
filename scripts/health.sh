#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
cd "$HOME/GPT"

echo "== GIT =="
git status -sb || true
echo

echo "== REQUIRED FILES =="
req=( "עמוד 1.html" "כללים.md" "assets/style.css" "assets/print.js" "scripts/push.sh" )
for f in "${req[@]}"; do
  if [ -f "$f" ]; then
    echo "✅ $f"
  else
    echo "❌ missing: $f"; exit 3
  fi
done
echo

echo "== RAW PDF =="
RAW="https://raw.githubusercontent.com/yanivmizrachiy/GPT/main/pdf/page-1.pdf"
curl -sI "$RAW" | head -n 1 || true
echo "RAW: $RAW"
echo "✅ health OK"
