#!/usr/bin/env bash
set -euo pipefail
echo "==> setup_ffmpeg.sh started"
mkdir -p bin
FF_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz"
TMP="/tmp/ffmpeg_download_$$"
mkdir -p "$TMP"
echo "Downloading ffmpeg..."
curl -L --retry 3 --retry-delay 2 -o "$TMP/ffmpeg.tar.xz" "$FF_URL"
echo "Extracting..."
tar -xJf "$TMP/ffmpeg.tar.xz" -C "$TMP"
EXDIR=$(tar -tf "$TMP/ffmpeg.tar.xz" | head -n1 | cut -f1 -d"/")
mv "$TMP/$EXDIR/ffmpeg" ./bin/ffmpeg
mv "$TMP/$EXDIR/ffprobe" ./bin/ffprobe
chmod +x ./bin/ffmpeg ./bin/ffprobe
rm -rf "$TMP"
echo "==> setup_ffmpeg.sh finished"
