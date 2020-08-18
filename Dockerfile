# Ubuntu 20.04 LTS: end of standard support: April 2025
FROM ubuntu:20.04

LABEL maintainer "christianb.public@gmail.com"

WORKDIR /home

SHELL ["/bin/bash", "-c"]

ENV ANDROID_HOME=/opt/android
ENV PATH "$PATH:$GRADLE_HOME/bin:/opt/gradlew:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/platform-tools:${ANDROID_NDK_HOME}:$ANDROID_HOME/build-tools/${ANDROID_BUILD_TOOLS_LEVEL}"
ENV LD_LIBRARY_PATH "$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib"

# To avoid "tzdata" asking for geographic area
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y openjdk-8-jdk git unzip libglu1 libpulse-dev libasound2 libc6  libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxi6  libxtst6 libnss3 wget curl

# AppCenter CLI (from npm), https://docs.microsoft.com/en-us/appcenter/cli/ https://github.com/microsoft/appcenter-cli
RUN apt-get install -y npm \
  && npm install appcenter-cli

# envman (For cross tooling environment variable access), https://github.com/bitrise-io/envman/releases
RUN wget $(echo "https://github.com/bitrise-io/envman/releases/download/2.3.0/envman-$(uname -s)-$(uname -m)") -P /usr/local/bin/ \
  && mv /usr/local/bin/$(echo "envman-$(uname -s)-$(uname -m)") /usr/local/bin/envman \
  && chmod +x /usr/local/bin/envman

# gcloud (needed for FireBase)
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
  && apt-get update -y \
  && apt-get install google-cloud-sdk -y

# Android command line tools
ARG COMMAND_LINE_TOOLS=commandlinetools-linux-6200805_latest.zip
RUN mkdir /opt/android \
  && mkdir /opt/android/cmdline-tools \
  && wget "https://dl.google.com/android/repository/${COMMAND_LINE_TOOLS}" -P /tmp \
  && unzip -d /opt/android/cmdline-tools /tmp/${COMMAND_LINE_TOOLS} \
  && rm /tmp/${COMMAND_LINE_TOOLS}

# Platform-Tools
RUN yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --install "platform-tools" \
  && yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --licenses

# Platform
ARG ANDROID_API_LEVEL=29
RUN yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --install "platforms;android-${ANDROID_API_LEVEL}" \
  && yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --licenses

# Build-Tools, https://developer.android.com/studio/releases/build-tools
ARG ANDROID_BUILD_TOOLS_LEVEL=${ANDROID_API_LEVEL}.0.3
RUN yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --install "build-tools;${ANDROID_BUILD_TOOLS_LEVEL}" \
  && yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --licenses

# Android System Image
ARG ANDROID_SYSTEM_IMAGE=system-images;android-${ANDROID_API_LEVEL};google_apis;x86_64
RUN /opt/android/cmdline-tools/tools/bin/sdkmanager --install "${ANDROID_SYSTEM_IMAGE}"

# Create Emulator
ARG EMULATOR_NAME=cli_emu
RUN /opt/android/cmdline-tools/tools/bin/avdmanager create avd -f -n ${EMULATOR_NAME} -b x86_64 -g google_apis -d "Nexus 5X" -c 128M -k "${ANDROID_SYSTEM_IMAGE}"
