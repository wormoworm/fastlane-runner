#!/bin/bash
# Run when the container is run locally. Performs a number of tasks:
# 1: Clones the repository specified by the mandatory environment variable GIT_REPOSITORY, with the optional branch specified by GTI_BRANCH (defaults to master). 
# 2: Executes any scripts found in /scripts/local. The execution order is alphabetic, so scripts should be prefixed with numbers to control the order in which they are run.
# 3: Runs the Fastlane specified by the mandatory environment variables FASTLANE_PLATFORM and FASTLANE_LANE.

colour_red="\033[31m"
colour_green="\033[32m"
colour_yellow="\033[33m"
colour_reset="\033[0m"

# 1: Clone Git repo.
if [ -z "$GIT_REPOSITORY" ]
then
    printf "GIT_REPOSITORY not set. Exiting...\n"
    exit
else
    default_git_branch=master
    if [ -z "$GIT_BRANCH" ]
    then
        branch=${default_git_branch}
    else
        branch=$GIT_BRANCH
    fi
    echo "Branch: ${branch}"

    git clone -b $branch $GIT_REPOSITORY $WORK_DIR
    cd $WORK_DIR
fi

# 2: Run any scripts found in the local scripts directory.
local_scripts_directory=/scripts/local/

if [ -d "${local_scripts_directory}" ]
then
    for script in ${local_scripts_directory}*.sh
    do
        printf "\n\n"
        printf "${colour_yellow}==================================================\n"
        printf "===== Script \"$script\"\n"
        printf "==================================================\n${colour_reset}"
        cd ${local_scripts_directory}
        (. ${script})
        return_code=$?
        if [ "${return_code}" -eq 0 ]; then
            printf "${colour_green}==================================================\n"
            printf "===== Script \"${script}\" ran successfully\n"
            printf "==================================================\n${colour_reset}"
        else
            printf "${colour_red}==================================================\n"
            printf "===== Script \"${script}\" failed (return code = $return_code). Skipping pending scripts...\n"
            printf "==================================================\n${colour_reset}"
            exit $return_code
        fi
        done
else
    printf "Local scripts directory not found. Skipping...\n"
fi

# 3: Run Fastlane
if [ -z "$FASTLANE_PLATFORM" ] || [ -z "$FASTLANE_LANE" ]
then
    printf "FASTLANE_PLATFORM or FASTLANE_LANE not set. Skipping...\n"
else
    cd $WORK_DIR
    bundle install
    bundle exec fastlane $FASTLANE_PLATFORM $FASTLANE_LANE
fi