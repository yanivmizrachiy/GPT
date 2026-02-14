#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
cd "$HOME/GPT"

OUT="$HOME/storage/shared/Download/QA_pack_$(date +%Y%m%d-%H%M%S).zip"

# Collect latest artifacts if exist
PDF="$HOME/storage/shared/Download/page-1.pdf"
PNG="$(ls -1t qa/page-1-*-1.png 2>/dev/null | head -n 1 || true)"
OVR="$(ls -1t qa/overlay-*.png 2>/dev/null | head -n 1 || true)"
STATE="$(ls -1t qa/state-*.json 2>/dev/null | head -n 1 || true)"

tmpdir="$(mktemp -d)"
[ -f "$PDF" ] && cp -f "$PDF" "$tmpdir/" || true
[ -n "$PNG" ] && [ -f "$PNG" ] && cp -f "$PNG" "$tmpdir/" || true
[ -n "$OVR" ] && [ -f "$OVR" ] && cp -f "$OVR" "$tmpdir/" || true
[ -n "$STATE" ] && [ -f "$STATE" ] && cp -f "$STATE" "$tmpdir/" || true

# Add rules snapshot too
[ -f "כללים.md" ] && cp -f "כללים.md" "$tmpdir/" || true
[ -f "rules.html" ] && cp -f "rules.html" "$tmpdir/" || true

cd "$tmpdir"
zip -qr "$OUT" . || { echo "❌ zip failed"; exit 4; }
cd - >/dev/null
rm -rf "$tmpdir"

echo "✅ packed: $OUT"
ls -lh "$OUT" | sed "s/^/📦 /"
termux-open "$OUT" >/dev/null 2>&1 || true
