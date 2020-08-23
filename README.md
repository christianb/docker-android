# Docker Android CI
These are docker images containing all tools for Android to be used on a CI. <br>
The docker images are hosted on [DockerHub](https://hub.docker.com/repositories/sensorberg).

The repository contains two Dockerfiles.
* [android-base](https://hub.docker.com/repository/docker/sensorberg/android-base): contains the minmal setup for Android.
* [android-ci](https://hub.docker.com/repository/docker/sensorberg/android-ci): depends on `android-base` and contains a setup required for a CI integration.

### Build a new image
To build and tag the a new docker image: `docker build -t sensorberg/android-ci:<VERSION> .`

### Push image to DockerHub
Push the image: `docker push sensorberg/android-ci:<VERSION>`

### Local Testing
Execute `docker-compose build` to build the image locally. Then execute `run.sh` to start the image.
