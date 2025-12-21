#!/bin/bash
set -euo pipefail

CONFIG_FILE=_config.yml
JEKYLL_PID=0

# Clean shutdown function
cleanup() {
    echo "Caught signal, shutting down Jekyll..."
    if [ "$JEKYLL_PID" -ne 0 ]; then
        kill -TERM "$JEKYLL_PID" 2>/dev/null || true
        wait "$JEKYLL_PID" 2>/dev/null || true
    fi
    exit 0
}

# Trap termination signals (Docker stop)
trap cleanup SIGINT SIGTERM

manage_gemfile_lock() {
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
}

start_jekyll() {
    manage_gemfile_lock
    
    if [ "$JEKYLL_ENV" = "production" ]; then
        echo "Starting Jekyll in PRODUCTION mode..."
        # No livereload or force_polling in prod to save resources
        bundle exec jekyll serve --port=4000 --host=0.0.0.0 --no-watch &
    else
        echo "Starting Jekyll in DEVELOPMENT mode..."
        bundle exec jekyll serve --watch --port=4000 --host=0.0.0.0 --livereload --force_polling &
    fi
    JEKYLL_PID=$!
}

# Initial Start
start_jekyll

# The watch loop (only useful in dev, but safe to keep)
while true; do
    # This blocks until the config file is touched
    if inotifywait -q -e modify,move,create,delete "$CONFIG_FILE"; then
        echo "Change detected to $CONFIG_FILE, restarting Jekyll..."
        kill -TERM "$JEKYLL_PID" 2>/dev/null || true
        wait "$JEKYLL_PID" 2>/dev/null || true
        start_jekyll
    fi
done