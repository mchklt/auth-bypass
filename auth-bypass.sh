#!/bin/bash

if [ $# -ne 1 ]; then
    echo "❌ Error: URL is required"
    echo "Usage: $0 <URL>"
    echo "Example: $0 https://example.com"
    exit 1
fi

URL=$1
echo "🔍 Testing headers on: $URL"

HEADERS=(
    "X-Forwarded-For: 127.0.0.1"
    "X-Forwarded-Host: 127.0.0.1"
    "X-Forwarded-Proto: https"
    "X-Real-IP: 192.168.1.1"
    "X-Role: admin"
    "X-Admin: true"
    "Authorization: Basic YWRtaW46cGFzcw=="
    "X-Internal: true"
    "Internal: true"
    "username: admin"
    "user: admin"
    "X-Client-IP: 10.0.0.1"
    "X-Remote-IP: 172.16.0.1"
    "X-Remote-Addr: 192.168.1.1"
    "Forwarded: for=192.0.2.60;proto=http;by=203.0.113.43"
    "Via: 1.1 varnish"
    "X-Originating-IP: [192.168.1.100, 192.168.1.1"
    "Referer: https://localhost"
    "Authorization: Bearer YWRtaW46YWRtaW4="
    "X-HTTP-Method-Override: POST"
    "X-Original-Method: PUT"
    "X-Method-Override: DELETE"
)

echo "📡 Getting baseline response..."
BASELINE_RESPONSE=$(curl -s "$URL")
BASELINE_SIZE=${#BASELINE_RESPONSE}
if [ $? -ne 0 ]; then
    echo "❌ Error: Could not connect to $URL"
    exit 1
fi

echo "🔄 Testing headers..."

for header in "${HEADERS[@]}"; do
    response=$(curl -s -H "$header" "$URL")
    if [ $? -eq 0 ]; then
        size=${#response}
        diff=$((size - BASELINE_SIZE))
        abs_diff=${diff#-}

        if [ "$response" != "$BASELINE_RESPONSE" ]; then
            if [ $abs_diff -gt 20 ]; then
                printf "🔴 %-40s %+5db [content changed]\n" "${header%%:*}" "$diff"
            else
                printf "🟡 %-40s %+5db [content changed]\n" "${header%%:*}" "$diff"
            fi
        fi
    fi
done

echo "\n💫 Analysis complete!"
