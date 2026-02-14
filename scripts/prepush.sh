set -euo pipefail
cd "${HOME}/GPT"
TODAY="$(date +%F)"
CANON="כללים.md"
echo "== PREPUSH: enforce journal today =="
grep -q "^### $TODAY" "$CANON" && echo "✅ journal exists for $TODAY" || { echo "❌ אין ביומן רישום להיום ($TODAY)."; exit 9; }
echo "== PREPUSH: run rules_check + build_rules =="
./scripts/rules_check.sh
./scripts/build_rules.sh
echo "✅ PREPUSH OK"
