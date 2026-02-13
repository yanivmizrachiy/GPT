#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

f="RULES.md"
[ -f "$f" ] || { echo "❌ RULES.md לא קיים"; exit 2; }

fail(){ echo "❌ RULES CHECK FAILED: $1"; exit 3; }
ok(){ echo "✅ rules_check: $1"; }

txt="$(cat "$f")"

# 1) בדיקות חובה: העקרונות שהמשתמש קבע
echo "$txt" | grep -q "הפרדה מוחלטת בין HTML ל-CSS" || fail "חסר כלל: הפרדה מוחלטת בין HTML ל-CSS"
echo "$txt" | grep -q "כל עמוד הוא קובץ נפרד" || fail "חסר כלל: כל עמוד הוא קובץ נפרד"
echo "$txt" | grep -q "פרופורציה" || fail "חסר כלל: כותרת פרופורציה"
echo "$txt" | grep -q "עיגול אדום" || fail "חסר כלל: מספר עמוד בעיגול אדום"
echo "$txt" | grep -q "נקודה שחורה" || fail "חסר כלל: נקודה שחורה בתחילת כל שאלה"

# 2) איתור סתירות בסיסי (מוגבל אבל פרקטי):
#    אם מופיע גם "מותר CSS בתוך HTML" וגם "הפרדה מוחלטת" -> סתירה
if echo "$txt" | grep -qi "מותר .*css .*בתוך .*html"; then
  fail "נמצאה סתירה: כתוב שמותר CSS בתוך HTML למרות שהכלל הוא הפרדה מוחלטת"
fi

# 3) בדיקת קבצים בפועל: אין <style> / style= בתוך עמודים (כדי לאכוף הפרדה)
bad_inline="$(grep -RIn --exclude-dir=.git --include="עמוד *.html" -E "<style|style=" . | head -n 1 || true)"
[ -z "$bad_inline" ] || fail "נמצא CSS בתוך HTML (אסור). דוגמה: $bad_inline"

ok "כללים קיימים + אין CSS בתוך עמודים"
