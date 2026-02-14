#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
PDF="${1:-$HOME/storage/shared/Download/page-1.pdf}"
[ -f "$PDF" ] || { echo "❌ PDF not found: $PDF"; exit 3; }

echo "== PDF CHECKS =="
# 1) size sanity
BYTES="$(wc -c < "$PDF" | tr -d " ")"
[ "$BYTES" -gt 12000 ] || { echo "❌ PDF too small ($BYTES bytes)"; exit 4; }
echo "✅ size OK: $BYTES bytes"

# 2) A4 dimensions (points)
if command -v pdfinfo >/dev/null 2>&1; then
  SZ="$(pdfinfo "$PDF" 2>/dev/null | grep -i "^Page size:" || true)"
  echo "$SZ" | grep -E "595(\.[0-9]+)? x 842(\.[0-9]+)? pts" >/dev/null 2>&1 && \
    echo "✅ A4 OK (595x842 pts)" || { echo "❌ not A4? $SZ"; exit 5; }
else
  echo "⚠️ pdfinfo missing -> skipping A4 dimension check"
fi

# 3) content (text length) – not perfect but real signal
if command -v pdftotext >/dev/null 2>&1; then
  tmp="$(mktemp)"
  pdftotext "$PDF" "$tmp" >/dev/null 2>&1 || true
  CHARS="$(wc -c < "$tmp" | tr -d " ")"
  rm -f "$tmp"
  [ "$CHARS" -gt 30 ] && echo "✅ text content OK ($CHARS chars)" || echo "⚠️ text seems short ($CHARS chars) – might be mostly graphics"
else
  echo "⚠️ pdftotext missing -> skipping text check"
fi
echo "✅ pdf checks passed"
