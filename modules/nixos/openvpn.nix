# Manual-only OpenVPN: `systemctl start/stop openvpn-krtn-1`. autoStart=false
# means it's never enabled, so it doesn't come up at boot or survive a reboot.
# The .conf itself (certs/keys) stays out of git, in /etc/openvpn.

{
  services.openvpn.servers.krtn-1 = {
    config = "config /etc/openvpn/krtn-1.conf";
    autoStart = false;
  };
}
