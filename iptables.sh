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

# loopback 
iptables -A INPUT -i lo -j ACCEPT

# enable ssh so you can talk to the pi :) 
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j LOG
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# dhcpd ports 
iptables -A INPUT ! -i lo -p udp -m multiport --dport 67,68 -j ACCEPT

# dns requests 
iptables -A INPUT ! -i lo -p tcp --dport 53 -j ACCEPT
iptables -A INPUT ! -i lo -p udp --dport 53 -j ACCEPT

# accept new connections on these interfaces
iptables -A INPUT -i $LAN_IFACE -j ACCEPT -m state --state NEW

# accept established or 'related' connections 
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# garbage on the network 
iptables -A INPUT -j DROP -p udp -m multiport --dport 2190,7788

# enable anything on the internal interface
# might not need this?
iptables -A INPUT -i $LAN_IFACE -j ACCEPT

# forward packets between interfaces
iptables -A FORWARD ! -i lo -j ACCEPT

# need nat too
iptables -t nat -A POSTROUTING -o $WAN_IFACE -j MASQUERADE

# at last logging
iptables -A INPUT -j LOG -m limit --limit 1/min 
iptables -A INPUT -j DROP
iptables -A FORWARD -j LOG -m limit --limit 1/min 
iptables -A FORWARD -j DROP

# save rules 
# /sbin/service iptables save

