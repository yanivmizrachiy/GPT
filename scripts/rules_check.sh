#!/data/data/com.termux/files/usr/bin/bash
set -e

f="RULES.md"
[ -f "$f" ] || { echo "❌ RULES.md missing"; exit 2; }

txt=$(cat "$f")

echo "$txt" | grep -qi "הפרדה מוחלטת" || { echo "❌ missing separation rule"; exit 3; }
echo "$txt" | grep -qi "אין דמו" || { echo "❌ missing no-demo rule"; exit 3; }
echo "$txt" | grep -qi "PDF" || { echo "❌ missing PDF rule"; exit 3; }

bad=$(grep -RIn --exclude-dir=.git --include="עמוד *.html" -E "<style|style=" . || true)
[ -z "$bad" ] || { echo "❌ inline CSS found"; exit 4; }

echo "✅ rules_check OK"
