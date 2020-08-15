# https://medium.com/@simplatex/how-to-build-a-lightweight-docker-container-for-android-build-c52e4e68997e

FROM ubuntu:19.10

LABEL maintainer "christianb.public@gmail.com"

WORKDIR /home/dev

SHELL ["/bin/bash", "-c"]

# To avoid "tzdata" asking for geographic area
ARG DEBIAN_FRONTEND=noninteractive

# Dependencies and needed tools
RUN apt-get update && apt-get install -y openjdk-8-jdk git unzip libglu1 libpulse-dev libasound2 libc6  libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxi6  libxtst6 libnss3 wget

# Download gradle, install gradle and gradlew
# ARG GRADLE_VERSION=6.5.1

#RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp \
#&& unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip \
#&& mkdir /opt/gradlew \
#&& /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle wrapper --gradle-version ${GRADLE_VERSION} --distribution-type all -p /opt/gradlew  \
#&& /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle wrapper -p /opt/gradlew

# Download commandlinetools, install packages and accept all licenses
ARG ANDROID_API_LEVEL=29
# https://developer.android.com/studio/releases/build-tools
ARG ANDROID_BUILD_TOOLS_LEVEL=29.0.3

RUN mkdir /opt/android \
&& mkdir /opt/android/cmdline-tools \
&& wget 'https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip' -P /tmp \
&& unzip -d /opt/android/cmdline-tools /tmp/commandlinetools-linux-6200805_latest.zip \
&& yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --install "build-tools;${ANDROID_BUILD_TOOLS_LEVEL}" "platforms;android-${ANDROID_API_LEVEL}" "platform-tools" \
&& yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --licenses

# Clean up
# RUN rm /tmp/gradle-${GRADLE_VERSION}-bin.zip
RUN rm /tmp/commandlinetools-linux-6200805_latest.zip

# SDK Image
ARG EMULATOR=cli_emu
ARG SYSTEM_IMAGE=system-images;android-${ANDROID_API_LEVEL};google_apis;x86_64

RUN /opt/android/cmdline-tools/tools/bin/sdkmanager --install "${SYSTEM_IMAGE}"
RUN /opt/android/cmdline-tools/tools/bin/avdmanager create avd -f -n ${EMULATOR} -b x86_64 -g google_apis -d "Nexus 5X" -c 128M -k "${SYSTEM_IMAGE}"

RUN apt-get install -y curl

# Environment variables to be used for build
# ENV GRADLE_HOME=/opt/gradle/gradle-$GRADLE_VERSION
ENV ANDROID_HOME=/opt/android
ENV ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/${ANDROID_NDK_VERSION}
ENV PATH "$PATH:$GRADLE_HOME/bin:/opt/gradlew:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/platform-tools:${ANDROID_NDK_HOME}:$ANDROID_HOME/build-tools/${ANDROID_BUILD_TOOLS_LEVEL}"
ENV LD_LIBRARY_PATH "$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib"

# Install npm (needed for AppCenter)
# https://docs.microsoft.com/en-us/appcenter/cli/
# https://github.com/microsoft/appcenter-cli
RUN apt-get install -y npm \
  && npm install -g appcenter-cli

# Install Envman (For cross tooling environment variable access)
# https://github.com/bitrise-io/envman/releases
#RUN curl -fL https://github.com/bitrise-io/envman/releases/download/2.3.0/envman-$(uname -s)-$(uname -m) > /usr/local/bin/envman
RUN wget $(echo "https://github.com/bitrise-io/envman/releases/download/2.3.0/envman-$(uname -s)-$(uname -m)") -P /usr/local/bin/
RUN mv /usr/local/bin/$(echo "envman-$(uname -s)-$(uname -m)") /usr/local/bin/envman
RUN chmod +x /usr/local/bin/envman

# Install gcloud sdk (FireBase)
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y
