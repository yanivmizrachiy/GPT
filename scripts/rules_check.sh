#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

f="כללים.md"
[ -f "$f" ] || f="RULES.md"
[ -f "$f" ] || { echo "❌ rules_check: חסר כללים.md וגם RULES.md"; exit 2; }

fail(){ echo "❌ RULES CHECK FAILED: $1"; exit 3; }
ok(){ echo "✅ rules_check OK: $1"; }

txt="$(tr -d "\r" < "$f")"

# חובה: אין דמו + A4 + הפרדת HTML/CSS + PDF
echo "$txt" | grep -qi "אין דמו" || fail "חסר כלל: אין דמו"
echo "$txt" | grep -qi "A4" || fail "חסר כלל: A4"
echo "$txt" | grep -qi "הפרדה מוחלטת" || fail "חסר סעיף: הפרדה מוחלטת HTML / CSS"
echo "$txt" | grep -qi "html" || fail "חסר סעיף: הפרדה מוחלטת HTML / CSS"
echo "$txt" | grep -qi "css"  || fail "חסר סעיף: הפרדה מוחלטת HTML / CSS"
echo "$txt" | grep -qi "PDF"  || fail "חסר סעיף/דרישה: PDF אמיתי להורדה"

# אכיפה בפועל: אין CSS בתוך עמודים
bad_inline="$(grep -RIn --exclude-dir=.git --include="עמוד *.html" -E "<style|style=" . | head -n 1 || true)"
[ -z "$bad_inline" ] || fail "נמצא CSS בתוך HTML (אסור). דוגמה: $bad_inline"

# אין כפילויות בכותרות ## (case-insensitive)
dupe_h2="$(tr -d "\r" < "$f" | grep "^## " | tr "[:upper:]" "[:lower:]" | sort | uniq -d | head -n 1 || true)"
[ -z "$dupe_h2" ] || fail "כותרת כפולה ב-כללים: $dupe_h2"

# אין כפילויות בבולטים (- ...)
dupe_bul="$(tr -d "\r" < "$f" | sed -E "s/[[:space:]]+/ /g" | grep "^- " | sort | uniq -d | head -n 1 || true)"
[ -z "$dupe_bul" ] || fail "בולט כפול (כפילות דרישה): $dupe_bul"

ok "כללים תקינים + אין כפילויות/סתירות בסיסיות + אין CSS בתוך עמודים"
