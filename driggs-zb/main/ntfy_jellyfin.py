#!/usr/bin/env python3

import subprocess
import requests
import sys

NTFY_URL = "http://driggs-zb:8047"
NTFY_TOPIC = "Jellyfin"

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

if __name__ == "__main__":
    type = sys.argv[1]
    message = sys.argv[2]

    if type == "dev": send_ntfy("This is a test:", message, 1)
    elif type == "update": send_ntfy(f"Update to Jellyfin:", message, 3)
    elif type == "new_media": send_ntfy(f"New media added to Jellyfin!", message, 2)
