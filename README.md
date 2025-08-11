# Frontier Biz 
## Titanfall 2 Guides

Some information may be unique and while others will have the same information in more than one depending on how universal mechanic is. Rest assured that everything is covered...

## Contributions
All contributions are welcomed. You may open a issue or pull request. Feel free to join our discord server to engage withthe comunity.

https://discord.gg/xGFkBv9a5X

## Deployment

### Production

Currently GitHub Pages and Netlify are known to work well. Might provide a docker image or docker files in the future.

### Testing and development

My favorite option to use is docker compose, files are already in the repository. Simply clone this repository and navigate to the folder and use the terminal to build the local image. This image is meant for development and testing purposes only.

An attempt was done to cache gems to an volume called bundle cache to reduce constant downloads from a cdn.

To run the container type `docker compose up -d`

Improvement to are welcomed.