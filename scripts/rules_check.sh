set -euo pipefail
cd "$HOME/GPT"

CANON="כללים.md"
[ -f "$CANON" ] || { echo "❌ missing $CANON"; exit 10; }

echo "== RULES_CHECK: parse structured sections =="
JSON=$(python ./scripts/parse_rules.py)
echo "$JSON" >/dev/null

need(){ python - <<PY
import json,sys
data=json.loads(sys.stdin.read())
key=sys.argv[1]
print("\n".join(data.get(key,[])))
PY
}

echo "== REQUIRED FILES =="
while IFS= read -r f; do
  [ -z "$f" ] && continue
  [ -f "$f" ] && echo "✅ $f" || { echo "❌ missing: $f"; exit 11; }
done < <(echo "$JSON" | python -c "import sys,json; d=json.load(sys.stdin); print('\\n'.join(d['REQUIRED FILES']))")

echo "== REQUIRED SCRIPTS =="
while IFS= read -r s; do
  [ -z "$s" ] && continue
  [ -f "$s" ] && echo "✅ $s" || { echo "❌ missing: $s"; exit 12; }
done < <(echo "$JSON" | python -c "import sys,json; d=json.load(sys.stdin); print('\\n'.join(d['REQUIRED SCRIPTS']))")

echo "== PRINT RULES =="
./scripts/print_guard.sh

# baseline: no inline CSS (already checked) + no pages 2-4 (page1-only mode)
if [ -f "עמוד 2.html" ] || [ -f "עמוד 3.html" ] || [ -f "עמוד 4.html" ]; then
  echo "❌ page1-only violated (found page 2-4)"; exit 13;
fi

echo "✅ rules_check OK: כללים תקינים + GOV2 structured enforcement";
