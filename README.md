# pi-hotspot
#### setup a raspberry pi as a wifi repeater-ish hospot


## install 
- isc-dhcp-server
- hostapd
- unionfs-fuse

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
  - in /etc/defaults/hostapd set DAEMON_CONF="/etc/hostapd/hostapd.conf"
  - use the hostapd.conf and set your ssid correctly
  - put your shared key in /etc/hostapd/hostapd.wpa_psk
- isc-dhcp-server
  - copy this dhcp.conf to /etc/dhcp
  - dhcp server will listen on 172.16.1.1 to change that edit /etc/defaults/isc-dhcp-server
- /etc/network/interfaces
  - copy the interfaces file to /etc/network/interfaces
  - NOTE: there is a bug in this one where wlan1 does not start
- union-fusefor read only fs  
  - copy the fstab to /etc/fstab
  - use the mount_unionfs here in /usr/local/bin
  - add this to your fstab
    ```
      tmpfs            /tmp            tmpfs   defaults,noatime,nosuid,nodev,noexec,mode=1777,size=64M 
    ```
- ip forwarding
  - sysctl -w net.ipv4.ip_forward=1
  - sysctl -p /etc/sysctl.conf
  - iptables forwarding setup 
    - copy the iptables script to /etc/network/if-up.d/iptables
    - chmod +x /etc/network/if-up.d/iptables
  - you may need to do the following
    - echo "1" > /proc/sys/net/ipv4/conf/wlan0/forwarding
    - echo "1" > /proc/sys/net/ipv4/conf/wlan1/forwarding  
