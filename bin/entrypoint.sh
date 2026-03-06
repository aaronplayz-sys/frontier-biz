#!/bin/bash
set -euo pipefail

CONFIG_FILE=_config.yml
JEKYLL_PID=0

# Clean shutdown function (Only used in Development)
cleanup() {
    echo "Caught signal, shutting down Jekyll..."
    if [ "$JEKYLL_PID" -ne 0 ]; then
        kill -TERM "$JEKYLL_PID" 2>/dev/null || true
        wait "$JEKYLL_PID" 2>/dev/null || true
    fi
    exit 0
}

trap cleanup SIGINT SIGTERM

# --- 1. INITIALIZATION (Runs exactly once) ---
echo "Verifying Ruby gems..."
git config --global --add safe.directory '*'
if command -v git &> /dev/null && [ -f Gemfile.lock ]; then
    if git ls-files --error-unmatch Gemfile.lock &> /dev/null; then
        echo "Gemfile.lock is tracked by git, keeping it intact"
        git restore Gemfile.lock 2>/dev/null || true
    else
        echo "Gemfile.lock is not tracked, cleaning up for fresh install"
        rm -f Gemfile.lock
    fi
fi

# If gems are missing or the lockfile was deleted, install them before continuing
bundle check || bundle install

# --- 2. PRODUCTION MODE ---
if [ "${JEKYLL_ENV:-development}" = "production" ]; then
    echo "Starting Jekyll in PRODUCTION mode..."
    # 'exec' replaces the bash process with Jekyll. No background loops needed.
    exec bundle exec jekyll serve --port=4000 --host=0.0.0.0 --no-watch
fi

# --- 3. DEVELOPMENT MODE ---
start_jekyll() {
    echo "Starting Jekyll in DEVELOPMENT mode..."
    bundle exec jekyll serve --watch --port=4000 --host=0.0.0.0 --livereload --force_polling &
    JEKYLL_PID=$!
}

start_jekyll

# The watch loop blocks until the config file is touched
while true; do
    if inotifywait -q -e modify,move,create,delete "$CONFIG_FILE"; then
        echo "Change detected to $CONFIG_FILE, restarting Jekyll..."
        kill -TERM "$JEKYLL_PID" 2>/dev/null || true
        wait "$JEKYLL_PID" 2>/dev/null || true
        start_jekyll
    fi
done