# Frontier Biz

Titanfall 2 — Frontier Defense guides and reference content.

## Quick overview
A collection of guides for Frontier Defense on Titanfall 2: pilots, titans, kits, aegis progression, economy, and more.

## Quick start (development & production)
Requirements: Docker / Docker Compose.

The provided Docker configuration works for both development and production environments.

### Production
Edit the docker-compose.yml file and set JEKYLL_ENV to production.

```YAML
environment:
  - JEKYLL_ENV=production
```

### Development
When doing a git clone or fork of this repository, the docker-compose.yml file is already set to develpment.

```YAML
environment:
  - JEKYLL_ENV=development
```

Start the server (builds and serves the site with Jekyll):

```sh
docker compose up -d
```
It may take a few minutes on the first time since the image is being built locally as there is no published image on docker hub at this time in the future there may be one.

Access the site at http://localhost:4000.

### Development Features

- **LiveReload**: The site will automatically refresh in your browser when you save changes to your Markdown files or stylesheets.
- **Config Auto-Restart**: Unlike standard Jekyll, this container monitors `_config.yml`. If you modify your site configuration, the Jekyll process will automatically restart inside the container—no manual `docker restart` required.
- **Force Polling**: Configured to work reliably even across different Operating Systems (Windows/macOS/Linux) via Docker volumes.

## Local Development (Native Ruby)

If you modify Ruby gems or want to run locally without Docker, make sure you are using **Ruby** version **3.4+**

```sh
gem install bundler
bundle install --gemfile Gemfile
bundle exec jekyll serve --livereload
```

(See project [Dockerfile](Dockerfile) and [docker-compose.yml](docker-compose.yml) for the production-ready configuration.)

## Deployment
Production is compatible with GitHub Pages or Netlify. This repository ships a Jekyll site using the `just-the-docs` theme (see [Gemfile](Gemfile)). The included Docker configuration can be used for production deployments.

## Contributing
- Open an issue or submit a pull request.
- Join the community on Discord: https://discord.gg/xGFkBv9a5X
- Follow repository conventions: update nav_order/front matter and include images via `_includes/figure.html`.

## Useful files & Architecture
- [Dockerfile](Dockerfile) - A ruby-slim based image containing all necessary build tools (build-essential, imagemagick, etc.).
- [docker-compose.yml](docker-compose.yml) - Defines the service, maps the LiveReload port (35729), and sets up persistent volume caching.
- [bin/entrypoint.sh](bin/entrypoint.sh) - The engine of the container; manages process signals, Gemfile.lock integrity, and the inotify watch loop.

## License
This project uses the MIT license — see [LICENSE](LICENSE) for details.
