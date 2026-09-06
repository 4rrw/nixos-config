# Idle handling: lock after 5 minutes, screen off after 7. hypridle is only the
# timer -- the lock screen itself is noctalia's.

{ config, pkgs, ... }:
let
  repoLink = import ../repo-link.nix { inherit config; };
in
{
  home.packages = [ pkgs.hypridle ];

  # Started from autostart.lua rather than services.hypridle, so it does not
  # depend on which of the two hyprland session entries was used to log in.
  xdg.configFile."hypr/hypridle.conf" = repoLink "idle/files/hypridle.conf";
}
