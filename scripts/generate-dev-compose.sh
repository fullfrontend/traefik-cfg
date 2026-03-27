#!/bin/sh
set -eu

BASE_DOMAINS_FILE="${1:-./config_dev/mkcert-domains.txt}"
LOCAL_DOMAINS_FILE="${2:-./config_dev/mkcert-domains.local.txt}"
OUTPUT_FILE="${3:-./docker-compose.dev.generated.yml}"

tmp_file="$(mktemp)"
domains_tmp="$(mktemp)"
domains_clean="$(mktemp)"

cleanup() {
  rm -f "$tmp_file" "$domains_tmp" "$domains_clean"
}
trap cleanup EXIT

touch "$domains_tmp"

if [ -f "$BASE_DOMAINS_FILE" ]; then
  cat "$BASE_DOMAINS_FILE" >> "$domains_tmp"
fi

if [ -f "$LOCAL_DOMAINS_FILE" ]; then
  cat "$LOCAL_DOMAINS_FILE" >> "$domains_tmp"
fi

awk '
  {
    sub(/\r$/, "", $0)
  }
  /^[[:space:]]*$/ { next }
  /^[[:space:]]*#/ { next }
  { print }
' "$domains_tmp" | sort -u > "$domains_clean"

printf "services:\n" > "$tmp_file"
printf "    mkcert:\n" >> "$tmp_file"
printf "        environment:\n" >> "$tmp_file"
printf "            domains: |\n" >> "$tmp_file"

if [ -s "$domains_clean" ]; then
  while IFS= read -r line; do
    printf "                %s\n" "$line" >> "$tmp_file"
  done < "$domains_clean"
else
  printf "                fullfrontend.test\n" >> "$tmp_file"
fi

mv "$tmp_file" "$OUTPUT_FILE"
