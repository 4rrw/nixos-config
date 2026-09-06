{ pkgs, ... }:
{
  home.packages = [ pkgs.lazygit ];

  # Placed as a file rather than via `programs.lazygit.settings` so the config
  # stays verbatim -- note `{{filename}}` is lazygit's own placeholder and must
  # not be run through Nix string interpolation.
  xdg.configFile."lazygit/config.yml".source = ./config.yml;
}
