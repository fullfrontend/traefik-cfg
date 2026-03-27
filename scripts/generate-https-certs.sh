#!/bin/sh
set -eu

CERTS_DIR="${1:-./certs}"
OUTPUT_FILE="${2:-./config_dev/dynamic/https-certs.local.yml}"
MOUNT_PATH="${3:-/etc/certs}"

tmp_file="$(mktemp)"
count=0

certs="$(find "$CERTS_DIR" -maxdepth 1 -type f -name "*.pem" -print | sort || true)"

if [ -z "$certs" ]; then
  printf "tls:\n  certificates: []\n" > "$tmp_file"
else
  printf "tls:\n  certificates:\n" > "$tmp_file"
  for cert in $certs; do
    case "$cert" in
      *-key.pem) continue ;;
      */rootCA.pem) continue ;;
    esac

    key="${cert%.pem}-key.pem"
    if [ -f "$key" ]; then
      cert_base="$(basename "$cert")"
      key_base="$(basename "$key")"
      printf "    - certFile: \"%s/%s\"\n" "$MOUNT_PATH" "$cert_base" >> "$tmp_file"
      printf "      keyFile: \"%s/%s\"\n" "$MOUNT_PATH" "$key_base" >> "$tmp_file"
      count=$((count + 1))
    fi
  done

  if [ "$count" -eq 0 ]; then
    printf "tls:\n  certificates: []\n" > "$tmp_file"
  fi
fi

mkdir -p "$(dirname "$OUTPUT_FILE")"
mv "$tmp_file" "$OUTPUT_FILE"
