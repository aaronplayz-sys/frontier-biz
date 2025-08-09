FROM ruby:3.3-alpine

# Install build tools and dependencies
RUN apk add --no-cache \
  build-base \
  libffi-dev \
  protobuf-dev \
  nodejs \
  python3 \
  git

WORKDIR /usr/src/app

# Create Bundler config for persistent gem path
RUN mkdir -p .bundle \
 && echo 'BUNDLE_PATH: "/usr/local/bundle"' > .bundle/config

 # gem cache
ENV BUNDLE_PATH=/usr/local/bundle

# copy gemfile & gemfile.lock first
COPY Gemfile Gemfile.lock ./

# install gems (cached unless Gemfile changes)
RUN gem install bundler && bundle install

# copy remaining files in folder (files or directories in .dockerignore wont be copied)
COPY . .

EXPOSE 4000
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
