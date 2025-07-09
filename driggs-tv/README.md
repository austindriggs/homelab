# Driggs TV

## INTRO

Raspberry Pi 4B 1GB TV box used mainly to play Jellyfin, but I also want to be able to play YouTube and cast my phone to it.

I used [Android 13 For Raspberry Pi 4 Is GOOD! And Even Better with Play Store!](https://youtu.be/reuH6NEk6B4?si=kR3TDAIlZ2KviYnp) by [Novaspirit Tech](https://www.youtube.com/@NovaspiritTech) as a setup guide.


## ANDROID TV SETUP

### ANDROID INSTALL

1. Navigate to [KonstaKANG.com](https://konstakang.com/devices/) for your specific device. 
2. Download the latest Android TV image. I ended up going with [LineageOS 22.2 Android TV (Android 15)](https://konstakang.com/devices/rpi4/LineageOS22-ATV/).
3. Write the image to the SD card using the Raspberry Pi Imager.
4. Use GParted to reallocate the partition to use the entire SD card space.

### DOWNLOAD GAPPS

1. https://sourceforge.net/projects/litegapps/files/
2. https://www.apkmirror.com/apk/evozi/device-id/device-id-1-3-2-release/device-id-1-3-2-android-apk-download/?redirected=thank_you_invalid_nonce
3. transfer these downloads to the SD card?

### CONFIGURE SETTINGS

1. Go to settings and then system,
2. Change the audio device to HDMI.
3. Change any other settings.
4. Connect USB controller. 
5. Reboot.

### INSTALL GAPPS

1. Install -> Install -> SD Card -> select gapps-arm64-whatever
2. Don't reboot yet. Home -> Wipe -> swipe for factory reset
3. Open files -> SD Card -> com.evozi-device-id-whatever and install it
4. get your Google Service Framework (GSF) and insert it into www.google.com/android/uncertified
5. this could take 5-10 minutes, or 24 hours if its your first time
6. go back into your android and reboot it.
7. Netfix and some others may not appear right away. They may never appear and you might need magix to hide root. I've also heard of widevine

##  


