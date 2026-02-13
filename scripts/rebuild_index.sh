#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

cat > index.html <<'HTML'
<!doctype html>
<html lang="he" dir="rtl">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>GPT — דף כניסה</title>
  <link rel="stylesheet" href="assets/style.css" />
  <style>
    .menu{max-width:900px;margin:18px auto;padding:0 12px}
    .card{background:#fff;border-radius:18px;box-shadow:0 18px 40px rgba(0,0,0,.08);padding:16px}
    a{color:var(--blue);text-decoration:none;font-weight:800}
    .row{display:flex;gap:12px;flex-wrap:wrap}
    .pill{border:1px solid rgba(0,0,0,.08);border-radius:999px;padding:10px 14px;background:#fff}
  </style>
</head>
<body>
  <div class="menu">
    <div class="card">
      <h1 class="title" style="margin:0 0 8px">GPT</h1>
      <div class="ruleline"></div>
      <p style="color:var(--muted);margin:10px 0 14px">כרגע פעיל: עמוד 1 בלבד (נעול).</p>
      <div class="row">
        <div class="pill"><a href="עמוד%201.html">עמוד 1</a></div>
        <div class="pill"><a href="rules.html">כללים (מתעדכן)</a></div>
      </div>
    </div>
  </div>
</body>
</html>
HTML
echo "✅ index.html (page1-only) updated"
