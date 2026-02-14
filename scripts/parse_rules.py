#!/usr/bin/env python3
from __future__ import annotations
from pathlib import Path
import json, re, sys

CANON = "כללים.md"

SECTION_HEADERS = [
  "REQUIRED FILES",
  "REQUIRED SCRIPTS",
  "PRINT RULES",
  "GOVERNANCE",
]

def norm(s: str) -> str:
  return re.sub(r"\s+", " ", s.strip())

def extract_sections(md: str) -> dict:
  out = {h: [] for h in SECTION_HEADERS}
  lines = md.splitlines()
  cur = None
  for raw in lines:
    line = raw.rstrip("\r\n")
    m = re.match(r"^##\s+(.*)$", line)
    if m:
      title = norm(m.group(1))
      cur = title if title in out else None
      continue
    if cur is None:
      continue
    b = re.match(r"^\s*[-*]\s+(.*)$", line)
    if b:
      item = norm(b.group(1))
      if item:
        out[cur].append(item)
  return out

def main() -> int:
  md_path = Path(CANON)
  if not md_path.exists():
    print(f"❌ missing {CANON}")
    return 3
  md = md_path.read_text(encoding="utf-8")
  sec = extract_sections(md)
  missing = [h for h in SECTION_HEADERS if not sec.get(h)]
  if missing:
    print("❌ rules sections missing/empty:", ", ".join(missing))
    return 4
  print(json.dumps(sec, ensure_ascii=False, indent=2))
  return 0

if __name__ == "__main__":
  raise SystemExit(main())
