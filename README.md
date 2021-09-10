# Fly.io nginx redirection

Experiment with https://fly.io/ by deploying a very minimal nginx server to just
serve HTTP 301 redirects, and automate deployments for that with GitHub Actions
and GitHub Container Registry.

Don't copy this if you want to serve HTTP redirects, there are many better ways
of doing that. This is mainly about experimenting with Fly, GitHub Actions and
GHCR.

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

I am using GitHub Actions to run tests on every push. It uses docker compose to
run the nginx container and also a testing container which runs
[Bats](https://github.com/bats-core/bats-core) and
verifies that the container works and serves a valid redirection.

I'm not happy with the number of third party dependencies this testing requires.
At the moment GitHub Actions starts an Ubuntu container, which runs Docker
Compose, which builds both the nginx container and a Bats container for the
tests. In the Bats container, Bats runs curl to test the site. It feels like
that could be massively simplified.

## GitHub Container Registry

<s>GitHub Container Registry (GHCR) is still in beta as of the time of writing, so
this bit might be all wrong by the time you read it.</s> 
*GHCR is generally available now, and this is all still accurate.*

The Fly `docker` builder which we used in the initial standalone deployment builds
the container at deployment time and stores it in Fly's own registry to deploy
from. But we also need the container to exist during the CI testing stage -
which needs to happen before deployment, so it gets built then as well.

To avoid this duplication of work and to also solve the potential problem of the
deployed image differing from the one we tested due to different toolchains, you
should build the image once, then test it, then deploy it once the tests have
passed.

I'm storing this image in GHCR after building, and have set the GitHub workflow
to tag the image with the hash of the git commit it was built from, and the
testing and Fly deploy are configured to pull the image from GHCR when they
need it.

# Feature Creep

I have had a desire for some time now to run my own https://icanhazip.com/
equivalent service to return back the user's IP address. This has nothing to do
with serving 301 redirects, but it's trivial to do with a few lines of nginx
config, so that's now up on https://ip.plett.net/ .
