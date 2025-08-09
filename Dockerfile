FROM ruby:3.3

RUN apt-get update && apt-get install -y \
  build-essential \
  libffi-dev \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Create Bundler config for persistent gem path
RUN mkdir -p .bundle \
 && echo 'BUNDLE_PATH: "/usr/local/bundle"' > .bundle/config

ENV BUNDLE_PATH=/usr/local/bundle

COPY . .

RUN gem install bundler && bundle install

EXPOSE 4000
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
