# Docker Services

This directory is structured based off of the stacks I have in Portainer.


## Portainer

From: https://docs.portainer.io/start/install-ce/server/docker/linux.

Create the volume that Portainer Server will use to store its database:
```bash
sudo docker volume create portainer_data
```

Then, download and install the Portainer Server container (note I changed the host port):
```bash
docker run -d -p 8000:8000 -p 8097:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts
```

Verify installation with `docker ps` and then navigate to `https://driggs-zb:8097`.
