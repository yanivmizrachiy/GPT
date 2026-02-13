#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

n="${1:-}"
[ -n "$n" ] || { echo "Usage: ./scripts/new_page.sh 4"; exit 2; }

f="עמוד ${n}.html"
[ -f "$f" ] && { echo "❌ כבר קיים: $f"; exit 3; }

cat > "$f" <<EOF
<!doctype html>
<html lang="he" dir="rtl">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>GPT — עמוד ${n} — פרופורציה</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=David+Libre:wght@400;700&family=Heebo:wght@400;700&family=Assistant:wght@400;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="assets/style.css" />
  <script>window.MathJax={tex:{inlineMath:[["\\\\(","\\\\)"],["$","$"]]},svg:{fontCache:"global"}};</script>
  <script defer src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js"></script>
</head>
<body>
  <div class="top">GPT • דף מתמטיקה חי (מסונכרן ל-GitHub Pages)</div>
  <div class="shell">
    <section class="page">
      <div class="page-no">${n}</div>
      <div class="page-inner">
        <h1 class="title">פרופורציה</h1>
        <div class="ruleline"></div>

        <div class="questions">
          <div class="q">
            <p class="head dot">שאלה 1</p>
            <p class="text">כתוב/י כאן שאלה חדשה לעמוד ${n}.</p>
            <div class="lines"><div class="line"></div><div class="line"></div><div class="line"></div></div>
          </div>

          <div class="q">
            <p class="head dot">שאלה 2</p>
            <p class="text">כתוב/י כאן שאלה נוספת לעמוד ${n}.</p>
            <div class="lines"><div class="line"></div><div class="line"></div><div class="line"></div></div>
          </div>
        </div>

      </div>
    </section>
  </div>
</body>
</html>
EOF

echo "✅ נוצר: $f"
