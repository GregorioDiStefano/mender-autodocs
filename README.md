Python script listens for new mender-docs or mender-docs-site repo. changes via GitHub Webhooks. (running on the staging server)

When either repo. changes, the script pulls both code repositories, rebuilds the site, and pushes the new docker container to docker hub.

On the production server, a cronjob pulls for new docker containers (cronjob) and when it detects a new container, it tags the current production site as "production_previous" and takes the current staging container, tags it as "production" and runs it.
