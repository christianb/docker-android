# Docker Android CI

This is my docker image containing all tools for Android to be used on a CI.

# Upload new Image to DockerHub
First you must build and tag the docker image: `docker build -t <DOCKER_ID_USER>/android-ci:latest .`

Then you can push the image: `docker push <DOCKER_ID_USER>/android-ci:latest`

# Local Testing
Execute `docker-compose build` to build the image locall.
Then run `run.sh` to start the image.
