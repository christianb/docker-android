# Docker Android CI
This is a docker image containing all tools for Android to be used on a CI.

This repository contains two Dockerfiles.
* `android-base`: contains the minmal setup for Android.
* `android-ci`: contains a setup required for a CI integration.

# Upload new Image to DockerHub
First you must build and tag the docker image: `docker build -t <DOCKER_ID_USER>/android-ci:<VERSION> .`

Then you can push the image: `docker push <DOCKER_ID_USER>/android-ci:<VERSION>`

# Local Testing
Execute `docker-compose build` to build the image locally. Then execute `run.sh` to start the image.
