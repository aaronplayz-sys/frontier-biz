FROM ruby:3.4.2-slim

ENV DEBIAN_FRONTEND noninteractive

LABEL authors="aaronplayz-sys" \
      description="Docker image for Frontier Biz guides (Dev & Prod)" \
      version="1.0.2"

# Install system dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    imagemagick \
    locales \
    inotify-tools \
    nodejs \
    procps \
    python3-pip \
    zlib1g-dev && \
    # Set up locales
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    # Clean up cache
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /var/tmp/*

ENV EXECJS_RUNTIME=Node \
    JEKYLL_ENV=production \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Set working directory
WORKDIR /usr/src/app

# Install Bundler and handle Gemfiles
COPY Gemfile Gemfile.lock ./
RUN gem install --no-document bundler && \
    bundle install --jobs=4

# Copy the rest of the application code
COPY . .

# Move entrypoint script and make it executable
COPY bin/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 4000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
