#!/usr/bin/env python3

import sys
import subprocess
import os
import time
from datetime import datetime

NTFY_URL = "http://driggs-zb:8047/sys"

CONFIGS = {
    "jellyfin": {
        "mount_point": "/mnt/vulcan",
        "src": "/mnt/raid1/Jellyfin/",
        "excludes": [
            "backup_jf.txt",
            "backup_jf.log",
            "Shows/"
        ],
        "txt_name": "backup_jf.txt",
        "log_name": "backup_jf.log",
    },

    "nas": {
        "mount_point": "/mnt/tgroup",
        "src": "/mnt/raid1/",
        "excludes": [
            "backup_zb.txt",
            "backup_zb.log",
            "Jellyfin/"
        ],
        "txt_name": "backup_zb.txt",
        "log_name": "backup_zb.log",
    },
}

def run(cmd, check=True):
    print(f"+ {' '.join(cmd)}")
    return subprocess.run(cmd, check=check)

def ensure_dir(path):
    if not os.path.exists(path):
        run(["sudo", "mkdir", "-p", path])

def mount_disk(dev, mount_point):
    ensure_dir(mount_point)
    run(["sudo", "mount", "-t", "ext4", f"/dev/{dev}", mount_point])
    result = subprocess.run(["mountpoint", "-q", mount_point])
    if result.returncode != 0:
        ntfy_send(f"ERROR: Failed to mount /dev/{dev}")
        print(f"ERROR: Failed to mount /dev/{dev}")
        sys.exit(1)

def unmount(mount_point):
    run(["sudo", "umount", mount_point])

def ntfy_send(message):
    subprocess.run(["ntfy", "send", NTFY_URL, message])

def parse_rsync_summary(lines):
    """Extract quantitative metrics from rsync output summary."""
    files_transferred = 0
    bytes_transferred = 0

    for line in lines:
        if "Number of files transferred:" in line:
            files_transferred = int(line.split(":")[1].strip())
        if "Total transferred file size:" in line:
            bytes_transferred = int(line.split(":")[1].strip())

    return files_transferred, bytes_transferred

def perform_backup(mode, dev):
    if mode not in CONFIGS:
        print("Mode must be: jellyfin | nas")
        sys.exit(1)

    cfg = CONFIGS[mode]
    mount_point = cfg["mount_point"]
    src = cfg["src"]
    dst = mount_point + "/"
    log_path = os.path.join(mount_point, cfg["log_name"])
    txt_path = os.path.join(mount_point, cfg["txt_name"])

    mount_disk(dev, mount_point)

    # Build rsync command
    rsync_cmd = ["rsync", "-av", "--info=progress2", "--partial", "--update", "--delete"]
    for ex in cfg["excludes"]:
        rsync_cmd.append(f"--exclude={ex}")
    rsync_cmd += [src, dst]

    print("\nStarting rsync...")

    start_time = time.time()
    summary_lines = []

    with open(log_path, "a") as log_file:
        proc = subprocess.Popen(rsync_cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)

        for line in proc.stdout:
            print(line, end="")
            log_file.write(line)

            # Capture only summary-like lines
            if "Number of files transferred:" in line or "Total transferred file size:" in line:
                summary_lines.append(line)

        proc.wait()

    duration = int(time.time() - start_time)

    if proc.returncode != 0:
        ntfy_send(f"Backup FAILED: {mode}\nExit code: {proc.returncode}")
        unmount(mount_point)
        print("rsync failed")
        sys.exit(1)

    # Parse rsync summary numbers
    files_xfer, bytes_xfer = parse_rsync_summary(summary_lines)

    # Write report file
    with open(txt_path, "w") as f:
        f.write(f"Last updated on {datetime.now().strftime('%Y-%m-%d at %H:%M:%S')}\n\n")

        if mode == "jellyfin":
            f.write("Skipped Shows directory:\n\n")
            subprocess.run(["tree", os.path.join(src, "Shows")], stdout=f)
        else:
            f.write("Backed up directories:\n\n")
            subprocess.run(["ls", "-1", src], stdout=f)

    # Send ntfy success notification
    ntfy_send(
        f"Backup complete: {mode}\n"
        f"Duration: {duration} sec\n"
        f"Files transferred: {files_xfer}\n"
        f"Data transferred: {bytes_xfer / 1e9:.2f} GB"
    )

    unmount(mount_point)
    print("\nBackup complete.")

def main():
    if len(sys.argv) != 3:
        print("Usage:\n  ./offsite.py <jellyfin|nas> <sdX1>")
        sys.exit(1)

    mode = sys.argv[1].lower()
    dev = sys.argv[2].lower()

    perform_backup(mode, dev)

if __name__ == "__main__":
    main()
