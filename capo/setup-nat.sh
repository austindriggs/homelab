# ==============================================================================
# NAT Gateway & IP Forwarding Setup
# Topology:
#   - capo (Raspberry Pi 4B): 10.0.0.127 (eth0 / LAN), 192.168.68.53 (wlan0 / WAN)
#   - driggs-zb (Homelab):    10.0.0.126 (eth0 / LAN)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Enable IPv4 Kernel Forwarding on capo
# ------------------------------------------------------------------------------

# Enable IPv4 packet forwarding in runtime
sudo sysctl -w net.ipv4.ip_forward=1

# Make packet forwarding persistent across system reboots
echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/99-ipforward.conf
sudo sysctl -p /etc/sysctl.d/99-ipforward.conf

# ------------------------------------------------------------------------------
# 2. Configure NAT & Masquerade using nftables
# ------------------------------------------------------------------------------

# Create the NAT table and postrouting chain
sudo nft add table ip nat
sudo nft add chain ip nat postrouting '{ type nat hook postrouting priority 100; }'

# Add masquerade rule for outbound traffic exiting wlan0 (WAN)
sudo nft add rule ip nat postrouting oifname "wlan0" masquerade

# ------------------------------------------------------------------------------
# 3. Save nftables Ruleset & Enable Persistence
# ------------------------------------------------------------------------------

# Export active ruleset to standard nftables config location
sudo nft list ruleset | sudo tee /etc/nftables.conf

# Enable nftables systemd service to reload rules on boot
sudo systemctl enable nftables
sudo systemctl restart nftables

# ------------------------------------------------------------------------------
# 4. Client Gateway & DNS Configuration (Run on driggs-zb)
# ------------------------------------------------------------------------------

# From driggs-zb:
# Set capo (10.0.0.127) as the default gateway interface
sudo ip route replace default via 10.0.0.127 dev enp2s0

# Set fallback public DNS servers for external resolution
echo -e "nameserver 1.1.1.1\nnameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# ------------------------------------------------------------------------------
# 5. Verification & Troubleshooting Commands
# ------------------------------------------------------------------------------

# Verify active nftables ruleset on capo
sudo nft list table ip nat
# Expected output:
# table ip nat {
#     chain postrouting {
#         type nat hook postrouting priority srcnat; policy accept;
#         oifname "wlan0" masquerade
#     }
# }

# Test external IP connectivity from driggs-zb
ping -c 4 1.1.1.1

# Test DNS resolution from driggs-zb
ping -c 4 debian.org

