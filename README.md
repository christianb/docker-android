# Docker Android CI
These are docker images containing all tools for Android to be used on a CI. <br>
The docker images are hosted on [DockerHub](https://hub.docker.com/repositories/sensorberg).

### Build a new image
To build and tag the a new docker image: `docker build -t sensorberg/android-ci:<VERSION> .`

### Push image to DockerHub
Push the image: `docker push sensorberg/android-ci:<VERSION>`

### Links
* [Build a Lightweight Docker Container For Android Testing](https://medium.com/better-programming/build-a-lightweight-docker-container-for-android-testing-2aa6bdaea422) by Phát Phát
