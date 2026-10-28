# Home Assistant

## SETUP

### ZIGBEE DONGLE

SONOFF Zigbee 3.0 USB Dongle Plus MG24 (Dongle-PMG24) from Amazon.

To link in docker, run:
```bash
ls -l /dev/serial/by-id/
```

### INITIAL DOCKER COMPOSE

```yaml
version: '3.8'

services:
  homeassistant:
    container_name: homeassistant
    image: ghcr.io/home-assistant/home-assistant:stable
    volumes:
      - /docker/homeassistant:/config
      - /etc/localtime:/etc/localtime:ro
      - /run/dbus:/run/dbus:ro
    restart: always
    privileged: true
    network_mode: host
    devices:
      - /dev/serial/by-id/usb-SONOFF_SONOFF_Dongle_Plus_MG24_f4cf5a0f1c8cf011922a2ab9d9065118-if00-port0:/dev/ttyUSB0
```

Without host networking, automatic network discovery (mDNS/UPnP) for local smart devices (like HomeKit, Chromecast, LIFX, or certain local IP cameras) will not auto-discover across your subnet unless you manually configure router mDNS reflection or add IP addresses directly into HA integrations. (Zigbee via your USB dongle will still work fine either way.)


### INITIAL CONFIG

```yaml
http:
  server_port: 8044
```

### THIRDREALITY ZL1

1. Add a device in HA.
2. Start with the bulb on.
3. Switch off -> on 5 times.

### GOVEE RBIC LED CORNER FLOOR LAMP BASIC 

1. Open the Govee app.
2. Enable LAN Control.
3. Add a local Govee device in HA.

