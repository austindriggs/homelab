# Driggs Kiosk

This is a client that displays images from my Immich server and displays them onto a digital picture frame I made with a Raspberry Pi and portable monitor.

<a href="https://www.youtube.com/watch?v=NeSkeHkIKjA" target="_blank">
  <img src=".imgs/driggs-kiosk.JPG" alt="Driggs Kiosk Demo" width="1000" style="border:0;">
</a>

*Click the image above to be redirected to YouTube, or see [the local mp4 file](.imgs/driggs-kiosk.mp4).*


## MECHANICAL

Link to [OnShape](https://cad.onshape.com/documents?nodeId=6f4d76e23843bc47101345e0&resourceType=folder) 3D model, stored in the [mech](mech/) folder:

![mech](.imgs/driggs-kiosk-rpi4-assembly.png)


## HARDWARE

My requirements were pretty specific:
- [15.6 in Portable Monitor](https://www.amazon.com/dp/B0D2D8CCY1) with:
    - 1920 x 1080 resolution (16:9 aspect ratio)
    - HDMI input
    - Touchscreen
    - Built in speakers
    - 12V input
    - Looks good. A lot of them look bad.
- [12V 5A Power Supply](https://www.amazon.com/dp/B0CW2PJQLJ)
- [12V in to 5V 5A out Power Adapter](https://a.co/d/6XhWI92)
- [Low profile VESA monitor stand](https://www.amazon.com/dp/B0CNGJVKVQ) (with standoffs)
- [Raspberry Pi 4 1GB](https://www.canakit.com/raspberry-pi-4.html) (or similar)
- [HDMI to Micro HDMI cable](https://a.co/d/e9Usyyt) (or similar)
- [Micro SD card (16-23 GB)](https://a.co/d/67N24uo)
- Soldering iron and heatshrink

![hardware](.imgs/driggs-kiosk-back.JPG)


## SOFTWARE

Diet Pi OS is a lighter version of the Raspberry Pi OS that enables my limited Raspberry Pi Zero 2W to run significalty faster.
1. [Download for Raspberry Pi 4](https://dietpi.com/?ref=fanyangmeng.blog#downloadinfo)
2. [How to install DietPi](https://dietpi.com/docs/install/)


I edited the files stored in the [driggs-kiosk/rpi4/] folder by following the docs on [deitpi's website](https://dietpi.com/docs/software/desktop/#chromium). 

Install Tailscale and follow the prompts after running:
```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

When I booted into chromium, it was extremely blurry, so I disabled hardware acceleration in chromium:
```bash
chromium-browser --disable-gpu http://driggs-zb:8014
```

My WiFi at home is garbage. DietPi/Chromium would freeze on an image whenever it lost connection to my server. I wanted to setup some monitoring: pinging my server and if I lose connection then I either refresh the browser or reboot the pi. It turns out the solution was to simply plug an Ethernet cable directly into the router instead of connecting over WiFi.

<!-- 
## MONITORING

!FUTURE!:
- What happens when Wifi goes down? 
--->

