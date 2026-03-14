# Homelab Roadmap

## WORKING

### Jellyfin

- [ ] restructure the naming conventions of library files: https://jellyfin.org/docs/general/server/media/movies. `It (1990) - imdbid-tt0099864` in [[ZimaBlade NAS - Jellyfin]] - the bear tt14452776, Warrier 2011 tt1291584, ~~Captain America - The Winter Solder (2014)~~ get different winter soldier because of volume
- [ ] music through jellyfin in case i ever quit spotify one day: zotify, tuneif. Also: https://github.com/advplyr/audiobookshelf. Would need to clean up spotify beforehand



## BACKLOG

### Surveillance System: 

frigate surveillance through USB camera (also see homeassistant): 
- https://github.com/TechHutTV/homelab/blob/main/surveillance/compose.yaml frigate
- https://www.youtube.com/watch?v=CouxmNqxO4A&list=PLgikNYcILLY_F-vNurQSuUcYadVRjLH0u&index=91 through contaware
- https://github.com/bluenviron/mediamtx?tab=readme-ov-file#by-device mediamtx
- Motioneye
- https://github.com/Motion-Project/motion


### Actual Budget

learn a budgeting software: 
- From [Awesome Docker Compose](https://awesome-docker-compose.com/apps/budgeting/actual-budget): Actual is a local-first personal finance tool based on zero-sum budgeting. It supports synchronization across devices, custom rules, manual transaction importing (from QIF, OFX, and QFX files), and optional automatic synchronization with many banks.
- https://firefly-iii.org/
- ghostfolio


actual-budget.yml:
```yaml
version: '3.9'
services:
  actual_server:
    image: actualbudget/actual-server:latest
    ports:
      - 8048:5006
    volumes:
      - /mnt/raid1/ActualBudget:/data
    restart: unless-stopped
```


### OliveTin

https://www.olivetin.app/: give safe and simple access to predefined shell commands from a web interface


### HomeAssistant

smart home stuff: 
- freezer temp sensor
- thermostat upgrade 
- Reolink 2K WiFi doorbell ($110): compatability with Home assistant, 24/7 recording to an SD card or (Reolink branded?) NVR, HDR, no monthly fees. Eufy has no HDR and is more expensive!
- ~~Tapo C120 indoor camera ($25): no fees, 24/7 recording to an SD card, lots of alert types (baby crying)~~ you don't own it?
- Reolink RLC-810A outdoor camera ($80): some attachments may not integrate with Home Assistant
- Honeywell X2S thermostat ($100)
- ecobee essential thermostat ($130) 


### paperless-ngx/paperless-ngx

A community-supported supercharged version of paperless: scan, index and archive all your physical documents
