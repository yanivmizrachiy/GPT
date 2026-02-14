#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

# Only enforce on task pages + index (rules.html is allowed to have styles)
FILES=()
[ -f "index.html" ] && FILES+=("index.html")
for f in עמוד\ *.html; do
  [ -f "$f" ] && FILES+=("$f")
done

# No inline CSS in these files:
# - no <style> blocks
# - no style= attributes
bad="0"
for f in "${FILES[@]}"; do
  if rg -n -S "(<style\\b|\\sstyle=)" -- "$f" >/dev/null 2>&1; then
    echo "❌ PRINT_GUARD: inline CSS found in $f"
    rg -n -S "(<style\\b|\\sstyle=)" -- "$f" | head -n 120 || true
    bad="1"
  fi
done

if [ "$bad" = "1" ]; then
  exit 4
fi

echo "✅ PRINT_GUARD OK"
