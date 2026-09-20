To connect to networks you will need to...
 - Install "networkmanager"
 - Start the "NetworkManager.service" service (May not actually need this. If you have systemd-networkd)

To be reachable via hostname.local you need to
 - Install "avahi"
 - Start the "avahi-daemon.service" service

To be able to resolve hostnames like homeassistant.local, you need to
  - Make sure the "systemd-resolved.service" service is running
  - Install "nss-mdns"

Good luck, this should work (hopefully)
