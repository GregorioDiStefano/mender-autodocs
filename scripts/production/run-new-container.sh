#!/bin/bash
PRODUCTION_RUNNING=$(docker inspect -f {{.State.Running}} production)

# if for whatever reason, the website container is not running, run it.
if [ $PRODUCTION_RUNNING == "false" ]; then
	echo "The docs container isn't running! Attempting to start it"
	docker rm -vf production || true
	docker run --name=production \
           	   -d \
                   -p 8080:80 -t mendersoftware/mender-docs-site:production
fi

echo "Pulling for new docker containers"
DOCKER_PULL_TEMP=$(mktemp)
docker pull mendersoftware/mender-docs-site:staging > $DOCKER_PULL_TEMP

if [ -z $? ]; then
	echo "Failed to pull from docker hub"
	exit 1
fi

grep -i "downloaded newer image" $DOCKER_PULL_TEMP && {
	echo "Downloaded new docker container.."
	docker tag mendersoftware/mender-docs-site:production mendersoftware/mender-docs-site:previous_production
        docker push mendersoftware/mender-docs-site:previous_production

	docker tag mendersoftware/mender-docs-site:staging mendersoftware/mender-docs-site:production
        docker push mendersoftware/mender-docs-site:production

	docker kill production || true
	docker rm -vf production || true

	docker run --name=production \
           	   -d \
                   -p 8080:80 -t mendersoftware/mender-docs-site:production
} || {
	echo "No new container found"
}

rm $DOCKER_PULL_TEMP
