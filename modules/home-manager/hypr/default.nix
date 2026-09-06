{ config, ... }:
let
  repoLink = import ../repo-link.nix { inherit config; };
  link = name: repoLink "hypr/files/${name}";
in
{
  # Symlinked out of the store to the live repo (see repo-link.nix), so editing
  # a .lua file takes effect on `hyprctl reload` with no rebuild. Every hypr
  # config file is linked, so a missing repo leaves hyprland with none at all.
  #
  # Everything hyprland-related lives in the .lua files, including the
  # per-host branches (they read /etc/hostname via helpers.hostname()).
  #
  # Files are placed one by one on purpose. ~/.config/hypr also holds
  # noctalia.lua, which noctalia writes and home-manager must not own -- a
  # recursive directory link would evict it.
  xdg.configFile = {
    "hypr/autostart.lua" = link "autostart.lua";
    "hypr/bindings.lua" = link "bindings.lua";
    "hypr/helpers.lua" = link "helpers.lua";
    "hypr/hyprland.lua" = link "hyprland.lua";
    "hypr/hyprsunset.conf" = link "hyprsunset.conf";
    "hypr/input.lua" = link "input.lua";
    "hypr/looknfeel.lua" = link "looknfeel.lua";
    "hypr/monitors.lua" = link "monitors.lua";
    "hypr/tiling.lua" = link "tiling.lua";
    "hypr/windows.lua" = link "windows.lua";
    "hypr/xdph.conf" = link "xdph.conf";
  };

  # Called from autostart.lua on konkuter. Executability comes from the repo
  # file's own mode (755), since the link just points at it.
  home.file."bin/hyprland-randomize-gaps.sh" = link "hyprland-randomize-gaps.sh";
}
