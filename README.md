# fly.io nginx redirection

Experiment with fly.io by deploying a very minimal nginx server to just serve
HTTP 301 redirects, and automate deployments for that with GitHub Actions. 

Don't copy this if you want to serve HTTP redirects, there are many better ways
of doing that. This is mainly about experimenting with Fly and GitHub Actions.

## Initial standalone deployment

* Make a Dockerfile for the content you want to serve
* `flyctl init` and select Docker builder
* `flyctl deploy` to get initial version online

## Adding CD

* The master branch should always match what is deployed. Any testing or
  development should happen in a feature branch and then be merged.
* `flyctl auth token` to get token, add to GitHub repo as FLY_API_TOKEN
* create a `.github/workflows/main.yml` which uses superfly/flyctl-actions to
  deploy to Fly, triggered on pushes to the master branch.

## Adding domains

It already works on the dynamicly generated domain name, in this case
https://bold-silence-8386.fly.dev but up to 10 additional hostnames with
letsencrypt certs are included in the fly.io free tier.

* `flyctl certs create yourdomain.com`

This will print out `_acme-challenge` details to put in DNS. Do that. Then wait
for fly.io to pick up on it. Once live, create A+AAAA (or CNAME) records to
redirect traffic.

## Keeping it up to date

Dependabot can be used to keep you up to date with changes in your dependencies.
In this instance it's the `nginx` Docker image that we are building on top of
and the versions of the actions in the GitHub workflow. It will make pull
requests with changes to bump versions.

## CI testing

Through a remarkably convoluted method, I am using GitHub Actions to run tests
on every push. It uses docker compose to run the nginx container and also a
testing container which runs Bats and verifies that the container works and
serves a valid redirection.

## Future steps

At the moment GitHub builds the container twice - once to run tests on it and
then again as it gets deployed to Fly. There is a remote possible that these two
images might differ and the deployed image might be broken.

This could be fixed by building a docker image, testing it, and then pushing it
to a registry (GHCR?) once tests have passed. Fly can then be changed over to
use the `image` deployment method instead of the `docker` builder, so the
deployed image is byte-for-byte identical to the one that passed testing.
