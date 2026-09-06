# Everything the screenshot key needs: the tools, the script and the bindings.
# Swapping in a different mechanism means editing this directory and nothing
# else -- the only outside reference is `require("hypr.screenshot")` in
# hyprland.lua.

{ config, pkgs, ... }:
let
  repoLink = import ../repo-link.nix { inherit config; };
  link = name: repoLink "screenshot/files/${name}";
in
{
  # useUserPackages is off, so these land in ~/.nix-profile/bin, which is on the
  # compositor's PATH -- the same way SUPER+RETURN already finds ghostty.
  home.packages = with pkgs; [
    grim # capture
    slurp # region selection
    hyprpicker # freezes the screen while selecting, and the colour picker
    satty # annotation
    wl-clipboard
    libnotify # notify-send; nothing else in this config pulls it in
    jq
  ];

  # Bindings and the satty window rule; read by hyprland.lua, alongside the
  # files the hypr module links.
  xdg.configFile."hypr/screenshot.lua" = link "bindings.lua";

  # The 755 comes from the repo file itself, since the link just points at it.
  home.file."bin/screenshot.sh" = link "screenshot.sh";
}
