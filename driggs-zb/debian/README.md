# Debian Services

## Debian 12

I am installing Debian 12.9.0 from `debian-12.9.0-amd64-netinst.iso`. Hold the `F11` key.

I left the hard drives in while power cycling and installing the new distro. I also had to move monitors to even see anything, I'm not sure why.

Once I get to the Debian setup, I did all the normal things you'd do for an installation. When **partitioning disks**, I partitioned `/dev/sda` and `/dev/sdb` to be `Use as: physical volume for raid`, and `/mnt/raid1` to be `Use as: Ext4 journaling file system`. I **DID NOT** format these, as I didn't want to lose any data.

I also made sure to install the `SSH server` (see below).

Once booted into it, I needed to install sudo:
1. Install `sudo`: `apt update && apt install sudo -y`
2. Add my user to the `sudo` group: `usermod -aG sudo driggs`
3. Apply the changes:  `su - driggs`
4. Test with `sudo whoami`


## SSH

Add this:
```bash
172.16.58.224    driggs-zb
```

to `/etc/hosts` on **both** the server and client:
```bash
driggs@driggs-zb:~$ cat /etc/hosts
127.0.0.1	localhost
127.0.1.1	driggs-zb.driggs-zb.local	driggs-zb
172.16.58.224	driggs-zb

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```


## Hard Drives

My hard drives were refurbs from eBay. All of my work is stored in [a separate note](Initial HDDs and RAID Setup.md) because its really long.



## Docker

### DOCKER SETUP

Install curl:
```bash
sudo apt install curl -y
```

Install Docker:
```bash
curl -fsSL https://get.docker.com | sudo sh
```

output:
```bash
Client: Docker Engine - Community
 Version:           28.0.2
 API version:       1.48
 Go version:        go1.23.7
 Git commit:        0442a73
 Built:             Wed Mar 19 14:36:58 2025
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          28.0.2
  API version:      1.48 (minimum version 1.24)
  Go version:       go1.23.7
  Git commit:       bea4de2
  Built:            Wed Mar 19 14:36:58 2025
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.7.25
  GitCommit:        bcc810d6b9066471b0b6fa75f557a15a1cbf31bb
 runc:
  Version:          1.2.4
  GitCommit:        v1.2.4-0-g6c52b3f
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

================================================================================

To run Docker as a non-privileged user, consider setting up the
Docker daemon in rootless mode for your user:

    dockerd-rootless-setuptool.sh install

Visit https://docs.docker.com/go/rootless/ to learn about rootless mode.


To run the Docker daemon as a fully privileged service, but granting non-root
users access, refer to https://docs.docker.com/go/daemon-access/

WARNING: Access to the remote API on a privileged Docker daemon is equivalent
         to root access on the host. Refer to the 'Docker daemon attack surface'
         documentation for details: https://docs.docker.com/go/attack-surface/

================================================================================
```

Add myself to the docker group so I don't have to use `sudo` when using the docker command:
```bash
sudo usermod -aG docker driggs
```

### DOCKER MAINTENANCE

I had Syncthing go down and log:
```
WARNING: Error opening database: write /config/index-v0.14.0.db/001245.ldb: no space left on device
```

I ran `dh -h` to see that my root file system was 100% full! 
```bash
driggs@driggs-zb:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            3.8G     0  3.8G   0% /dev
tmpfs           779M  3.8M  775M   1% /run
/dev/mmcblk0p2   27G   25G     0 100% /
tmpfs           3.9G     0  3.9G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/mmcblk0p1  511M  5.9M  506M   2% /boot/efi
/dev/md0         11T  1.7T  8.7T  16% /mnt/raid1
tmpfs           779M  4.0K  779M   1% /run/user/1000
```

The easiest fix for me right now is to clean up docker. I checked:
```bash
driggs@driggs-zb:~$ docker system df
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          20        13        10.31GB   2.994GB (29%)
Containers      13        13        282.5kB   0B (0%)
Local Volumes   17        4         6.808GB   5.171GB (75%)
Build Cache     0         0         0B        0B
driggs@driggs-zb:~$ 
```

and then cleaned up the images:
```bash
docker system prune -af --volumes
```

