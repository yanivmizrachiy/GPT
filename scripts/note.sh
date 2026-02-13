#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
msg="${1:-עדכון אוטומטי}"
what="${2:-}"
next="${3:-}"

ts="$(date +"%Y-%m-%d %H:%M")"
f="RULES.md"
[ -f "$f" ] || { echo "❌ RULES.md לא קיים"; exit 2; }

# אם אין יומן – מוסיפים
grep -q "^## יומן עבודה" "$f" || printf "\n## יומן עבודה (חובה להתעדכן אחרי כל פעולה)\n" >> "$f"

{
  echo ""
  echo "### $ts"
  echo "- דרישה/שינוי: $msg"
  [ -n "$what" ] && echo "- בוצע בפועל: $what"
  [ -n "$next" ] && echo "- המשך מתוכנן: $next"
} >> "$f"

python scripts/rules_normalize.py
echo "✅ note saved into RULES.md ($ts)"
