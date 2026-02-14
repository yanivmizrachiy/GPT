#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
cd "$HOME/GPT"

echo "== QA: DEV MODE =="
./scripts/dev_mode.sh

echo
echo "== QA: DOWNLOAD RAW PDF =="
./scripts/get_pdf.sh

echo
echo "== QA: OPEN PDF (viewer) =="
OUT="$HOME/storage/shared/Download/page-1.pdf"
if command -v termux-open >/dev/null 2>&1; then
  termux-open "$OUT" >/dev/null 2>&1 || true
  echo "✅ opened: $OUT"
else
  echo "ℹ️ termux-open not found; file saved: $OUT"
fi

echo
echo "✅ QA PRINT DONE"

echo
echo "== QA: SNAPSHOT (state.json) =="
./scripts/qa_snapshot.sh || true
echo
echo "== QA: PDF CHECKS =="
./scripts/qa_pdf_check.sh "$HOME/storage/shared/Download/page-1.pdf" || exit 9
echo
echo "== QA: PREVIEW PNG (optional) =="
./scripts/qa_preview.sh "$HOME/storage/shared/Download/page-1.pdf" || true

