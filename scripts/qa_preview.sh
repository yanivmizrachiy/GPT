#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
cd "$HOME/GPT"

PDF="${1:-$HOME/storage/shared/Download/page-1.pdf}"
[ -f "$PDF" ] || { echo "❌ PDF not found: $PDF"; exit 3; }

TS="$(date +%Y%m%d-%H%M%S)"
OUTDIR="qa"
BASE="$OUTDIR/page-1-$TS"

if command -v pdftoppm >/dev/null 2>&1; then
  # page 1 only, png
  pdftoppm -f 1 -l 1 -png "$PDF" "$BASE" >/dev/null 2>&1 || {
    echo "❌ pdftoppm failed"; exit 4;
  }
  # pdftoppm adds -1 suffix
  if [ -f "${BASE}-1.png" ]; then
    echo "✅ preview: ${BASE}-1.png"
  else
    echo "⚠️ preview file not found (unexpected)"; ls -lah "$OUTDIR" | tail -n 20 || true
  fi
else
  echo "⚠️ pdftoppm missing -> skipping PNG preview"
fi
