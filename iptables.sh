#! /binsh

# WIP - goal is to make a script that can be used for the firewall on this access point 

#set -x 

ACCESS_POINT_IFACE=wlan0
PUBLIC_IFACE=wlan1

# short hand 
LAN_IFACE=$ACCESS_POINT_IFACE
WAN_IFACE=$PUBLIC_IFACE
# flush all rules
iptables -t nat -F 
iptables -t mangle -F 
iptables -F 
iptables -X 
ip6tables -t nat -F
ip6tables -t mangle -F
ip6tables -F
ip6tables -X

# default polices
# enable these when you have everything else working 
iptables -P INPUT DROP
iptables -P FORWARD DROP
# iptables -P OUTPUT ACCEPT

# enable ssh so you can talk to the pi :) 
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# enable anything on the internal interface, because it should be secured by wpa key
iptables -A INPUT -i $LAN_IFACE -j ACCEPT

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
iptables -A INPUT -i $LAN_IFACE -p udp --dport 67 -j ACCEPT
iptables -A INPUT -i $LAN_IFACE -p udp --dport 68 -j ACCEPT

# garbage on my network 
iptables -A INPUT -j DROP -p udp --dport 2190
iptables -A INPUT -j DROP -p udp --dport 7788

# at last logging
iptables -A INPUT -j LOG -m limit --limit 1/min 
iptables -A INPUT -j DROP
iptables -A FORWARD -j LOG -m limit --limit 1/min 
iptables -A FORWARD -j DROP

# save rules 
# /sbin/service iptables save
