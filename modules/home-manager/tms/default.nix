{ config, pkgs, ... }:
let
  repoLink = import ../repo-link.nix { inherit config; };
in
{
  home.packages = [ pkgs.tmux-sessionizer ];

  xdg.configFile."tms/config.toml" = repoLink "tms/files/config.toml";
}
