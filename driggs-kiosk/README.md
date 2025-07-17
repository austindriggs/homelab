# Driggs Kiosk

This is a client that displays images from my Immich server and displays them onto a digital picture frame I made with a Raspberry Pi and portable monitor.

TODO_IMAGE


## HARDWARE

- [15.6 in Portable Monitor](https://www.amazon.com/dp/B0D2D8CCY1) with:
    - 1920 x 1080 resolution (16:9 aspect ratio)
    - HDMI input
    - Touchscreen
    - Built in speakers
    - 12V input
    - Looks good. A lot of them look bad.
- [12V 5A Power Supply](https://www.amazon.com/dp/B0CW2PJQLJ)
- [12V in to 5V 5A out Power Adapter]()
- [Raspberry Pi 4 1GB](https://www.canakit.com/raspberry-pi-4.html)
- HDMI to Micro HDMI cable
- Micro SD card
- Command strips
- Soldering iron and heatshrink


## OPERATING SYSTEM

Diet Pi OS is a lighter version of the Raspberry Pi OS that enables my limited Raspberry Pi Zero 2W to run significalty faster.
1. [Download for Raspberry Pi 4](https://dietpi.com/?ref=fanyangmeng.blog#downloadinfo)
2. [How to install DietPi](https://dietpi.com/docs/install/)


I changed the following lines in the [dietpi.txt](dietpi.txt) config:
```
TODO, hostname
```

Once logged in, install Chromium after running:
```
dietpi-software
```





Install Tailscale and follow the prompts after running:
```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

Finally, install unclutter so we can hide the mouse later:
```bash
sudo apt install unclutter
```


## KIOSK MODE

https://dietpi.com/docs/software/desktop/#chromium





this was extremely blurry. to fix it, disable hardware acceleration in chromium:
```bash
chromium-browser --disable-gpu
```


## MONITORING

!FUTURE!
