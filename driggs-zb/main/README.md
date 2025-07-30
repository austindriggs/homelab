# Docker Apps

This is my main stack.

## Glance

Edit the `/data/compose/6/config/glance.yml` file and then restart the container.


## Syncthing

Some research: [Syncthing Made EASY](https://youtu.be/PSx-BkMOPF4?si=3N8Xlk3vasuUtd6A) by [Tech Craft](https://www.youtube.com/@tech_craft).

I found a setup at [linuxserver/docker-syncthing](https://github.com/linuxserver/docker-syncthing) on GitHub and changed it to fit me.

Reset the password and link to my PC. Then share from my PC with the following settings: PC is send only; NAS is receive only. The only exception is sharing `spotify-local` Music from my NAS to my PC.

I sync the following (cleaned up) directories between my PC and my NAS:
```bash
driggs@driggs-zb:/mnt/raid1$ tree -d
.
├── Autodesk
├── Documents
│   ├── Excel
|   ├── Personal 
│   └── PowerPoint
├── KiCad
├── LTspice
├── Media
│   ├── Pictures
│   └── Videos
├── Obsidian
├── Sandbox
├── Screenshots
└── VSCodium
```

Most of these are also backed up in the cloud as well (Pictures to Google Photos, Videos to YouTube, KiCAD Obsidian and VSCodium projects to GitHub).

Just for reference, the directories that aren't synced are:
```
driggs@driggs-zb:/mnt/raid1$ tree -d
.
├── Immich
│   ├── imgs
|   ├── imgs-parents
|   ├── uploads
│   └── uploads-parents
└── Jellyfin
    ├── Books
    ├── Movies
    ├── Music
    ├── Shows
    └── Videos 
```

Everything on the NAS is backed up monthly to an external SSD.


## ntfy

:TODO:


## Uptime Kuma


From [louislam/uptime-kuma](https://github.com/louislam/uptime-kuma/blob/master/compose.yaml).

:TODO:
