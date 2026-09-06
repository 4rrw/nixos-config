{ config, ... }:
let
  repoLink = import ../repo-link.nix { inherit config; };
  link = name: repoLink "hypr/files/${name}";
in
{
  # Symlinked to the live repo (see repo-link.nix), so editing a .lua file takes
  # effect on `hyprctl reload`. Linked file by file because noctalia writes
  # noctalia.lua into the same directory and a directory link would evict it.
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

  # Called from autostart.lua on konkuter; the 755 comes from the repo file itself.
  home.file."bin/hyprland-randomize-gaps.sh" = link "hyprland-randomize-gaps.sh";
}
