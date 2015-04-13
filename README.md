


## install 
- isc-dhcp-server
- hostapd

## configure 
- wpa_suplicant
- hostapd
- isc-dhcp-server
- /etc/network/interfaces
- ip forwarding
  - sysctl -w net.ipv4.ip_forward=1
  - sysctl -p /etc/sysctl.conf