Another option that I DID NOT DO would be to move docker stuff from my EMMC storage to my hard drives but I'd imagine that would slow things down?
```bash
sudo systemctl stop docker
sudo mv /var/lib/docker /mnt/raid1/docker
sudo ln -s /mnt/raid1/docker /var/lib/docker
sudo systemctl start docker
```

or I could get a NVMe drive and connect it through the PCIe slot on the side of my ZimaBlade.



## Portainer

From: https://docs.portainer.io/start/install-ce/server/docker/linux.

Create the volume that Portainer Server will use to store its database:
```bash
sudo docker volume create portainer_data
```

Then, download and install the Portainer Server container (note I changed the host port):
```bash
docker run -d -p 8000:8000 -p 8097:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts
```

Verify installation with `docker ps` and then navigate to `https://driggs-zb:8097`. After that, I run everything through the stacks which are each stored in this `docker` folder.



## mdadm

Install mdadm (if not already installed):
```bash
sudo apt install mdadm -y
```

Add it to my source so I can run mdadm commands:
```bash
echo 'export PATH=$PATH:/usr/sbin' >> ~/.bashrc
source ~/.bashrc
```

Detect RAID devices:
```bash
driggs@driggs-zb:~$ sudo mdadm --assemble --scan
driggs@driggs-zb:~$ cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid1 sda1[1] sdb1[0]
      11718751232 blocks super 1.2 [2/2] [UU]
      bitmap: 0/88 pages [0KB], 65536KB chunk

unused devices: <none>
```

Show details:
```bash
driggs@driggs-zb:~$ mdadm --detail /dev/md0
mdadm: must be super-user to perform this action
driggs@driggs-zb:~$ sudo !!
sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Mon Jan 20 21:16:59 2025
        Raid Level : raid1
        Array Size : 11718751232 (10.91 TiB 12.00 TB)
     Used Dev Size : 11718751232 (10.91 TiB 12.00 TB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Sat Mar 22 20:06:07 2025
             State : clean 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : bitmap

              Name : casaos:0
              UUID : 94418f33:ad6532de:99cd9d3e:a7919caa
            Events : 15494

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8        1        1      active sync   /dev/sda1
```

Check out the config:
```bash
driggs@driggs-zb:~$ cat /etc/mdadm/mdadm.conf 
# mdadm.conf
#
# !NB! Run update-initramfs -u after updating this file.
# !NB! This will ensure that initramfs has an uptodate copy.
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan, using
# wildcards if desired.
#DEVICE partitions containers

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md/0  metadata=1.2 UUID=94418f33:ad6532de:99cd9d3e:a7919caa name=casaos:0

# This configuration was auto-generated on Wed, 19 Mar 2025 19:07:12 -0400 by mkconf
```


## Tailscale

From: https://tailscale.com/download/linux/debian-bookworm.

Add Tailscale's package signing key and repository:
```shell
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
```

Install Tailscale:
```shell
sudo apt-get update
sudo apt-get install tailscale
```

Connect your machine to your Tailscale network and authenticate in your browser:
```shell
sudo tailscale up
```

You can find your Tailscale IPv4 address by running:
```shell
driggs@driggs-zb:~$ tailscale ip -4
100.92.5.73
```

