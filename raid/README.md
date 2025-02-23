# HDDs and RAID Setup

I bought refurbed (enterprise grade) 12TB drives from eBay because they were $7/TB with a one year warranty (could be up to 5 years, but I don't completely trust them).

Specs:
> HGST Ultrastar DC HC520 HDD | HUH721212ALE601 | 12TB 7200RPM SATA 6Gb/s 256MB Cache 3.5-Inch | ISE 512e | Helium Data Center Internal Hard Disk Drive


## INTRODUCTION

This is a lengthy note including every command I ran to get RAID setup.


## SMART Tests

First downloaded:
```bash
sudo apt update
sudo apt install smartmontools e2fsprogs
```

Had to find the storage location:
```bash
casaos@casaos:~$ lsblk
NAME         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda            8:0    0 10.9T  0 disk 
└─sda1         8:1    0 10.9T  0 part /mnt/Storage1
sdb            8:16   0 10.9T  0 disk 
└─sdb1         8:17   0 10.9T  0 part /mnt/Storage2
mmcblk0      179:0    0 29.1G  0 disk 
├─mmcblk0p1  179:1    0  512M  0 part /boot/efi
├─mmcblk0p2  179:2    0 26.7G  0 part /
└─mmcblk0p3  179:3    0  1.9G  0 part [SWAP]
mmcblk0boot0 179:256  0    4M  1 disk 
mmcblk0boot1 179:512  0    4M  1 disk 
```


### Analysis of sda

Performed smart test on one of them:
```bash
casaos@casaos:~$ sudo smartctl -a /dev/sda
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-25-amd64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     HUH721212ALE601
Serial Number:    8DJ85WGH
LU WWN Device Id: 5 000cca 253dfe812
Firmware Version: LEGL0002
User Capacity:    12,000,138,625,024 bytes [12.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Dec  9 17:18:05 2024 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever 
                                        been run.
Total time to complete Offline 
data collection:                (   87) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine 
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        (   1) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   100   100   016    Pre-fail  Always       -       0
  2 Throughput_Performance  0x0005   133   133   054    Pre-fail  Offline      -       92
  3 Spin_Up_Time            0x0007   158   158   024    Pre-fail  Always       -       419 (Average 414)
  4 Start_Stop_Count        0x0012   100   100   000    Old_age   Always       -       116
  5 Reallocated_Sector_Ct   0x0033   100   100   005    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000b   100   100   067    Pre-fail  Always       -       0
  8 Seek_Time_Performance   0x0005   140   140   020    Pre-fail  Offline      -       15
  9 Power_On_Hours          0x0012   095   095   000    Old_age   Always       -       36069
 10 Spin_Retry_Count        0x0013   100   100   060    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       24
 22 Unknown_Attribute       0x0023   100   100   025    Pre-fail  Always       -       100
 45 Unknown_Attribute       0x0023   100   100   001    Pre-fail  Always       -       1095233372415
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       573
193 Load_Cycle_Count        0x0012   100   100   000    Old_age   Always       -       573
194 Temperature_Celsius     0x0002   139   139   000    Old_age   Always       -       43 (Min/Max 18/55)
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0022   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0008   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x000a   200   200   000    Old_age   Always       -       0
231 Temperature_Celsius     0x0032   100   100   000    Old_age   Always       -       0
241 Total_LBAs_Written      0x0012   100   100   000    Old_age   Always       -       3467072875582
242 Total_LBAs_Read         0x0012   100   100   000    Old_age   Always       -       5927779867126

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     36067         -
# 2  Vendor (0x70)       Completed without error       00%     35801         -
# 3  Vendor (0x71)       Completed without error       00%     35801         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.
```

I've heard that the reallocated sectors is one of the biggest signs of failure, so this is good. 36,069 hours is 4.1174658, which is actually under the 5 years stated in the eBay listing. We'll see if these pay off in the long run :)

### Analysis of sdb

