# fly.io nginx redirection

Experiment with fly.io by deploying a very minimal nginx server to just serve
301 redirects, and automate deployments for that with GitHub Actions

## How to build

* Make a Dockerfile with the content you want to serve
* `flyctl init` and select Docker builder
* `flyctl deploy` to get initial version online

## Adding CI

* `flyctl auth token` to get token, add to GitHub repo as FLY_API_TOKEN
* create a `.github/workflows/main.yml` which uses superfly/flyctl-actions
