#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
in="כללים.md"; [ -f "$in" ] || in="RULES.md"
out="rules.html"
escape(){ sed -e "s/&/\&amp;/g" -e "s/</\&lt;/g" -e "s/>/\&gt;/g"; }
{
  echo "<!doctype html><html lang=\"he\" dir=\"rtl\"><head><meta charset=\"utf-8\"/>"
  echo "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"/>"
  echo "<link rel=\"stylesheet\" href=\"assets/style.css\"/>"
  echo "</head><body><div class=\"wrap\"><div class=\"shell\">"
  echo "<h1 class=\"title\">כללים</h1><div class=\"ruleline\"></div>"
  echo "<pre>"
  cat "$in" | escape
  echo "</pre></div></div></body></html>"
} > "$out"
