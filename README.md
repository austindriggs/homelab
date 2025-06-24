# Austin's Homelab

My apartment-lab documentation. The inital goal was to self-host all of the terabyte of pictures and videos that my parents have taken over the last few decades, but has grown into a file-backup NAS, home automation system, movie and show library, and more!


## SUMMARY

Click the name in the "SERVICE" column to go to its user guide.

### DEBIAN SERVICES

| STATUS | SERVICE                  | DESCRIPTION                                                                                      | LOCATION                                             |
| ------ | ------------------------ | ------------------------------------------------------------------------------------------------ | ---------------------------------------------------- |
| x      | SSH                      | SSH over local network                                                                           | 127.16.58.224                                        |
| x      | Docker                   | Used to install apps                                                                             | `docker ps`                                          |
| x      | mdadm                    | Used for software RAID1 to mirror my two hard drives                                             | `sudo mdadm --detail /dev/md0` or `cat /proc/mdstat` |
| x      | [Tailscale](#tailscale)  | Mesh VPN to connect                                                                              | 100.126.109.100                                      |
| x      | Samba                    | Network share for `/mnt/raid1`                                                                   | `smb://driggs-zb/raid1/`                             |


### DOCKER APPS

| STATUS | SERVICE                 | DESCRIPTION                          | PORT |
| ------ | ----------------------- | ------------------------------------ | ---- |
| x      | Portainer               | Managing docker apps                 | 8097 |
| x      | Glance                  | Homepage to monitor and link to apps | 8080 |
| x      | Syncthing               | Sync files between devices           | 8057 |
|        | Immich                  | Photo library for me                 | 8013 |
|        | Immich Frame            | Digital picture frame for me         | 8014 |
| x      | [Immich](#immich)       | Photo library for my parents         | 8094 |
| x      | Immich Frame            | Digital picture frame for my parents | 8019 |
| x      | [Jellyfin](#jellyfin)   | Video library for me and my parents  | 8074 |
|        | Jellystat               | Video library statistics             | 8075 |


## USER GUIDES

### Tailscale

**[`^ back to top ^`](#summary)**

Setup:
1. Download the Tailscale app from the app store. Allow any VPN access that Tailscale needs in your phone's settings.
2. Sign in via google account (either mine, mom's, or the guest gmail account).
3. When asked to "select a tailnet", select MY EMAIL, no matter which one you just signed in wit
4. For any more documentation notes, see [./driggs-zb/debian/](./driggs-zb/debian/README.md#tailscale).


### IMMICH

**[`^ back to top ^`](#summary)**

Setup:
1. Verify you are connected to [Tailscale](#tailscale) (follow the guide above if not).
2. Download the Immich app from the app store. Alternatively, you can type the URL below into a browser.
3. Enter `http://driggs-zb:8019` for the URL (not HTTPS).
4. Sign in using your regular email address and the password I've given you. The only emails you'll ever get are directly from me.
5. Setup any user settings, but do not choose to backup any photos to Immich. You should continue to back up to Google Photos and a regular hard drive.
6. For any more documentation notes, see [./driggs-zb/docker/immich/](./driggs-zb/docker/immich/README.md).


### JELLYFIN

**[`^ back to top ^`](#summary)**

Setup:
1. Verify you are connected to [Tailscale](#tailscale) (follow the guide above if not).
2. Download the Jellyfin app from the app store (not Swiftfin). Alternatively, you can type the URL below into a browser if you don't want to download the app.
3. Enter `http://driggs-zb:8074` for the URL (not HTTPS).
4. Sign in with your username and password that I've given you. You can configure any settings you want.
5. For any more documentation notes, see [./driggs-zb/docker/jellyfin/](./driggs-zb/docker/jellyfin/README.md)

Downloading Movies for Offline Use:
1. To download movies from the Jellyfin app or website, you need to be on a laptop or tablet, as far as I know this doesn't work on an iPhone.
2. Navigate to the movie you want to download.
3. Select the three dots and press download.


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
