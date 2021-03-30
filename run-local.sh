#!/bin/bash
# Example helper script for running the fastlane-runner container locally with the necessary options. Used to make development of the itm-build-x86 image easier.
# Arguments:
# 1: The repository URL. Required.
# 2: The source branch to be checked out. Optional, defaults to "master" if not set.
# 3: The container's CMD. Optional, defaults to "/scripts/entrypoint.sh" if not set.
# 4: The container name. Optional, defaults to "fastlane-runner" if not set.

default_git_branch=master
default_cmd=/scripts/entrypoint-local.sh
default_container_name=fastlane-runner

if [ -z "$2" ] || [ $2 = "default" ]
then
    git_branch=${default_git_branch}
else
    git_branch=${2:-${default_git_branch}}
fi
container_cmd=${3:-${default_cmd}}

container_name=${4:-${default_container_name}}

echo "Will use branch: ${git_branch}"
echo "Will run command: ${container_cmd}"
echo "Will use container name: ${container_name}"

# Run the container with the necessary options.
sudo docker run -it --rm \
-e GIT_BRANCH=${git_branch} \
--name ${container_name} \
tomhomewood/fastlane-runner:latest $container_cmd