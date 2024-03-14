#! /bin/bash
# Setup routing tables with NAT for clients on the 192.168.0.1 network
# change internet NIC from wlx347de440b832 as required (eg wlan0)
# change internal Network NIC enp0s25 (eg eth0)
sudo ifconfig enp0s25 down
sudo ifconfig enp0s25 up
sudo ifconfig enp0s25 192.168.0.1
sudo systemctl restart isc-dhcp-server
EXT_DEV=wlx347de440b832
INT_DEV=enp0s25

iptables -t nat --flush 

iptables -t nat -A POSTROUTING -o $EXT_DEV -j MASQUERADE

iptables --flush
iptables -A FORWARD -s 192.168.0.0/24 -p tcp --match multiport --dport 53,80,443 -j ACCEPT
iptables -A FORWARD -s 192.168.0.0/24 -p udp --dport 53 -j ACCEPT

iptables -A FORWARD -i $EXT_DEV -o $INT_DEV -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -D FORWARD -s 192.168.0.0/24 -p all -j DROP

iptables -t nat -v -L POSTROUTING --line-number
echo ""
echo ""
iptables -L -v

ip6tables -A INPUT  -p all -j DROP
ip6tables -A FORWARD  -p all -j DROP
ip6tables -A OUTPUT  -p all -j DROP
ip6tables -L
sudo systemctl restart tftpd-hpa.service 
