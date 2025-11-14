FROM python:3.11-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl xz-utils ca-certificates build-essential git \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN python3 -m pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt
COPY . .
RUN chmod +x ./setup_ffmpeg.sh || true
RUN mkdir -p /app/bin && \
    FF_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz" && \
    curl -L --retry 3 --retry-delay 2 -o /tmp/ffmpeg.tar.xz "$FF_URL" && \
    tar -xJf /tmp/ffmpeg.tar.xz -C /tmp && \
    EXDIR=$(tar -tf /tmp/ffmpeg.tar.xz | head -n1 | cut -f1 -d"/") && \
    mv /tmp/$EXDIR/ffmpeg /app/bin/ffmpeg && \
    mv /tmp/$EXDIR/ffprobe /app/bin/ffprobe && \
    chmod +x /app/bin/ffmpeg /app/bin/ffprobe && \
    rm -rf /tmp/ffmpeg.tar.xz /tmp/$EXDIR
ENV PATH="/app/bin:${PATH}"
ENV PORT=8080
EXPOSE 8080
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app", "--workers", "2", "--timeout", "120"]