If the device you added is a server or remotely-accessed device, you may want to consider [disabling key expiry](https://tailscale.com/kb/1028/key-expiry) to prevent the need to periodically re-authenticate.
```bash
I did this.
```

I also changed the Tailscale IP address to `100.126.109.101`, so my parents won't have to edit that yet.


## Samba

Install samba:
```bash
sudo apt install samba -y
```

Configure global settings:
```bash
sudo nano /etc/samba/smb.conf
```

At the very bottom under `#======================= Share Definitions =======================`, add the following:
```bash
[raid1]
    comment = my share
    path = /mnt/raid1
    browsable = yes
    Read only = no
    guest ok = no
    valid users = driggs
```

Restart the samba:
```bash
sudo systemctl restart smbd
```

Go to the root user with `sudo -s` and set the samba password for my user once prompted:
```bash
smbpasswd -a driggs
```

Exit the root user with `exit` and then install other packages so we can connect:
```bash
sudo apt install cifs-utils samba-client -y
```

Connect on my machine by going to Files -> Other Locations and adding `smb://172.16.58.224/raid1/`. Then type in my password.

Eventually I had to give myself permission to manage the files with:
```bash
sudo chown -R driggs:driggs /mnt/raid1
```

and then restart samba again:
```bash
sudo systemctl restart smbd
```

## rsync

I want to be able to plug in a USB drive and sync all the files from my NAS to it: This will give me my offsite backup for now. This can be done (pretty much on any hadrware) using rsync.

### Main Backup

I plugged in the hard drive, ran `lsblk` and `blkid` to see that it was an exfat file system. To make it ext4, I ran `sudo mkfs.ext4 /dev/sdc1`. Then I again ran `sudo blkid /dev/sdc1` and `sudo mkdir /mnt/tgroup` before adding this line to `/etc/fstab`:
```bash
UUID=dbe207b0-5d6f-4776-ab72-b47681a01a4f /mnt/tgroup ext4 defaults 0 2
```

I then mounted it with `sudo mount -a`. To backup everything except the Jellyfin directory, I ran `backup_zb.sh`:
```bash
#!/bin/bash

# Exit on error
set -e

# Variables
MOUNT_POINT="/mnt/tgroup"
SRC="/mnt/raid1/"
DST="$MOUNT_POINT/"

# Ensure mount point is valid
if ! mountpoint -q "$MOUNT_POINT"; then
	echo "$MOUNT_POINT is not mounted."
	exit 1
fi

# rsync backup
rsync -av --info=progress2 --partial --update --delete --exclude 'backup_zb.txt' --exclude 'backup_zb.log' --exclude 'Jellyfin/' "$SRC" "$DST" | tee -a "$MOUNT_POINT/backup_zb.log"

# Write updated timestamp 
echo "Last updated on $(date +"%Y-%m-%d at %H:%M:%S")" > "$MOUNT_POINT/backup_zb.txt"
echo "ZimaBlade backup is complete."

# Unmount for safety
sudo umount "$MOUNT_POINT"
echo "$MOUNT_POINT is unmounted."
```

First by making it executible with `chmod +x backup_zb.sh`. I also found I had to run `sudo chown -R driggs:driggs /mnt/tgroup` to get permissions (I also could have added `sudo` to all my commands in the script).


### Jellyfin Backup

I plugged in the hard drive, ran `lsblk` and `blkid` to see it was under `/dev/sdc1` (this drive was already ext4), then ran `sudo mkdir -p /mnt/vulcan` and then added this line to `/etc/fstab`:
```bash
UUID=0d54899d-3381-4689-9546-3a864ec754a2 /mnt/vulcan ext4 defaults 0 2
```

After adding to fstab, I ran `sudo mount -a` to mount it.

To backup Jellyfin (since this is the largest directory), I ran `backup_jf.sh`:
```bash
#!/bin/bash

# Exit on error
set -e

# Variables
MOUNT_POINT="/mnt/vulcan"
SRC="/mnt/raid1/Jellyfin/"
DST="$MOUNT_POINT/Jellyfin/"

# Ensure mount point is valid
if ! mountpoint -q "$MOUNT_POINT"; then
	echo "$MOUNT_POINT is not mounted."
	exit 1
fi

# rsync backup
rsync -av --info=progress2 --partial --update --delete --exclude 'backup_jf.txt' --exclude 'backup_jf.log' --exclude 'Shows/' "$SRC" "$DST" | tee -a "$MOUNT_POINT/backup_jf.log"

# Write updated timestamp and missed shows
{
	echo "Last updated on $(date +"%Y-%m-%d at %H:%M:%S")"
	echo
	echo "Skipped shows directory:"
	tree "$SRC/Shows"
} > "$MOUNT_POINT/backup_jf.txt"
echo "Jellyfin backup is complete."

# Unmount for safety
sudo umount "$MOUNT_POINT"
echo "$MOUNT_POINT is unmounted."
```

Note that I have chose not to backup my shows just because I don't want to allocate the space.
