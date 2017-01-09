#!/bin/bash

echo "Pulling previous production container"
docker pull mendersoftware/mender-docs-site:previous_production

if [ -z $? ]; then
	echo "Failed to pull from docker hub"
	exit 1
fi

docker kill production || true
docker rm -vf production || true

docker run --name=production \
	   -d \
	   -p 8080:80 -t mendersoftware/mender-docs-site:previous_production
