#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
RAW="https://raw.githubusercontent.com/yanivmizrachiy/GPT/main/pdf/page-1.pdf"
OUT="$HOME/storage/shared/Download/page-1.pdf"
TS=$(date +%s)
curl -fsSL "$RAW?ts=$TS" -o "$OUT"
echo "✅ saved: $OUT"
ls -lh "$OUT" | sed "s/^/📄 /"
