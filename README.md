<p align="left">
 <a href="https://github.com/aaronplayz-sys/frontier-biz/actions/workflows/ci.yml"><img src="https://github.com/aaronplayz-sys/frontier-biz/actions/workflows/ci.yml/badge.svg" alt="CI Build status"></a> <a href="https://github.com/aaronplayz-sys/frontier-biz/actions/workflows/pages.yml"><img src="https://github.com/aaronplayz-sys/frontier-biz/actions/workflows/pages.yml/badge.svg" alt="Netlify Status"></a>
</p>

# Frontier Biz

Titanfall 2 — Frontier Defense guides and reference content.

## Quick overview
A collection of guides for Frontier Defense on Titanfall 2: pilots, titans, kits, aegis progression, economy, and more.

## Quick start (development & production)
Requirements: Docker / Docker Compose.

The provided Docker configuration works for both development and production environments.

### Production
Simply type the following command into the terminal to run production mode

```BASH
docker compose -f compose.yaml -f compose.prod.yaml up -d --build
```
It may take a few minutes on the first time since the image is being built locally.

After building for the first time you can drop the `--build` from the command

```BASH
docker compose -f compose.yaml -f compose.prod.yaml up -d
```
Site will be avaliable at port 4000. 

### Development
If your making changes and want to see them get processsed use development mode. The command is simular to production mode.

```BASH
docker compose -f compose.yaml -f compose.dev.yaml up --build
```

It may take a few minutes on the first time since the image is being built locally.

After building for the first time you can drop the `--build` from the command

```BASH
docker compose -f compose.yaml -f compose.dev.yaml up
```

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

(See project [Dockerfile](Dockerfile), [compose.yaml](compose.yaml), and [compose.prod.yaml](compose.prod.yaml) for the production-ready configuration.)

## Deployment
Production is compatible with GitHub Pages or Netlify. This repository ships a Jekyll site using the `just-the-docs` theme (see [Gemfile](Gemfile)). The included Docker configuration can be used for production deployments.

## Contributing
- Open an issue or submit a pull request.
- Join the community on Discord: https://discord.gg/xGFkBv9a5X
- Follow repository conventions: update nav_order/front matter and include images via `_includes/figure.html`.

## License
This project uses the MIT license — see [LICENSE](LICENSE) for details.
