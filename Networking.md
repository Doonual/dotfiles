To connect to networks you will need to...
 - Install "networkmanager"
 - Start the "NetworkManager.service" service

To be able to resolve hostnames like homeassistant.local, you need to
  - Make sure the "systemd-resolved.service" service is running
  - Install "nss-mdns"
  - Install "avahi"
  - Start the "avahi-daemon.service" service

Good luck, this should work (hopefully)
