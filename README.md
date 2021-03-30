# Fastlane Runner

## What is it?
A docker container that runs a Fastlane lane.

## How do I use it?
The container can be run in one of two ways:
1. In an Azure DevOps pipeline. In this case, you define the steps you want to run in the DevOps `pipelines.yaml` file. Typically you'll only need one step: Run the Fastlane lane you want.
1. Locally, by providing the Fastlane lane (and a few other arguments) as environment variables.

## What environment variables do I need to run it locally?
1. **GIT_REPOSITORY**: URL to the repo to checkout from. Required.
1. **GIT_BRANCH**: Branch to checkout. Optional, defaults to "master" if not set.
1. **FASTLANE_PLATFORM**: The Fastlane platform name to use (e.g. "android"). Optional, but if not set, Fastlane will not be run.
1. **FASTLANE_LANE**: The Fastlane lane to run (e.g. "app_test"). Optional, but if not set, Fastlane will not be run.
