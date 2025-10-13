# Frontier Biz

Titanfall 2 — Frontier Defense guides and reference content.

## Quick overview
A collection of guides for Frontier Defense on Titanfall 2: pilots, titans, kits, aegis progression, economy, and more.

## Quick start (development)
Requirements: Docker / Docker Compose.

Start the local dev server (builds the site in a container and serves with Jekyll):

```sh
docker compose up -d
```

Access the site at http://localhost:4000.

If you modify Ruby gems or want to run locally without Docker, make sure you are using Ruby version 3.4.2:

```sh
gem install bundler
bundle install --gemfile Gemfile
bundle exec jekyll serve --host 0.0.0.0
```

(See project [Dockerfile](Dockerfile) and [docker-compose.yml](docker-compose.yml).)

## Deployment
Production is compatible with GitHub Pages or Netlify. This repository ships a Jekyll site using the `just-the-docs` theme (see [Gemfile](Gemfile)). There is no docker image to use for production, help is welcomed.

## Contributing
- Open an issue or submit a pull request.
- Join the community on Discord: https://discord.gg/xGFkBv9a5X
- Follow repository conventions: update nav_order/front matter and include images via `_includes/figure.html`.

## Useful files
- [Dockerfile](Dockerfile)
- [docker-compose.yml](docker-compose.yml)
- [Gemfile](Gemfile)
- [LICENSE](LICENSE)
- Site entry: [index.md](index.md)

## License
This project uses the MIT license — see [LICENSE](LICENSE) for details.
