#!/usr/bin/env bash

set -Eeuo pipefail

CONFIG_FILE="${JEKYLL_CONFIG_FILE:-_config.yml}"
JEKYLL_PID=""
JEKYLL_ENV="${JEKYLL_ENV:-development}"

# Verify that dependencies were installed during image construction.
echo "Verifying Ruby gems..."

if ! bundle check; then
    echo "ERROR: Ruby dependencies are missing."
    echo "Rebuild the Docker image to install the required gems."
    exit 1
fi

# Clean shutdown for development mode.
cleanup() {
    echo "Caught shutdown signal, stopping Jekyll..."

    trap - SIGINT SIGTERM

    if [[ -n "$JEKYLL_PID" ]] && kill -0 "$JEKYLL_PID" 2>/dev/null; then
        kill -TERM "$JEKYLL_PID" 2>/dev/null || true
        wait "$JEKYLL_PID" 2>/dev/null || true
    fi

    exit 0
}

# Production mode
if [[ "$JEKYLL_ENV" == "production" ]]; then
    echo "Starting Jekyll in PRODUCTION mode..."

    exec bundle exec jekyll serve \
        --port=4000 \
        --host=0.0.0.0 \
        --no-watch \
        "$@"
fi

# Development mode
trap cleanup SIGINT SIGTERM

start_jekyll() {
    echo "Starting Jekyll in DEVELOPMENT mode..."

    bundle exec jekyll serve \
        --watch \
        --port=4000 \
        --host=0.0.0.0 \
        --livereload \
        --force_polling \
        "$@" &

    JEKYLL_PID=$!
}

# Start Jekyll
start_jekyll

# Watch the configuration directory instead of the file itself.
echo "Watching ${CONFIG_FILE} for changes..."

CONFIG_DIR="$(dirname "$CONFIG_FILE")"
CONFIG_NAME="$(basename "$CONFIG_FILE")"

while inotifywait -q \
    -e close_write,moved_to,create,delete \
    --include "^${CONFIG_NAME}$" \
    "$CONFIG_DIR"; do

    echo "Configuration change detected. Restarting Jekyll..."

    if [[ -n "$JEKYLL_PID" ]]; then
        kill -TERM "$JEKYLL_PID" 2>/dev/null || true
        wait "$JEKYLL_PID" 2>/dev/null || true
    fi

    start_jekyll
done

echo "Configuration watcher stopped unexpectedly."
exit 1
