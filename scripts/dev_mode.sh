set -euo pipefail
cd "$HOME/GPT"

echo "== DEV MODE =="
./scripts/audit.sh 2>/dev/null || true
./scripts/print_guard.sh
./scripts/rules_check.sh
./scripts/snapshot.sh 2>/dev/null || true

RAW="https://raw.githubusercontent.com/yanivmizrachiy/GPT/main/pdf/page-1.pdf"
echo "== RAW PDF =="
curl -sI "$RAW" | head -n 1 || true
echo "RAW: $RAW"
echo "✅ DEV MODE OK"
