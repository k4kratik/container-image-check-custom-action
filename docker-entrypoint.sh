#!/bin/bash

CONTAINER_REPO_NAME="$2"
CONTAINER_IMAGE_TAG="$3"

# in case if it is a Docker image
DOCKER_HUB_USERNAME="$4"
DOCKER_HUB_PAT="$5"

function check_ecr_image_tag_if_exists() {

    echo "Started Image & Tag checking for repo $CONTAINER_REPO_NAME for tag $IMAGE_TAG"

    IMAGE_META="$(aws ecr describe-images --repository-name=$CONTAINER_REPO_NAME --image-ids=imageTag=$CONTAINER_IMAGE_TAG 2>/dev/null)"

    if [[ $? == 0 ]]; then
        IMAGE_TAGS="$(echo ${IMAGE_META} | jq '.imageDetails[0].imageTags[0]' -r)"
        echo $IMAGE_TAGS
        echo "image_exists=true" >>$GITHUB_OUTPUT
        echo "Image $1:$2 exists on ecr."
        echo $IMAGE_META
    else
        echo "$1:$2 does not exist on ecr."
        echo "image_exists=false" >>$GITHUB_OUTPUT
    fi

}

function check_docker_image_tag_if_exists() {

    echo "Started Image & Tag checking for repo $CONTAINER_REPO_NAME by user $DOCKER_HUB_USERNAME for tag $CONTAINER_IMAGE_TAG"

    TOKEN=$(curl -sSLd "username=${DOCKER_HUB_USERNAME}&password=${DOCKER_HUB_PAT}" https://hub.docker.com/v2/users/login | jq -r ".token")
    REPO_RESPONSE=$(curl -sH "Authorization: JWT $TOKEN" "https://hub.docker.com/v2/repositories/${DOCKER_HUB_USERNAME}/${CONTAINER_REPO_NAME}/tags/${CONTAINER_IMAGE_TAG}/")

    echo
    echo Response is:
    # echo $REPO_RESPONSE | jq .
    echo
    echo Tag status is:
    TAG_STATUS=$(echo $REPO_RESPONSE | jq .tag_status | tr -d '"')
    echo $TAG_STATUS
    echo

    if [[ $TAG_STATUS == *"active"* ]]; then
        echo Docker Image $CONTAINER_REPO_NAME exists with Tag $CONTAINER_IMAGE_TAG
        echo "image_exists=true" >>$GITHUB_OUTPUT
    else
        echo "Docker Image Does Not Exist"
        echo "image_exists=false" >>$GITHUB_OUTPUT
    fi
}

# -------------------------------------------------------------------------

if [[ $1 == "ecr" ]]; then
    echo "got ecr: $1"
    check_ecr_image_tag_if_exists
elif [[ $1 == "dockerhub" ]]; then
    echo "got dockerhub: $1"
    check_docker_image_tag_if_exists
else
    echo "Unsupported Registry: $1"
    exit 1
fi