```bash
casaos@casaos:~$ sudo smartctl -t short /dev/sdb
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-25-amd64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF OFFLINE IMMEDIATE AND SELF-TEST SECTION ===
Sending command: "Execute SMART Short self-test routine immediately in off-line mode".
Drive command "Execute SMART Short self-test routine immediately in off-line mode" successful.
Testing has begun.
Please wait 1 minutes for test to complete.
Test will complete after Mon Dec  9 17:37:20 2024 EST
Use smartctl -X to abort test.
casaos@casaos:~$ sudo smartctl -a /dev/sdb
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-25-amd64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     HUH721212ALE601
Serial Number:    8DJGV7TH
LU WWN Device Id: 5 000cca 253e2eebf
Firmware Version: LEGL0002
User Capacity:    12,000,138,625,024 bytes [12.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Dec  9 17:38:20 2024 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever 
                                        been run.
Total time to complete Offline 
data collection:                (   87) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine 
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        (   1) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   100   100   016    Pre-fail  Always       -       0
  2 Throughput_Performance  0x0005   132   132   054    Pre-fail  Offline      -       96
  3 Spin_Up_Time            0x0007   158   158   024    Pre-fail  Always       -       415 (Average 418)
  4 Start_Stop_Count        0x0012   100   100   000    Old_age   Always       -       66
  5 Reallocated_Sector_Ct   0x0033   100   100   005    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000b   100   100   067    Pre-fail  Always       -       0
  8 Seek_Time_Performance   0x0005   140   140   020    Pre-fail  Offline      -       15
  9 Power_On_Hours          0x0012   095   095   000    Old_age   Always       -       36189
 10 Spin_Retry_Count        0x0013   100   100   060    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       13
 22 Unknown_Attribute       0x0023   100   100   025    Pre-fail  Always       -       100
 45 Unknown_Attribute       0x0023   100   100   001    Pre-fail  Always       -       1095233372415
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       510
193 Load_Cycle_Count        0x0012   100   100   000    Old_age   Always       -       510
194 Temperature_Celsius     0x0002   136   136   000    Old_age   Always       -       44 (Min/Max 19/56)
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0022   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0008   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x000a   200   200   000    Old_age   Always       -       0
231 Temperature_Celsius     0x0032   100   100   000    Old_age   Always       -       0
241 Total_LBAs_Written      0x0012   100   100   000    Old_age   Always       -       3448165219716
242 Total_LBAs_Read         0x0012   100   100   000    Old_age   Always       -       6045434215544

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     36189         -
# 2  Short offline       Completed without error       00%     36186         -
# 3  Vendor (0x70)       Completed without error       00%     36034         -
# 4  Vendor (0x71)       Completed without error       00%     36034         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

casaos@casaos:~$
```



## RAID

I (way too recently) learned that you can just install RAID software via the terminal, because CasaOS is built on top of Ubuntu, it isn't it's own thing. Because of this, I can follow any old tutorial for RAID (specifically mirroring) on an Ubuntu machine/server. 

> [!danger]
> This wipes the disk(s) completely, so make sure everything is backed up, and that you are selecting the correct disks.


### Multiple Disk And Device Management (mdadm)

