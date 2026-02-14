#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

STAMP="$HOME/.cache/gpt-weekly-update.stamp"
mkdir -p "$(dirname "$STAMP")"

# אם כבר עודכן ב-7 ימים האחרונים — לא עושים כלום
if [ -f "$STAMP" ]; then
  last=$(date -r "$STAMP" +%s 2>/dev/null || echo 0)
  now=$(date +%s)
  age=$((now-last))
  if [ "$age" -lt 604800 ]; then
    echo "ℹ️ weekly_update: כבר עודכן השבוע (לא מבזבז זמן)."
    exit 0
  fi
fi

echo "🚀 weekly_update: updating packages..."
pkg update -y >/dev/null 2>&1 || true
pkg upgrade -y >/dev/null 2>&1 || true
pkg install -y git curl jq ripgrep >/dev/null 2>&1 || true
apt clean >/dev/null 2>&1 || true
date > "$STAMP"
echo "✅ weekly_update: done"
