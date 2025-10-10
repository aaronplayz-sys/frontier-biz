FROM ruby:3.4.2-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
  build-essential \
  libffi-dev \
  protobuf-compiler \
  nodejs \
  python3 \
  git \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /usr/src/app

# Bundler config for persistent gem path
RUN mkdir -p .bundle \
 && echo 'BUNDLE_PATH: "/usr/local/bundle"' > .bundle/config

ENV BUNDLE_PATH=/usr/local/bundle

# Copy Gemfile and lock file first for caching
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.5.9 && bundle install

# Copy the rest of the project
COPY . .

EXPOSE 4000
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
