# Austin's Homelab

![OS: Debian](https://img.shields.io/badge/OS-Debian-A81D33?style=flat&logo=debian&logoColor=white)
![Hardware: ZimaBlade](https://img.shields.io/badge/Hardware-ZimaBlade_7700-black?style=flat)
![Container: Docker](https://img.shields.io/badge/Runtime-Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Storage: RAID1](https://img.shields.io/badge/Storage-mdadm_RAID1-orange?style=flat)
![Network: Tailscale](https://img.shields.io/badge/Network-Tailscale-short?style=flat&logo=tailscale&logoColor=white&color=5A5858)
![Immich](https://img.shields.io/badge/Photos-Immich-80D8FF?style=flat&logo=immich&logoColor=white)
![Jellyfin](https://img.shields.io/badge/Media-Jellyfin-00A4DC?style=flat&logo=jellyfin&logoColor=white)

The initial goal of my homelab was to self-host terabytes of family pictures and videos collected over the last few decades, but has grown into a file-backup NAS, home automation system, media library, and more!

The primary server is the [ZimaBlade 7700](./driggs-zb/README.md) (NAS Kit) running Debian with Docker containers for most applications.


## SUMMARY

Click the name in the "SERVICE" column to go to its user guide.

### DEBIAN SERVICES

| STATUS | SERVICE                  | DESCRIPTION                                          | LOCATION                                             |
| ------ | ------------------------ | ---------------------------------------------------- | ---------------------------------------------------- |
| x      | SSH                      | SSH over local network                               | ~~172.16.58.224~~ 10.3.1.131                         |
| x      | Docker                   | Used to install apps                                 | `docker ps`                                          |
| x      | mdadm                    | Used for software RAID1 to mirror my two hard drives | `sudo mdadm --detail /dev/md0` or `cat /proc/mdstat` |
| x      | [Tailscale](#tailscale)  | Mesh VPN to connect                                  | 100.126.109.100                                      |
| x      | Samba                    | Network share for `/mnt/raid1`                       | `smb://driggs-zb/raid1/`                             |


### DOCKER APPS

| STATUS | SERVICE                       | DESCRIPTION                          | PORT | NTFY TOPIC |
| ------ | ----------------------------- | ------------------------------------ | ---- | ---------- |
| x      | Portainer                     | Managing docker apps                 | 8097 | main       |
| x      | Glance                        | Homepage to monitor and link to apps | 8080 | main       |
| x      | Syncthing                     | Sync files between devices           | 8057 | main       |
| x      | [ntfy](#ntfy)                 | Pub-sub notification service         | 8047 | main       |
|        | Immich                        | Photo library for me                 | 8013 | Immich     |
| x      | [Immich](#immich)             | Photo library for my parents         | 8019 | Immich     |
| x      | [Immich Kiosk](#immich-kiosk) | Digital picture frame                | 8014 | Immich     |
| x      | [Jellyfin](#jellyfin)         | Video library for me and my parents  | 8074 | Jellyfin   |
| x      | Jellyseer                     | Video library requests and status    | 8075 | Jellyfin   |
|        | Jellystat                     | Video library statistics             | 8076 | Jellyfin   |


## USER GUIDES

### TAILSCALE

**[`^ back to top ^`](#summary)**

Setup:
1. Download the Tailscale app from the app store. Allow any VPN access that Tailscale needs in your phone's settings.
2. Sign in via google account (either mine, mom's, or the guest gmail account).
3. When asked to "select a tailnet", select MY EMAIL, no matter which one you just signed in with.
4. For any more documentation notes, see [./driggs-zb/debian/](./driggs-zb/debian/README.md#tailscale).


### NTFY

**[`^ back to top ^`](#summary)**

Setup:
1. Verify you are connected to [Tailscale](#tailscale) (follow the guide above if not).
2. Download the ntfy app from the app store. Alternatively, you can type the URL below into a browser.
3. Enter `http://driggs-zb:8047` for the URL in the settings section (not HTTPS).
4. Subscribe to apps you are using by entering the app name as the topic (see the `NTFY TOPIC` column in the table above).
6. For any more documentation notes, see [./driggs-zb/main/](./driggs-zb/main/README.md#ntfy).


### IMMICH

**[`^ back to top ^`](#summary)**

Setup:
1. Verify you are connected to [Tailscale](#tailscale) (follow the guide above if not).
2. Download the Immich app from the app store. Alternatively, you can type the URL below into a browser.
3. Enter `http://driggs-zb:8019` for the URL (not HTTPS).
4. Sign in using your regular email address and the password I've given you. The only emails you'll ever get are directly from me.
5. Setup any user settings, but do not choose to backup any photos to Immich. You should continue to back up to Google Photos and a regular hard drive.
6. For any more documentation notes, see [./driggs-zb/immich/](./driggs-zb/immich/README.md).


### IMMICH KIOSK

**[`^ back to top ^`](#summary)**

Setup:
1. Verify you are connected to [Tailscale](#tailscale) (follow the guide above if not).
2. Download the Immich Kiosk app from the app store, Alternatively, you can type the URL below into a browser.
3. Enter `http://driggs-zb:8014` for the URL (not HTTPS).
4. For any more documentation notes or URL options, see [driggs-kiosk/](driggs-kiosk/) or [./driggs-zb/immich-kiosk/](./driggs-zb/immich-kiosk/).



### JELLYFIN

**[`^ back to top ^`](#summary)**

Setup:
1. Verify you are connected to [Tailscale](#tailscale) (follow the guide above if not).
2. Download the Jellyfin app from the app store (not Swiftfin). Alternatively, you can type the URL below into a browser if you don't want to download the app.
3. Enter `http://driggs-zb:8074` for the URL (not HTTPS).
4. Sign in with your username and password that I've given you. You can configure any settings you want.
5. For any more documentation notes, see [./driggs-zb/jellyfin/](./driggs-zb/jellyfin/README.md)

Jellyseer:
1. Verify you are connected to [Tailscale](#tailscale) (follow the guide above if not).
2. Download the Jellyseer app from the app store. Alternatively, you can type the URL below into a browser if you don't want to download the app.
3. Enter `http://driggs-zb:8074` for the URL (not HTTPS) if you are prompted to do so.
4. Sign in with your same Jellyfin username and password that I've given you. You can configure any settings you want.
5. For any more documentation notes, see [./driggs-zb/jellyfin/](./driggs-zb/jellyfin/README.md)

Notifications:
1. If you want to enable notifications for this app, you need to install and setup [ntfy](#ntfy) above and subscribe to the `Jellyfin` topic.
2. Most notifications for the Jellyfin app are automatically sent by Jellyseer, although you don't need to download and setup Jellyseer to get notifications.
3. When you make a request, when media gets approved (or denied if its unavailable), or when media is added, a notification be sent through ntfy.
4. Other notifications will come from scripts that I've wrote. For any more documentation notes, see [./driggs-zb/jellyfin/](./driggs-zb/jellyfin/README.md)

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
- I've learned a lot about networking and this is one of the best intro videos that covers a bunch of different topics: [Everything I Learned About Home Networking - A Newbie’s Perspective](https://youtu.be/DT2ARc1NOpM?si=a5K2GU-9xXWb3N7d) by [Jimmy Tries World](https://www.youtube.com/@JimmyTriesWorld) on YouTube.
