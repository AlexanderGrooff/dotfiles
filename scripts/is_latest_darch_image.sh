#!/usr/bin/env bash

set -e

IMAGE_NAME=${1:-"darch-desktop"}
DOCKER_REPOSITORY=${2:-"docker.agrooff.com"}
TAG_NAME=${3:-"latest"}

function find_latest_remote_sha {
    docker-ls tag $IMAGE_NAME:$TAG_NAME --registry "https://$DOCKER_REPOSITORY" --basic-auth |& grep digest | awk '{print$2}'
}

function find_latest_local_sha {
    sudo ctr -n darch i ls | grep $DOCKER_REPOSITORY/$IMAGE_NAME:$TAG_NAME | awk '{print$3}'
}

test "$(find_latest_remote_sha)" == "$(find_latest_local_sha)"
