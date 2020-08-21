FROM chrisbnk/android-base:0.1

LABEL maintainer "christianb.public@gmail.com"

WORKDIR /home

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

# Create Emulator
ARG EMULATOR_NAME=emulator_${ANDROID_PLATFORM_VERSION}
RUN /opt/android/cmdline-tools/tools/bin/avdmanager create avd -f -n ${EMULATOR_NAME} -b x86_64 -g google_apis -d "Nexus 5X" -c 128M -k "${ANDROID_SYSTEM_IMAGE}"
