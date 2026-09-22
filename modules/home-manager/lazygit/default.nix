{ pkgs, ... }:
{
  home.packages = [
    pkgs.lazygit

    # Referenced by name from config.yml, which keeps that file a plain
    # verbatim config instead of something Nix has to interpolate a store
    # path into.
    (pkgs.writeShellScriptBin "lazygit-nvim-edit" (builtins.readFile ./nvim-edit.sh))
  ];

  # Placed verbatim rather than via `programs.lazygit.settings`, since
  # `{{filename}}` is lazygit's placeholder and must not hit Nix interpolation.
  xdg.configFile."lazygit/config.yml".source = ./config.yml;
}