From [Wikipedia](https://en.wikipedia.org/wiki/Mdadm):
> **mdadm** is a [Linux](https://en.wikipedia.org/wiki/Linux "Linux") utility used to manage and monitor [software RAID](https://en.wikipedia.org/wiki/Software_RAID "Software RAID") devices. It is used in modern [Linux distributions](https://en.wikipedia.org/wiki/Linux_distribution "Linux distribution") in place of older software RAID utilities such as [raidtools2](https://en.wikipedia.org/w/index.php?title=Raidtools2&action=edit&redlink=1 "Raidtools2 (page does not exist)") or [raidtools](https://en.wikipedia.org/w/index.php?title=Raidtools&action=edit&redlink=1 "Raidtools (page does not exist)").

I heard of it on Reddit, but liked this video [Create RAID 1 volume in Ubuntu Linux & Recover a mirrored volume in Ubuntu](https://youtu.be/j_y25HkWSOs?si=cWx78KxmkdyF_VFW) by [Knowledge Sharing Tech](https://www.youtube.com/@KnowledgeSharingTech).
- The video states "Install 2 identical HD in PC" as the first step, mine happen to be identical, but I'm not sure what "identical" means: same make/manufacturer? or just the same size? Could be a future issue.


### Install mdadm

Install mdadm (press Y if prompted):
```bash
sudo apt install mdadm
```

Probably should've done this first:
```bash
sudo apt update && sudo apt upgrade
```

### Create Linux Raid Auto Partition on Each Hard Drive

Find the disks. Mine are actually at `/mnt/Storage1` and `/mnt/Storage2`), but I need the raw device path (the `/dev/sda` and `/dev/sdb`) so that `fdisk` and RAID creation commands will work properly. To find your locations, you could try:
```bash
casaos@casaos:~$ lsblk
NAME         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda            8:0    0 10.9T  0 disk 
└─sda1         8:1    0 10.9T  0 part /mnt/Storage2
sdb            8:16   0 10.9T  0 disk 
└─sdb1         8:17   0 10.9T  0 part /mnt/Storage1
mmcblk0      179:0    0 29.1G  0 disk 
├─mmcblk0p1  179:1    0  512M  0 part /boot/efi
├─mmcblk0p2  179:2    0 26.7G  0 part /
└─mmcblk0p3  179:3    0  1.9G  0 part [SWAP]
mmcblk0boot0 179:256  0    4M  1 disk 
mmcblk0boot1 179:512  0    4M  1 disk 
```

Configure RAID partition:
```bash
casaos@casaos:~$ sudo fdisk /dev/sda

Welcome to fdisk (util-linux 2.36.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): 
```

From the tutorial:
> Enter the following options:
> - Type `n` for new.
> - What is the partition we want to create? Type `p` for primary. 
> - Press enter again to default the partition number to `1`. 
> - Press enter again to default the First sector to `2048`. 
> - Press enter again to default the last sector.
> 
> It created a new partition 1 of type 'Linux'. We want to change this partiton:
> - Enter `t`.
> - Type `L` to list all types of partitions.
> - We want "Linux raid auto", which is `fd` in hex.

I actually want to change this. The partition should now be changed to `19` or `raid`, and we need to write it to the drive so enter `w`:
```bash
Command (m for help): w 
The partition table has been altered.
Syncing disks.
```

STOP: Configure RAID partition for `sudo fdisk /dev/sdb` by following the steps above:
```bash
casaos@casaos:~$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.36.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): t
Selected partition 1
Partition type or alias (type L to list all): raid
Changed type of partition 'Linux filesystem' to 'Linux RAID'.

Command (m for help): w
The partition table has been altered.
Syncing disks.
```

Both drives should be partitioned as Linux RAID auto.

### Create and Mount Partition on RAID 1 Volume

Create the RAID 1 volume (enter `y` if prompted):
```bash
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1
```

My drives were already mounted so I need to unmount them and then try again:
```bash
casaos@casaos:~$ sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1
mdadm: cannot open /dev/sda1: Device or resource busy
casaos@casaos:~$ mount | grep /dev/sd
/dev/sda1 on /mnt/Storage2 type ext4 (rw,noatime)
/dev/sdb1 on /mnt/Storage1 type ext4 (rw,noatime)
casaos@casaos:~$ sudo umount /mnt/Storage2
sudo umount /mnt/Storage1
casaos@casaos:~$ mount | grep /dev/sd
casaos@casaos:~$ 
```

I also needed to clear the file systems on both partitions:
```bash
some stuff missed
sudo reboot
I think I had to pause my syncthing stuff
```

You should now be able to see the RAID volume in the disks:
```bash
lsblk ?????
```

---

To check on the status:
```bash
watch -n 15 cat /proc/mdstat



Every 15.0s: cat /proc/mdstat                   casaos: Tue Jan 21 17:25:59 2025

Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [ra
id10]
md127 : active raid1 sdb1[1] sda1[0]
      11718751232 blocks super 1.2 [2/2] [UU]
      [===================>.]  resync = 99.5% (11665279936/11718751232) finish=7
.4min speed=119938K/sec
      bitmap: 2/88 pages [8KB], 65536KB chunk

unused devices: <none>
```

When it's done:
```bash
driggs@casaos:~$ cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [raid10] 
md127 : active raid1 sdb1[1] sda1[0]
      11718751232 blocks super 1.2 [2/2] [UU]
      bitmap: 0/88 pages [0KB], 65536KB chunk

unused devices: <none>
```

Checking drives:
```bash
driggs@casaos:~$ lsblk
NAME         MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda            8:0    0 10.9T  0 disk  
└─sda1         8:1    0 10.9T  0 part  
  └─md127      9:127  0 10.9T  0 raid1 
sdb            8:16   0 10.9T  0 disk  
└─sdb1         8:17   0 10.9T  0 part  
  └─md127      9:127  0 10.9T  0 raid1 
mmcblk0      179:0    0 29.1G  0 disk  
├─mmcblk0p1  179:1    0  512M  0 part  /boot/efi
├─mmcblk0p2  179:2    0 26.7G  0 part  /
└─mmcblk0p3  179:3    0  1.9G  0 part  [SWAP]
mmcblk0boot0 179:256  0    4M  1 disk  
mmcblk0boot1 179:512  0    4M  1 disk  
driggs@casaos:~$
```

Check the status:
```bash
driggs@casaos:~$ sudo mdadm --detail /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Mon Jan 20 21:16:59 2025
        Raid Level : raid1
        Array Size : 11718751232 (11175.87 GiB 12000.00 GB)
     Used Dev Size : 11718751232 (11175.87 GiB 12000.00 GB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Tue Jan 21 17:33:46 2025
             State : clean 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : bitmap

              Name : casaos:0  (local to host casaos)
              UUID : 94418f33:ad6532de:99cd9d3e:a7919caa
            Events : 14673

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
driggs@casaos:~$
```


Format and mount this RAID volume as you would a normal drive: I think just use the GUI to format and then mount the "drive". You could also try formatting by running the command:
```bash
driggs@casaos:~$ sudo mkfs.ext4 /dev/md127
mke2fs 1.46.2 (28-Feb-2021)
Creating filesystem with 2929687808 4k blocks and 366211072 inodes
Filesystem UUID: a65cbb63-9e2e-46e4-b0c4-c1cec3582f31
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
	102400000, 214990848, 512000000, 550731776, 644972544, 1934917632, 
	2560000000

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: done
```

Then mount it:
```bash
sudo mount /dev/md127 /mnt/raid1
```

Verify the mount:
```bash
driggs@casaos:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            3.8G     0  3.8G   0% /dev
tmpfs           779M  2.6M  777M   1% /run
/dev/mmcblk0p2   27G   16G  9.3G  63% /
tmpfs           3.9G     0  3.9G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/mmcblk0p1  511M  5.9M  506M   2% /boot/efi
tmpfs           779M     0  779M   0% /run/user/1001
/dev/md127       11T   28K   11T   1% /mnt/raid1
driggs@casaos:~$
```

After it's mounted, check the mirror status of the devices:
```bash
driggs@casaos:~$ sudo mdadm --detail /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Mon Jan 20 21:16:59 2025
        Raid Level : raid1
        Array Size : 11718751232 (11175.87 GiB 12000.00 GB)
     Used Dev Size : 11718751232 (11175.87 GiB 12000.00 GB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Tue Jan 21 17:44:07 2025
             State : active 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : bitmap

              Name : casaos:0  (local to host casaos)
              UUID : 94418f33:ad6532de:99cd9d3e:a7919caa
            Events : 14674

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
```


This didn't work, even after rebooting, and it was because the raid array or something was read-only:
```bash
driggs@casaos:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            3.8G     0  3.8G   0% /dev
tmpfs           779M  2.6M  777M   1% /run
/dev/mmcblk0p2   27G   16G  9.3G  63% /
tmpfs           3.9G     0  3.9G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/mmcblk0p1  511M  5.9M  506M   2% /boot/efi
tmpfs           779M     0  779M   0% /run/user/1001
driggs@casaos:~$ cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [raid10] 
md127 : active (auto-read-only) raid1 sdb1[1] sda1[0]
      11718751232 blocks super 1.2 [2/2] [UU]
      bitmap: 0/88 pages [0KB], 65536KB chunk

unused devices: <none>
```

To fix this, we can:
```bash
driggs@casaos:~$ sudo mdadm --readwrite /dev/md127
driggs@casaos:~$ cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [raid10] 
md127 : active raid1 sdb1[1] sda1[0]
      11718751232 blocks super 1.2 [2/2] [UU]
      bitmap: 0/88 pages [0KB], 65536KB chunk

unused devices: <none>
driggs@casaos:~$ sudo mount /dev/md127 /mnt/raid1
driggs@casaos:~$ sudo nano /etc/fstab
driggs@casaos:~$ sudo mount -a
driggs@casaos:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            3.8G     0  3.8G   0% /dev
tmpfs           779M  2.6M  777M   1% /run
/dev/mmcblk0p2   27G   16G  9.3G  63% /
tmpfs           3.9G     0  3.9G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/mmcblk0p1  511M  5.9M  506M   2% /boot/efi
tmpfs           779M     0  779M   0% /run/user/1001
/dev/md127       11T   28K   11T   1% /mnt/raid1
driggs@casaos:~$
```

It still seemed like this wasn't working, I don't know how to add it to the files app like the drives were before, so I just set up a network share:
1. Allow to share the raid1 folder in CasaOS file explorer GUI.
2. Go to "Shared" at the bottom left.
3. Copy the path `smb://172.16.58.209/raid1`
4. Paste into "Server Address" in Ubuntu file explorer's Other Locations.
5. I signed into my driggs user and set to remember the password forever so I don't have to come back and do all this again.


Some light verification, drives are using the same amount of storage:
```bash
driggs@casaos:~$ ls -lh /mnt/raid1
total 20K
drwxrwxrwx 2 root   root   4.0K Jan 20 22:05 'Creed III (2023)'
drwx------ 2 driggs driggs  16K Jan 21 17:40  lost+found
driggs@casaos:~$ sudo mdadm --detail /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Mon Jan 20 21:16:59 2025
        Raid Level : raid1
        Array Size : 11718751232 (11175.87 GiB 12000.00 GB)
     Used Dev Size : 11718751232 (11175.87 GiB 12000.00 GB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Tue Jan 21 18:23:11 2025
             State : clean 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : bitmap

              Name : casaos:0  (local to host casaos)
              UUID : 94418f33:ad6532de:99cd9d3e:a7919caa
            Events : 14682

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
driggs@casaos:~$ df -h /mnt/sda
df: /mnt/sda: No such file or directory
driggs@casaos:~$ df -h /dev/sda
Filesystem      Size  Used Avail Use% Mounted on
udev            3.8G     0  3.8G   0% /dev
driggs@casaos:~$ df -h /dev/sdb
Filesystem      Size  Used Avail Use% Mounted on
udev            3.8G     0  3.8G   0% /dev
```


## HARD DRIVE FAILURE

What happens when one fails?


### From the Tutorial

#### Simulating Hard Drive Failure

If we add files to the hard drives and then remove one of the hard drives, checking the mirror status again should reveal that we only have 1 working device.

#### Recovering RAID Volume After Hard Drive Failure

First, add the new hard drive to the machine.

Then you need to initialize it:
```bash
sudo fdisk /dev/sdc
```

Repeat the steps above:
- Type `n` for new.
- What is the partition we want to create? Type `p` for primary. 
- Press enter again to default the partition number to `1`. 
- Press enter again to default the First sector to `2048`. 
- Press enter again to default the last sector.

It created a new partition 1 of type 'Linux'. We want to change this partiton:
- Enter `t`.
- Type `L` to list all types of partitions.
- We want "Linux raid auto", which is `fd` in hex.

The partition should now be changed, and we need to write it to the drive so enter `w`. 

Now we need to inform mdadm to add the new drive to the current RAID volume:
```bash
sudo mdadm --manage /dev/md0 --add /dev/sdc1
```

Check the details again:
```bash
sudo mdadm --detail /dev/md0
```

Should say there are 2 RAID devices, with a rebuild status at the bottom.

You can also monitor the rebuild process using:
```bash
watch cat /proc/mdstat
```

#### Additional Considerations

- **RAID 1 rebuild process**: When a new disk is added after a failure, the data on the remaining good disk is copied to the new disk to mirror it. Depending on the amount of data and disk speed, this can take a long time, so keep an eye on the status.
- **Automatic RAID rebuild**: In most cases, `mdadm` will automatically start rebuilding the array once a new disk is added, but it's worth explicitly stating that users should monitor the rebuild process and verify that it completes.
- **Backup**: It’s always good to remind users to maintain proper backups of important data, even when using RAID. RAID can protect against hardware failures, but it won't prevent data loss from other causes, like accidental deletion or corruption.


### My Efforts

I disconnected one of the data cables:
```bash
driggs@casaos:~$ cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [raid10] 
md127 : active raid1 sda1[0]
      11718751232 blocks super 1.2 [2/1] [U_]
      bitmap: 2/88 pages [8KB], 65536KB chunk

unused devices: <none>
driggs@casaos:~$ sudo mdadm --detail /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Mon Jan 20 21:16:59 2025
        Raid Level : raid1
        Array Size : 11718751232 (11175.87 GiB 12000.00 GB)
     Used Dev Size : 11718751232 (11175.87 GiB 12000.00 GB)
      Raid Devices : 2
     Total Devices : 1
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Tue Jan 21 18:39:41 2025
             State : active, degraded 
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : bitmap

              Name : casaos:0  (local to host casaos)
              UUID : 94418f33:ad6532de:99cd9d3e:a7919caa
            Events : 14891

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       -       0        0        1      removed
driggs@casaos:~$ df -h /dev/sda
Filesystem      Size  Used Avail Use% Mounted on
udev            3.8G     0  3.8G   0% /dev
driggs@casaos:~$ df -h /dev/sdb
df: /dev/sdb: No such file or directory
```

I plugged it back in and it rebuilt successfully without doing anything (other than a reboot):
```bash
driggs@casaos:~$ df -h /dev/sdb
Filesystem      Size  Used Avail Use% Mounted on
udev            3.8G     0  3.8G   0% /dev
driggs@casaos:~$ sudo mdadm --detail /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Mon Jan 20 21:16:59 2025
        Raid Level : raid1
        Array Size : 11718751232 (11175.87 GiB 12000.00 GB)
     Used Dev Size : 11718751232 (11175.87 GiB 12000.00 GB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Tue Jan 21 18:44:06 2025
             State : clean 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : bitmap

              Name : casaos:0  (local to host casaos)
              UUID : 94418f33:ad6532de:99cd9d3e:a7919caa
            Events : 15416

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
driggs@casaos:~$ ls -lh /mnt/raid1
total 20K
drwxrwxrwx 2 root   root   4.0K Jan 20 22:05 'Creed III (2023)'
drwx------ 2 driggs driggs  16K Jan 21 17:40  lost+found
driggs@casaos:~$ cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [raid10] 
md127 : active raid1 sdb1[1] sda1[0]
      11718751232 blocks super 1.2 [2/2] [UU]
      bitmap: 2/88 pages [8KB], 65536KB chunk

unused devices: <none>
```


## FUTURE

### Preventing Failures

Obviously the first step is the 3-2-1 backup method, I'm working on it.


### Detecting Failures

TODO

