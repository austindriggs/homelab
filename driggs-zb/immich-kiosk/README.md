# Immich Kiosk

For my parents. See the [immich-kiosk](https://github.com/damongolding/immich-kiosk) GitHub repo for more info.


## CONFIG

I created the environment variables using their [Installation](https://docs.immichkiosk.app/configuration/#docker-composeyaml-with-env) for Docker Compose with the options shown in [Configuration](https://docs.immichkiosk.app/configuration/#docker-composeyaml-with-env) (with env).

I chose to delete all unused/default variables, and to store my API key in a `stack.env` that is ignored in my repo. The initial setup was:
```yaml
version: "3.8"

services:
  immich-kiosk:
    image: ghcr.io/damongolding/immich-kiosk:latest
    container_name: immich-kiosk
    environment:
      LANG: "en_US"
      TZ: "America/New_York"
      # Required settings
      KIOSK_IMMICH_URL: "http://172.16.58.224:8019"
      # Kiosk behaviour
      KIOSK_REFRESH: 15
      # UI
      KIOSK_HIDE_CURSOR: true
      KIOSK_THEME: fade
      # Transistion options
      KIOSK_TRANSITION: none
      # Image metadata
      KIOSK_SHOW_IMAGE_DATE: true
      KIOSK_IMAGE_DATE_FORMAT: YYYY-MM-DD
      KIOSK_SHOW_IMAGE_LOCATION: true
    env_file:
      - stack.env # KIOSK_IMMICH_API_KEY
    ports:
      - 8014:3000
    restart: always
```

## USE CASE

I then use any device to navigate to `http://driggs-zb:8014` and am greeted with a slideshow of all of my pictures from Immich.

To get a specific album, use the `ALBUM_ID` from `http://driggs-zb:8019/albums/ALBUM_ID` in the Immich URL in the Immich Kiosk URL:
```
http://driggs-zb:8014/image?album=ALBUM_ID
```

For more options, see the [Image Endpoint](https://docs.immichkiosk.app/misc/image/) docs.
