#!/usr/bin/env bash
set -euo pipefail
echo "==> setup_ffmpeg.sh started"

mkdir -p bin

# Reliable static ffmpeg build URL (linux amd64)
FF_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz"

TMP="/tmp/ffmpeg_download_$$"
mkdir -p "$TMP"

echo "Downloading ffmpeg..."
curl -L --retry 3 --retry-delay 2 -o "$TMP/ffmpeg.tar.xz" "$FF_URL"

echo "Extracting..."
tar -xJf "$TMP/ffmpeg.tar.xz" -C "$TMP"

EXDIR=$(tar -tf "$TMP/ffmpeg.tar.xz" | head -n1 | cut -f1 -d"/")
if [ -z "$EXDIR" ]; then
  echo "Extraction failed or unexpected archive layout" >&2
  exit 1
fi

if [ -f "$TMP/$EXDIR/ffmpeg" ] && [ -f "$TMP/$EXDIR/ffprobe" ]; then
  mv "$TMP/$EXDIR/ffmpeg" ./bin/ffmpeg
  mv "$TMP/$EXDIR/ffprobe" ./bin/ffprobe
  chmod +x ./bin/ffmpeg ./bin/ffprobe
  echo "ffmpeg & ffprobe moved to ./bin"
else
  echo "ffmpeg or ffprobe not found in extracted archive" >&2
  ls -la "$TMP/$EXDIR"
  exit 1
fi

rm -rf "$TMP"
echo "==> setup_ffmpeg.sh finished"
