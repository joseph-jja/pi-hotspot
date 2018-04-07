#! /binsh

# WIP - goal is to make a script that can be used for the firewall on this access point 

ACCESS_POINT_IFACE=wlan0
PUBLIC_IFACE=wlan1

# short hand 
LAN_IFACE=$ACCESS_POINT_INTERFACE
WAN_IFACE=$PUBLIC_INTERFACE
# flush all rules
iptables -F 
ip6tables -F

# enable ssh so you can talk to the pi :) 
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# default polices
# enable these when you have everything else working 
# iptables -P INPUT DROP
# iptables -P FORWARD DROP
# iptables -P OUTPUT ACCEPT

# loopback 
iptables -A INPUT -i lo -j ACCEPT

# accept established or 'related' connections 
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# forward packets between interfaces
iptables -A FORWARD -i $LAN_IFACE -j ACCEPT
#iptables -A FORWARD -i $LAN_IFACE -o $WAN_IFACE -j ACCEPT
iptables -A FORWARD -o $LAN_IFACE -j ACCEPT
#iptables -A FORWARD -i $WAN_IFACE -o $LAN_IFACE -j ACCEPT

# need nat too
iptables -t nat -A POSTROUTING -o $WAN_IFACE -j MASQUERADE

# so for an access point we need to enable dhcpd ports 
#iptables -A INPUT -i $API -p udp --dport 67 -j ACCEPT
#iptables -A INPUT -i $API -p udp --dport 68 -j ACCEPT

# save rules 
# /sbin/service iptables save
