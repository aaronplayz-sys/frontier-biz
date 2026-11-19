FROM ruby:3.4.10-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG APP_UID=1000
ARG APP_GID=1000

LABEL org.opencontainers.image.authors="aaronplayz-sys" \
      org.opencontainers.image.descripption="Docker image for Frontier Biz guides" \
      org.opencontainers.image.version="2.0.0"

# Dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    curl \
    git \
    imagemagick \
    inotify-tools \
    libmagickwand-dev \
    locales \
    nodejs \
    npm \
    pkg-config \
    zlib1g-dev && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    rm -rf /var/lib/apt/lists/* var/cache/apt/archives/*

# Environment
ENV EXECJS_RUNTIME=Node \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    BUNDLE_FROZEN=TRUE

# Create a non-root user
RUN groupadd --gid "${APP_GID}" jekyll && \
    useradd --uid "${APP_UID}" \
        --gid jekyll \
        --home-dir /usr/src/app \
        --no-create-home \
        --shell /usr/sbin/nologin \
        jekyll && \
    mkdir -p /usr/src/app && \
    chown jekyll:jekyll /usr/src/app

WORKDIR /usr/src/app

# Install Bundler
RUN gem install bundler -v 4.0.3 --no-document

# Install Ruby dependencies
COPY Gemfile Gemfile.lock ./

RUN --mount=type=cache,target=/usr/local/bundle/cache \
    bundle install --jobs 4 --retry 3

# Install Node.js dependencies
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci --include=dev

# Copy the application code
COPY --chown=jekyll:jekyll . .

# Setup Entrypoint
RUN sed -i 's/\r$//' bin/entrypoint.sh && \
    install -m 0755 bin/entrypoint.sh /usr/local/bin/entrypoint.sh

# Ensure application files are owned by the non-root user
RUN mkdir -p \
        /usr/src/app/.jekyll-cache \
        /usr/src/app/_site \
    && chown -R jekyll:jekyll /usr/src/app

# Drop to non-root user
USER jekyll

# Expose Jekyll and LiveReload ports
EXPOSE 4000 35729

# Healthcheck
HEALTHCHECK --interval=30s \
    --timeout=10s \
    --start-period=60s \
    --retries=3 \
    CMD curl -fsS http://127.0.0.1:4000/ >/dev/null || exit 1

ENTRYPOINT ["/usr/bin/bash", "/usr/local/bin/entrypoint.sh"]