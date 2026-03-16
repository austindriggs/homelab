#!/bin/bash

# NOTE: I DO NOT RUN THIS ENTIRE SCRIPT, THESE COMMANDS ARE RUN MANUALLY
# AS NEEDED AND I JUST KEEP THEM HERE FOR REFERENCE. I RUN THEM ONE AT A TIME.
#
# This script is used to clean up old Docker images and containers.
# It can be run manually or set up as a cron job.
#
# This was created on 2026-03-14 after noticing that Immich (and docker)
# had accumulated a lot of old images and containers, taking up a lot of disk space,
# and resulting in my MMC storage getting to 100% full and crashing my server.

# View reclamable space in memory
docker system df

# Remove all stopped containers and unused images
docker container prune -a
docker system prune -a

# Remove all unused volumes and networks
docker volume prune -a
docker network prune -a

# Optionally, you can also remove all unused build cache
docker builder prune -a

# A catch all command to remove all unused data (containers, images, volumes, networks, and build cache)
# WARNING: This will remove ALL unused data, so use with caution!
docker system prune -a






# Clear out storage consumed by Docker logs and temporary files
truncate -s 0 /var/lib/docker/containers/*/*-json.log





# Add a logging section to your docker-compose.yml to cap file sizes:
services:
  immich-server:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"



# apply that logging limit to all your containers at once using the daemon.json file
sudo nano /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
docker compose down
sudo systemctl restart docker
docker compose up -d






# https://stackoverflow.com/questions/51238891/how-to-fix-the-running-out-of-disk-space-error-in-docker
#
# If you are using linux, then most probably docker is filling up the directory /var/lib/docker/containers, 
# because it is writing container logs to <CONTAINER_ID>-json.log file under this directory. You can use the 
# command cat /dev/null > <CONTAINER_ID>-json.log to clear this file or you can set the maximum log file size 
# be editing /etc/sysconfig/docker. More information can be found in this RedHat documentation. In my case, 
# I have created a crontab to clear the contents of the file every day at midnight. Hope this helps!
# 
# NB:
# You can find the docker containers with ID using the following command sudo docker ps --no-trunc
# You can check the size of the file using the command du -sh $(docker inspect --format='{{.LogPath}}' CONTAINER_ID_FOUND_IN_LAST_STEP)
