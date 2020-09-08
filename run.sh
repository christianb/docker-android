#!/bin/sh

docker build -t sensorberg/android-ci:latest .
docker run -it sensorberg/android-ci:latest /bin/bash
