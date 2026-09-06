{ pkgs, ... }:
{
  home.packages = [ pkgs.lazygit ];

  # Placed verbatim rather than via `programs.lazygit.settings`, since
  # `{{filename}}` is lazygit's placeholder and must not hit Nix interpolation.
  xdg.configFile."lazygit/config.yml".source = ./config.yml;
}
