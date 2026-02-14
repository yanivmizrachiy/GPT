#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
cd "$HOME/GPT"

TS="$(date +%Y%m%d-%H%M%S)"
OUT="qa/state-$TS.json"

# רשימת קבצים רלוונטיים + hash
FILES=(
  "עמוד 1.html"
  "index.html"
  "כללים.md"
  "RULES.md"
  "rules.html"
  "assets/style.css"
  "assets/print.js"
  "assets/graphs.js"
  "assets/page1.js"
  "scripts/push.sh"
  "scripts/prepush.sh"
  "scripts/rules_check.sh"
  "scripts/build_rules.sh"
  "scripts/parse_rules.py"
  "scripts/print_guard.sh"
  "scripts/dev_mode.sh"
  "scripts/health.sh"
  "scripts/get_pdf.sh"
  "scripts/qa_print.sh"
)

tmp="$(mktemp)"
echo "{" > "$tmp"
echo "  \"ts\": \"$(date -Iseconds)\"," >> "$tmp"
echo "  \"git\": {" >> "$tmp"
echo "    \"branch\": \"$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)\"," >> "$tmp"
echo "    \"commit\": \"$(git rev-parse HEAD 2>/dev/null || echo unknown)\"," >> "$tmp"
echo "    \"status\": \"$(git status -sb 2>/dev/null | head -n 1 | sed 's/"/'\\\"'/g' )\"" >> "$tmp"
echo "  }," >> "$tmp"
echo "  \"files\": [" >> "$tmp"

first="1"
for f in "${FILES[@]}"; do
  [ -f "$f" ] || continue
  h="$(sha256sum "$f" | awk "{print \$1}")"
  sz="$(wc -c < "$f" | tr -d " ")"
  if [ -n "$first" ]; then first=""; else echo "    ," >> "$tmp"; fi
  echo "    {\"path\":\"$f\",\"bytes\":$sz,\"sha256\":\"$h\"}" >> "$tmp"
done

echo "  ]" >> "$tmp"
echo "}" >> "$tmp"

mv "$tmp" "$OUT"
echo "✅ snapshot: $OUT"
