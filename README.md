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
- isc-dhcp-server
- /etc/network/interfaces
  - copy the dhcp.conf to /etc/dhcp 
- union-fuse  
  - use the fstab here
  - use the mount_unionfs here in /usr/local/bin
- ip forwarding
  - sysctl -w net.ipv4.ip_forward=1
  - sysctl -p /etc/sysctl.conf
  - iptables forwarding setup 
    - copy the iptables script to /etc/network/if-up.d/iptables
    - chmod +x /etc/network/if-up.d/iptables
  - you may need to do the following
    - echo "1" > /proc/sys/net/ipv4/conf/wlan0/forwarding
    - echo "1" > /proc/sys/net/ipv4/conf/wlan1/forwarding  
- make read only 
  - add this to your fstab
    ```
      tmpfs            /tmp            tmpfs   defaults,noatime,nosuid,nodev,noexec,mode=1777,size=64M 
    ```
