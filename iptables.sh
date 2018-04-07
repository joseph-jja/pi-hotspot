#! /binsh

# WIP - goal is to make a script that can be used for the firewall on this access point 

ACCESS_POINT_IFACE=wlan0
PUBLIC_IFACE=wlan1

# short hand 
API=$ACCESS_POINT_INTERFACE
PI=$PUBLIC_INTERFACE
# flush all rules
iptables -F 

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

# save rules 
# /sbin/service iptables save

# so for an access point we need to enable dhcpd ports 
#iptables -A INPUT -i $API -p udp --dport 67 -j ACCEPT
#iptables -A INPUT -i $API -p udp --dport 68 -j ACCEPT

