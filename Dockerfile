FROM ruby:3.4.2-slim

ENV DEBIAN_FRONTEND noninteractive

LABEL authors="aaronplayz-sys" \
      description="Docker image for Frontier Biz guides" \
      version="1.0.0"

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
    zlib1g-dev

RUN apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

ENV EXECJS_RUNTIME=Node \
    JEKYLL_ENV=production \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Set working directory
WORKDIR /usr/src/app

ADD Gemfile.lock /usr/src/app/
ADD Gemfile /usr/src/app/

RUN gem install --no-document jekyll
RUN gem install --no-document bundler
RUN bundle install --no-cache

EXPOSE 4000

COPY bin/entrypoint.sh /tmp/entrypoint.sh

CMD ["/tmp/entrypoint.sh"]
