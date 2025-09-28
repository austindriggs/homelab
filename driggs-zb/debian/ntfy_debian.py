#!/usr/bin/env python3

import subprocess
import requests
import sys

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

def check_raid(frequency):
    status = subprocess.run(
        ["mdadm", "--detail", "/dev/md0"],
        capture_output=True, text=True, check=True
    ).stdout

    for line in status.splitlines():
        if line.strip().startswith("Failed Devices :"):
            failed = int(line.split(":")[1].strip())

            if failed > 0: send_ntfy(f"!!! RAID FAILED DEVICES = {failed} !!!", status, 5)
            elif  frequency == "daily" or frequency == "weekly": send_ntfy(f"Raid check passed! (failed devices = {failed}", status, 3)
            else: return

if __name__ == "__main__":
    frequency = sys.argv[1]
    check_raid(frequency)
