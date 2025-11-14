# Hyper Downloader (Railway-ready)

This repository is prepared to deploy on Railway (free plan) with a build-time FFmpeg installer.

## Contents
- `app.py` - Main Flask + yt-dlp app (uploaded by user).
- `setup_ffmpeg.sh` - Downloads a static ffmpeg build at deploy time into `./bin`.
- `Procfile` - Railway start command.
- `requirements.txt` - Python dependencies.
- `.gitignore` - Ignore runtime artifacts.

## Deploy steps (summary)
1. Push this repo to GitHub.
2. Connect the repo to Railway and deploy.
3. Railway will run the Procfile which executes `setup_ffmpeg.sh` then starts the app.
4. Verify `/ffmpeg-version` or `/env` endpoints.

## Notes & tips
- Keep downloads cleaned up in `app.py` to save disk.
- Free plan has limited storage/credits; avoid heavy continuous transcoding.
- If johnvansickle link doesn't work for you, replace `FF_URL` in `setup_ffmpeg.sh` with a mirror (GitHub Release, S3, etc).
