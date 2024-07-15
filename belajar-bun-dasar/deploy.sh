#!/bin/bash

#fool's man CI/CD

CONTAINER_NAME="bunjs_example"
IMAGE_NAME="bunjs_example"
ENV_FILE=".env"
HOST_PORT=4999
CONTAINER_PORT=4999
LOG_DIR="$(pwd)/logs"

#pwd
# Print current working directory
pwd

# Ensure the log directory exists on the host
if [ ! -d "$LOG_DIR" ]; then
  mkdir -p "$LOG_DIR"
  echo "Directory $LOG_DIR created."
else
  echo "Directory $LOG_DIR already exists."
fi

echo "LOCAL: Build and save image"
docker build -t $IMAGE_NAME .

# check build docker failed or success
if [ $? -ne 0 ]; then
  echo "Image build failed. Exiting."
  exit 1
fi

echo "Saving the image to image.tar"
docker save -o image.tar $IMAGE_NAME

echo "DOCKER LOCAL: Stop and remove container"
# Stop and remove new container if it exists
docker container stop $CONTAINER_NAME 2>/dev/null
docker container rm $CONTAINER_NAME 2>/dev/null

echo "Loading the image from image.tar"
docker load -i image.tar

# Run new container
echo "DOCKER LOCAL: Run $IMAGE_NAME image as $CONTAINER_NAME"
docker run -d -p $HOST_PORT:$CONTAINER_PORT \
  --name $CONTAINER_NAME \
  --env-file=$ENV_FILE \
  -v $LOG_DIR:/usr/src/app/logs \
  $IMAGE_NAME

if [ $? -eq 0 ]; then
  echo "New container started successfully. Stopping and removing old container."
  rm image.tar
else
  echo "Failed to start new container. Keeping the old container running."
  docker container stop $CONTAINER_NAME
  docker container rm $CONTAINER_NAME
fi

echo "ok"

