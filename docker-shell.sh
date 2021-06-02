#!/bin/bash

set -e

export IMAGE_NAME="google-image-downloader"

docker build -t $IMAGE_NAME -f Dockerfile .
docker run --rm --name $IMAGE_NAME -ti -v "$(pwd)/:/app/" $IMAGE_NAME