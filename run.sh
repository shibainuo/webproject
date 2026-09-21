#!/bin/sh

clear 2>/dev/null

cat << 'BANNER'
╔══════════════════════════════════════╗
║            shibainuo.                ║
║   Custom Build by shibainuo          ║
║     + nodejs community level         ║
╚══════════════════════════════════════╝
BANNER

VERSION=$(cat /etc/earnapp/ver 2>/dev/null || echo "unknown")
printf "Version : %s\n" "$VERSION"
printf "Builder : alfime\n\n"

# تأخیر رندوم ۶۰ تا ۳۰۰ ثانیه
DELAY=$(( $(date +%s) % 241 + 60 ))
echo "» تأخیر تصادفی قبل از شروع: $DELAY ثانیه..."
sleep $DELAY
echo "» تأخیر تموم شد. در حال استارت Social..."
echo ""

if [ -n "$EARNAPP_UUID" ]; then
    echo "$EARNAPP_UUID" > /etc/earnapp/uuid
fi

earnapp start >/dev/null 2>&1 &

echo -n "Starting Social"
for i in 1 2 3 4 5 6 7 8 9 10 11 12; do
    if [ -f /etc/earnapp/status ] && [ "$(cat /etc/earnapp/status)" = "enabled" ]; then
        echo " → Ready"
        break
    fi
    echo -n "."
    sleep 1.5
done

UUID=$(cat /etc/earnapp/uuid 2>/dev/null || echo "N/A")
echo ""
echo "✔ UUID    : $UUID"
echo "✔ Status  : enabled"
echo "برای ثبت نود: https://earnapp.com/r/$UUID"
echo ""

# Web Pinger در پس‌زمینه
(
    SITES="https://www.google.com https://www.youtube.com https://www.wikipedia.org https://www.github.com https://www.cloudflare.com https://www.microsoft.com https://www.apple.com https://www.amazon.com https://www.reddit.com https://www.bbc.com"

    while true; do
        SITE=$(echo $SITES | tr ' ' '\n' | shuf -n 1)
        curl -s -o /dev/null --connect-timeout 8 --max-time 12 -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" "$SITE" >/dev/null 2>&1
        SLEEP_TIME=$(( $(date +%s) % 76 + 45 ))
        sleep $SLEEP_TIME
    done
) &

earnapp register >/dev/null 2>&1
earnapp autoupgrade >/dev/null 2>&1 &
exec earnapp run
