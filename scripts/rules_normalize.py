from __future__ import annotations
from pathlib import Path
import re

p = Path("RULES.md")
t = p.read_text(encoding="utf-8") if p.exists() else ""

lines = t.replace("\r\n", "\n").replace("\r", "\n").split("\n")

seen_h2 = set()
seen_bul = set()

out = []
for ln in lines:
    # dedupe identical H2 headings (case-insensitive)
    if ln.startswith("## "):
        key = ln.strip().lower()
        if key in seen_h2:
            continue
        seen_h2.add(key)
        out.append(ln)
        continue

    # dedupe identical bullet lines (normalize spaces)
    if ln.startswith("- "):
        key = re.sub(r"\s+", " ", ln.strip())
        if key in seen_bul:
            continue
        seen_bul.add(key)
        out.append(ln)
        continue

    out.append(ln)

# trim trailing blank lines to max 1
while len(out) > 1 and out[-1] == "" and out[-2] == "":
    out.pop()

p.write_text("\n".join(out).rstrip() + "\n", encoding="utf-8")
