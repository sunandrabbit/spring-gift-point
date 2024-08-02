#!/bin/bash

DEPLOY_DIR="/home/ubuntu/spring-gift-point"
BRANCH="step1"

BUILD_PATH=$(ls ${DEPLOY_DIR}/build/libs/*.jar)
JAR_NAME=$(basename $BUILD_PATH)

echo "move spring-gitf-point"
cd $DEPLOY_DIR

echo "Git fetch origin"
git fetch origin

echo "Git checkout $BRANCH"
git checkout $BRANCH

echo "Git pull origin $BRANCH"
git pull origin $BRANCH

echo "Re Build for new Code"
./gradlew bootJar

echo "check running process PID"
CURRENT_PID=$(pgrep -f $JAR_NAME)

if [ -z "$CURRENT_PID" ]; then
        echo "No Exists Running Process"
else
        echo "Running Process Kill: $CURRENT_PID"
        kill -15 $CURRENT_PID
        sleep 5
fi

echo "make deploy directory"
DEPLOY_PATH="/home/ubuntu/spring-gift-point/app/"
mkdir -p $DEPLOY_PATH

echo "move deploy path"
cp $BUILD_PATH $DEPLOY_PATH
cd $DEPLOY_PATH

DEPLOY_JAR=${DEPLOY_PATH}$(basename $BUILD_PATH)

echo "application running bg"
nohup java -jar $DEPLOY_JAR > /dev/null 2> /dev/null < /dev/null &

echo "deploy success"