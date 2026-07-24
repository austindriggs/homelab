# ==============================================================================
# Local Network & DHCP Server Setup
# Topology:
#   - capo (Raspberry Pi 4B): 10.0.0.127 (eth0)
#   - driggs-zb (Homelab):    10.0.0.126 (Static DHCP)
#   - thopter (Laptop):       Dynamic DHCP range (10.0.0.150 - 10.0.0.250)
# ==============================================================================

# Reference: 
# - [Using a Raspberry Pi to hide from my ISP](https://youtu.be/w8_IBJLNo04)
# - [Anti-ISP Raspberry Pi Router](https://spencersdesk.com/projects/anti-isp-raspberry-pi-router)
#

# ------------------------------------------------------------------------------
# 1. Configure Static IP on capo's Ethernet Interface (eth0)
# ------------------------------------------------------------------------------

# From thopter:
ssh driggs@capo.local

# Check available devices and connection profiles
nmcli device status
nmcli con

# Set static IP 10.0.0.127/24 on the Ethernet connection profile
sudo nmcli con mod "netplan-eth0" ipv4.addresses 10.0.0.127/24 ipv4.method manual

# Bring the updated Ethernet interface up
sudo nmcli con up "netplan-eth0"

# Verify the interface has the assigned IP
ip addr
# Expected output on eth0:
# 2: eth0: ... inet 10.0.0.127/24 brd 10.0.0.255 scope global noprefixroute eth0

# ------------------------------------------------------------------------------
# 2. Package Updates & Install dnsmasq
# ------------------------------------------------------------------------------
sudo apt update -y
sudo apt upgrade -y
sudo apt install dnsmasq -y

# Backup the default dnsmasq configuration file
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

# ------------------------------------------------------------------------------
# 3. Create Custom /etc/dnsmasq.conf
# ------------------------------------------------------------------------------
# Create/edit /etc/dnsmasq.conf with:
#   sudo nano /etc/dnsmasq.conf

cat << 'EOF' | sudo tee /etc/dnsmasq.conf
# Listen only on eth0 (your private LAN)
interface=eth0

# Don't listen on the Wi-Fi uplink
except-interface=wlan0

# Static DHCP Reservation (Homelab)
dhcp-host=aa:bb:cc:dd:ee:ff,driggs-zb,10.0.0.126,infinite

# Dynamic DHCP Range (10.0.0.150 - 10.0.0.250)
dhcp-range=10.0.0.150,10.0.0.250,24h

# Do not advertise a default gateway (prevents clients from losing internet)
dhcp-option=3

# Set DNS to this Pi's eth0 address
dhcp-option=6,10.0.0.127
EOF

# ------------------------------------------------------------------------------
# 4. Enable and Restart dnsmasq Service
# ------------------------------------------------------------------------------
sudo systemctl restart dnsmasq
sudo systemctl enable dnsmasq

# ------------------------------------------------------------------------------
# 5. Network Verification & Troubleshooting Commands
# ------------------------------------------------------------------------------
# View active DHCP leases handed out by dnsmasq
cat /var/lib/misc/dnsmasq.leases
# Expected output:
# 0 aa:bb:cc:dd:ee:ff 10.0.0.126 driggs-zb ...
# <timestamp> <laptop_mac> 10.0.0.158 thopter ...

# Inspect ARP cache to verify active connectivity on the switch
sudo ip neighbor
# Expected output:
# 10.0.0.126 dev eth0 lladdr aa:bb:cc:dd:ee:ff REACHABLE
# 10.0.0.158 dev eth0 lladdr <laptop_mac> REACHABLE

# If a device hangs on an old IP (e.g., FAILED state), flush the neighbor entry:
# sudo ip neighbor del 10.0.0.236 dev eth0

# Verify connectivity to homelab
ping -c 3 10.0.0.126

