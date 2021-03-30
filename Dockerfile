FROM ubuntu:20.04

# Ubuntu 20.04 has some BS timezone noncery during the setup that we need to skip.
ARG DEBIAN_FRONTEND=noninteractive

# This tells Azure DevOps Pipelines where to find the Node binary, which is used to execute pipeline step commands in this container.
LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/bin/node"

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Update apt and install the tools we need. We do this all in one step because we need to combine it with an apt-get update, else we can (and have) run into caching issues.
RUN apt update && apt install -y --no-install-recommends \
    nodejs \
    sudo \
    wget \
    unzip \
    git \
    ruby \
    ruby-dev \
    libc6-dev \
    g++ \
    make \
    locales \
    openjdk-8-jdk \
    android-sdk

# Set Android SDK path and add it to $PATH
ENV ANDROID_SDK_ROOT =/usr/lib/android-sdk
ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin:$PATH"
ENV WORK_DIR=/work/

# # Create the directory for our script(s) and work.
RUN mkdir /scripts $WORK_DIR
COPY scripts/setup-sdk.sh scripts/entrypoint-local.sh /scripts/
RUN chmod 777 /scripts/*

# Install the Android SDK
RUN /scripts/setup-sdk.sh

# Install Fastlane
RUN locale-gen en_GB.UTF-8
ENV LC_ALL=en_GB.UTF-8
ENV LANG=en_GB.UTF-8
RUN gem install fastlane bundler
