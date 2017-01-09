#!/bin/bash
set -e
set -x
set -u

DOCS_PATH="/home/greg/docs-autodeploy/staging"
OAUTH=""
GITHUB_USER="gregdistefano"
MENDER_DOCS_REPO="GregorioDiStefano/mender-docs"

declare -A branches
branches[stable]=01.Stable
branches[master]=02.Master

rm -rf ${DOCS_PATH:?}/

for branch in "${!branches[@]}"
do
    TMP_DIR=$(mktemp -d)
    git clone -b $branch https://${GITHUB_USER}:${OAUTH}@github.com/${MENDER_DOCS_REPO} $TMP_DIR

    mkdir -p "$DOCS_PATH/$branch/${branches[$branch]}/"
    mv $TMP_DIR/* "$DOCS_PATH/$branch/${branches[$branch]}/"

    rm -rf $TMP_DIR
done
