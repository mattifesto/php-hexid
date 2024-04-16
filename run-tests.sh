#!/usr/bin/env sh

APP_NAME='hexid-test-app'
TEST_APP_DIRECTORY='tmp/hexid-test-app'
REPLACE_DIRECTORY=false

while getopts "y" opt; do
  case $opt in
    y) REPLACE_DIRECTORY=true ;;
    \?) echo "Invalid option -$OPTARG" >&2 ;;
  esac
done

if [ -d "$TEST_APP_DIRECTORY" ]; then
    if [ "$REPLACE_DIRECTORY" = true ]; then
        rm -rf $TEST_APP_DIRECTORY
        mkdir -p $TEST_APP_DIRECTORY
    else
        read -p "Directory '$TEST_APP_DIRECTORY' already exists. Do you want to replace it? (y/N) " answer
        case $answer in
            [Yy]* ) rm -rf $TEST_APP_DIRECTORY; mkdir -p $TEST_APP_DIRECTORY;;
            * ) echo "Creation of the '$TEST_APP_DIRECTORY' was cancelled."; exit;;
        esac
    fi
else
    mkdir -p $TEST_APP_DIRECTORY
fi

# Get the current date and time in the format YYYY-MM-DD-HHMMSS
DOCKER_TAG_BUILD_DATE=$(TZ=America/Los_Angeles date "+%Y%m%dT%H%M%S")



# Copy all files from 'test-project-assets' to 'test-project'
cp -r assets/hexid-test-app/* $TEST_APP_DIRECTORY/
if [ $? -ne 0 ]; then
    exit 1
fi



(
    cd $TEST_APP_DIRECTORY



    echo "\n-----\nrun-test.sh: composer update\n-----\n"
    composer update
    if [ $? -ne 0 ]; then
        echo "composer update failed"
        exit 1
    fi



    echo "\n-----\nrun-test.sh: docker compose up --build --detach --remove-orphans\n-----\n"
    docker compose up --build --detach --remove-orphans
    if [ $? -ne 0 ]; then
        echo "docker compose up --build --detach --remove-orphans failed"
        exit 1
    fi



    echo "\n-----\nrun-test.sh: docker compose run --rm hexid-test-app-service php run-hexid-tests.php\n-----\n"
    docker compose run --rm hexid-test-app-service php run-hexid-tests.php
    if [ $? -ne 0 ]; then
        echo "docker compose run --rm hexid-test-app-service php run-hexid-tests.php failed"
        exit 1
    fi

)
