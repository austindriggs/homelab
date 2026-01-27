#!/usr/bin/env python3

import subprocess
import requests
import sys
from time import sleep

NTFY_URL = "http://driggs-zb:8047"
NTFY_TOPIC = "debian"

def send_ntfy(title, message, priority, tags=None, click=None, delay=None):
    headers = {
        "Title": title,
        "Priority": str(priority),
    }

    if tags: headers["Tags"] = tags
    if click: headers["Click"] = click
    if delay: headers["Delay"] = delay

    requests.post(
        f"{NTFY_URL}/{NTFY_TOPIC}",
        data=message.encode("utf-8"),
        headers=headers
    )

def check_raid():
    status = subprocess.run(
        ["mdadm", "--detail", "/dev/md0"],
        capture_output=True, text=True, check=True
    ).stdout

    for line in status.splitlines():
        if line.strip().startswith("Failed Devices :"):
            failed = int(line.split(":")[1].strip())

            if failed > 0: send_ntfy(f"!!! RAID FAILED DEVICES = {failed} !!!", status, 5)
            else: send_ntfy(f"Raid check passed!", status, 3)

def check_storage():
    storage = subprocess.run(
        ["df", "-h", "-x", "overlay", "-x", "tmpfs"],
        capture_output=True, text=True, check=True
    ).stdout
    result = "unknown"

    for line in storage.splitlines():
        if line.strip().startswith("/dev/mmcblk0p2"):
            parts = line.split()
            result = parts[4]
            break

    send_ntfy(f"Storage check: {result}.", storage, 2)

if __name__ == "__main__":
    check_raid()
    sleep(1)
    check_storage()
