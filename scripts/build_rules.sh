#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

in="RULES.md"
out="rules.html"

escape(){ sed -e "s/&/\\&amp;/g" -e "s/</\\&lt;/g" -e "s/>/\\&gt;/g"; }

{
  echo "<!doctype html><html lang=\"he\" dir=\"rtl\"><head><meta charset=\"utf-8\"/>"
  echo "<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"/>"
  echo "<title>GPT — כללים</title>"
  echo "<link rel=\"stylesheet\" href=\"assets/style.css\"/>"
  echo "<style>.wrap{max-width:1000px;margin:18px auto;padding:0 12px}.box{background:#fff;border-radius:18px;box-shadow:0 18px 40px rgba(0,0,0,.08);padding:16px}pre{white-space:pre-wrap;line-height:1.7}</style>"
  echo "</head><body><div class=\"wrap\"><div class=\"box\">"
  echo "<h1 class=\"title\" style=\"margin:0 0 8px\">כללים — GPT</h1><div class=\"ruleline\"></div>"
  echo "<pre>"
  cat "$in" | escape
  echo "</pre></div></div></body></html>"
} > "$out"
