# Ubuntu 20.04 LTS: end of standard support: April 2025
FROM ubuntu:20.04

# To avoid "tzdata" asking for geographic area
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y openjdk-8-jdk git unzip wget curl

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

# Platform, https://developer.android.com/studio/releases/platforms
ENV ANDROID_PLATFORM_VERSION=29
RUN yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --install "platforms;android-${ANDROID_PLATFORM_VERSION}" \
  && yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --licenses

# Build-Tools, https://developer.android.com/studio/releases/build-tools
ARG ANDROID_BUILD_TOOLS_VERSION=${ANDROID_PLATFORM_VERSION}.0.3
RUN yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --install "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
  && yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --licenses

# Android System Image
ENV ANDROID_SYSTEM_IMAGE=system-images;android-${ANDROID_PLATFORM_VERSION};google_apis;x86_64
RUN /opt/android/cmdline-tools/tools/bin/sdkmanager --install "${ANDROID_SYSTEM_IMAGE}"

ENV ANDROID_HOME=/opt/android
ENV PATH "$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/${ANDROID_BUILD_TOOLS_VERSION}"
ENV LD_LIBRARY_PATH "$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib"

WORKDIR /home
