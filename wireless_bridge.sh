#!/usr/bin/env bash
WIRELESS=wlx347de440b832
ETHERNET=enp0s25

set -e

[ $EUID -ne 0 ] && echo "run as root" >&2 && exit 1

apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -y \
    dnsmasq netfilter-persistent iptables-persistent

# Create and persist iptables rule.
iptables -t nat -A POSTROUTING -o WIRELESS -j MASQUERADE
netfilter-persistent save

# Enable ipv4 forwarding.
sed -i'' s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/ /etc/sysctl.conf

# The Ethernet adapter will use a static IP of 192.168.0.1 on this new subnet.
cat <<'EOF' >/etc/systemd/network/enp0s25
auto enp0s25
allow-hotplug enp0s25
iface enp0s25 inet static
  address 192.168.0.1
  netmask 255.255.255.0
  gateway 192.168.0.1
EOF

# Create a dnsmasq DHCP config at /etc/dnsmasq.d/bridge.conf. The server
# will act as a DHCP server to the client connected over ethernet.
cat <<'EOF' >/etc/dnsmasq.d/bridge.conf
interface=enp0s25
bind-interfaces
server=8.8.8.8
domain-needed
bogus-priv
dhcp-range=192.168.0.2,192.168.0.254,12h
EOF

systemctl mask networking.service
