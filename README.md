# Austin's Homelab

My apartment-lab documentation; hopefully one day with config files and such.


## SUMMARY

### DEBIAN SERVICES

| STATUS | SERVICE (LINK) | DESCRIPTION                                                                                      | LOCATION                                             |
| ------ | -------------- | ------------------------------------------------------------------------------------------------ | ---------------------------------------------------- |
| x      | SSH            | SSH over local network                                                                           | 127.16.58.224                                        |
| x      | Docker         | Used to install apps                                                                             | `docker ps`                                          |
| x      | mdadm          | Used for software RAID 1 configuration for my two hard drives                                    | `sudo mdadm --detail /dev/md0` or `cat /proc/mdstat` |
| x      | Tailscale      | Mesh VPN to connect                                                                              | 100.126.109.100                                      |
| x      | Samba          | Network share for `/mnt/raid1`                                                                   | `smb://driggs-zb/raid1/`                             |


### DOCKER APPS

| STATUS | SERVICE (LINK) | DESCRIPTION                         | LOCATION |
| ------ | -------------- | ----------------------------------- | -------- |
| x      | Portainer      | Managing docker apps                | 8097     |
| x      | Glance         | Something for a homepage            | 8080     |
| x      | Syncthing      | Sync files between devices          | 8057     |
|        | Immich         | Photo library for me                | 8013     |
| x      | Immich         | Photo library for my parents        | 8019     |
| x      | Jellyfin       | Video library for me and my parents | 8074     |
|        | Jellystat      | Video library statistics            | 8075     |


## RESOURCES

- From [Hardware Haven](https://www.youtube.com/@HardwareHaven):
	- [My Proxmox Home Server Walk-Through: Part 1 (TrueNAS, Portainer, Wireguard)](https://youtu.be/_sfddZHhOj4?si=npz5eQg5WoUHei9h)
	- [Remote Gaming and Streaming w/ Proxmox - Proxmox Walk-Through: Part 2](https://youtu.be/BoMlfk397h0?si=Lvn0k8-7iZsCifQg)
- From [TechHut](https://www.youtube.com/@TechHut):
	- [setting up my NEW Home Server - Full Walkthrough Guide Pt.1 (Proxmox, RAID, Cockpit, Shares)](https://youtu.be/zLFB6ulC0Fg?si=0ccGNSDZo7KRJOls)
	- [my NEW Proxmox Media Server - Full Walkthrough Guide Pt.2 (Jellyfin, Sonarr, Gluetun, and MORE)](https://youtu.be/Uzqf0qlcQlo?si=8mn_1dmtY-VHYIos)
	- Also: [What's on my Home Server?? MUST HAVE Services!](https://youtu.be/yUyxJr2xboI?si=9_YlE1GedXk7igta)
- [Docker Compose will BLOW your MIND!! (a tutorial)](https://youtu.be/DM65_JyGxCo?si=jhwo3ZdgoNYFociC) from [NetworkChuck](https://www.youtube.com/@NetworkChuck)
- Some repositories:
	- https://github.com/awesome-selfhosted/awesome-selfhosted
	- https://github.com/docker/awesome-compose
