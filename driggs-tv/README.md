# Driggs TV

I run Android TV on a Raspberri Pi 4 4GB because I really only use my TV to watch YouTube or movies on Jellyfin.


## ANDROID TV

### SETUP

Download:
- [LineageOS 22.2 Android TV - KonstaKANG (Android 15)](https://konstakang.com/devices/rpi4/) image for your device.
[MindTheGapps-15.0.0-arm64-ATV](https://github.com/MindTheGapps/15.0.0-arm64-ATV/releases) for the same Android version.

Flash the image to an SD card. Move the app store to a USB drive. Plug both into the Pi, connect to a monitor and keyboard, and power up.

Configure some settings:
1. Connect to the internet.
2. Settings -> System -> Buttons: enable "Advanced restart"
3. Settings -> System -> Raspberry Pi settings: set "Audio device" to HDMI0
4. Settings -> System -> Power and Energy -> Restart: Recovery


## APP STORE

### INSTALL GOOGLE PLAY

Install the Google Play store:
1. Mount -> USB -> Select Storage -> USB: then go back using the bottom left arrow
2. Install -> MindTheGapps-15.0.0-arm64-ATV -> Slide
3. Reboot -> System
4. It may take a minute. You may need to power cycle the Pi.
5. Settings -> Accounts and Profiles: sign in with your gmail account.


### DEFAULT APPS

I installed all of the apps I want:
1. [Tailscale](../README.md#tailscale)
2. [Jellyfin](../README.md#tailscale)
3. YouTube
4. [Immich TV](../README.md#immich)


### DRM

Some providers (Netflix, Prime, Hulu) control access to copyrighted materials through Digital Rights Management (DRM). They are not able to be installed until I am a trusted device.

This could be a future task, but I have no need for it right now.



## RESOURCES

- [How to install Android TV 15 on the Raspberry Pi 4 and use it as a media player.](https://youtu.be/BSId-9miAFM?si=XnWe60x4E0w3dme2) by [Virtually Walking](https://www.youtube.com/@virtuallywalking).
