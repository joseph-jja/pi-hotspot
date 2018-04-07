# pi-hotspot
#### setup a raspberry pi as a wifi repeater-ish hospot

## Currently in the process of updating this for the pi 3 B+ and raspbian stretch

## Start by following the raspberry pi documentation
https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md

## install 
- dnsmasq
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
  - use the hostapd.conf and set your ssid correctly => mostly works but needs tweaking
  - put your shared key in /etc/hostapd/hostapd.wpa_psk => seems I had to use wpa_passphrase as this might not be working?
- follow instructions for dhcp server
  - using 172.16.1.1 is a private IP address
- union-fuse for read only fs  
  - see my project pi-ro-mount
- One thing I like to do on my raspberry pi devices is to turn off swap and make tmp a tmpfs filesystem
  - add this to your fstab
    ```
      tmpfs            /tmp            tmpfs   defaults,noatime,nosuid,nodev,noexec,mode=1777,size=64M 
    ```
  - You can also do this for 
    - /var/log 
    - /var/lib/dhcp
    - /var/lib/dhcpcd5
    - /var/run
    - /var/lock
- ip forwarding
  - sysctl -w net.ipv4.ip_forward=1
  - sysctl -p /etc/sysctl.conf
  - iptables forwarding setup 
    - copy the iptables script to /etc/network/if-up.d/iptables
    - chmod +x /etc/network/if-up.d/iptables
  - you may need to do the following
    - echo "1" > /proc/sys/net/ipv4/conf/wlan0/forwarding
    - echo "1" > /proc/sys/net/ipv4/conf/wlan1/forwarding  
