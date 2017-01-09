#!/bin/bash
set -x
set -e

OAUTH=""
STAGING_DOC_FOLDER=/home/greg/docs-autodeploy/staging
TMP_DIR=$(mktemp -d)
CONTAINER_NAME=mender-docs-site

function update_staging() {

    git clone https://gregdistefano:${OAUTH}@github.com/mendersoftware/mender-docs-site $TMP_DIR
    cp -r $STAGING_DOC_FOLDER/*/* $TMP_DIR/user/pages/

    cd $TMP_DIR
    docker build -t $CONTAINER_NAME .
    docker tag $CONTAINER_NAME mendersoftware/$CONTAINER_NAME:staging
    docker push mendersoftware/$CONTAINER_NAME:staging

    docker kill staging || true
    docker rm -vf staging || true
    rm -rf $TMP_DIR

    # grab the new docker container
    docker pull mendersoftware/$CONTAINER_NAME:staging

    docker run --name=staging \
               -d \
               -p 8080:80 -t mendersoftware/$CONTAINER_NAME:staging

}

(
    flock -n 200
    update_staging
) 200>/var/lock/.docslock
