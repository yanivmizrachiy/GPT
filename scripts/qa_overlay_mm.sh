#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
cd "$HOME/GPT"

# input: latest qa preview png (or a provided path)
IN="${1:-}"
if [ -z "$IN" ]; then
  IN="$(ls -1t qa/page-1-*-1.png 2>/dev/null | head -n 1 || true)"
fi
[ -n "$IN" ] || { echo "❌ no preview png found (run qa_print first)."; exit 3; }
[ -f "$IN" ] || { echo "❌ file not found: $IN"; exit 4; }

OUT="qa/overlay-$(date +%Y%m%d-%H%M%S).png"

python - <<PY
from PIL import Image, ImageDraw, ImageFont
import os, math, sys

inp = r"""$IN"""
outp = r"""$OUT"""

img = Image.open(inp).convert("RGBA")
w,h = img.size
draw = ImageDraw.Draw(img)

# A4 reference: 210x297 mm
# Estimate pixels per mm using A4 aspect ratio; assume full page captured in PNG
# We map height to 297mm, width to 210mm, choose min to avoid overflow
px_per_mm = min(w/210.0, h/297.0)

# Grid settings
minor = 5   # mm
major = 10  # mm

def line(x1,y1,x2,y2,a):
    draw.line((x1,y1,x2,y2), fill=(0,0,0,a), width=1)

# Safe area (common print margin) 7mm
m = 7 * px_per_mm
line(m, m, w-m, m, 120)
line(w-m, m, w-m, h-m, 120)
line(w-m, h-m, m, h-m, 120)
line(m, h-m, m, m, 120)

# Grid
for mm in range(0, 211, minor):
    x = mm * px_per_mm
    if 0 <= x <= w:
        a = 40 if mm % major else 90
        line(x, 0, x, h, a)
for mm in range(0, 298, minor):
    y = mm * px_per_mm
    if 0 <= y <= h:
        a = 40 if mm % major else 90
        line(0, y, w, y, a)

# Rulers (top + left)
for mm in range(0, 211, 1):
    x = mm * px_per_mm
    if x > w: break
    tick = 18 if mm % 10 == 0 else 10 if mm % 5 == 0 else 6
    line(x, 0, x, tick, 180)
for mm in range(0, 298, 1):
    y = mm * px_per_mm
    if y > h: break
    tick = 18 if mm % 10 == 0 else 10 if mm % 5 == 0 else 6
    line(0, y, tick, y, 180)

# Label
label = f"A4 overlay grid | px/mm≈{px_per_mm:.2f} | safe=7mm | minor=5mm major=10mm"
draw.rectangle((0, h-32, w, h), fill=(255,255,255,210))
draw.text((10, h-26), label, fill=(0,0,0,255))

img.save(outp)
print("✅ overlay saved:", outp)
PY

echo "✅ overlay: $OUT"
# open image viewer if available
termux-open "$OUT" >/dev/null 2>&1 || true
