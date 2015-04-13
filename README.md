# pi-hotspot
#### setup a raspberry pi as a wifi repeater-ish hospot


## install 
- isc-dhcp-server
- hostapd

## configure 
- wpa_suplicant 
  - you need to add a few lines
  ```
    network={
      ssid="the ssid of the network to connect to"
      key_mgmt=WPA-PSK
      psk="your key"
    }
  ```
- hostapd
- isc-dhcp-server
- /etc/network/interfaces
- ip forwarding
  - sysctl -w net.ipv4.ip_forward=1
  - sysctl -p /etc/sysctl.conf

