# Helper for configs that are symlinked out of the nix store to the live repo,
# so editing one takes effect without a rebuild and the file stays plain
# app-native config that a non-NixOS machine could use as-is.
#
# The trade-off is the same everywhere it is used: these links resolve outside
# nix's control, so the repo must exist at the path below or the config is
# simply missing. Reserve it for files an app reads as-is; anything that needs
# Nix to compute it (store paths, generated values) belongs in a real
# `programs.*` option or a store-copied `.source` instead.
#
# Takes a path relative to modules/home-manager. A module linking several files
# binds its own shorthand:
#
#   { config, ... }:
#   let
#     repoLink = import ../repo-link.nix { inherit config; };
#     link = name: repoLink "hypr/files/${name}";
#   in
#   { xdg.configFile."hypr/monitors.lua" = link "monitors.lua"; }

{ config }:

relativePath: {
  source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/.config/nixos/modules/home-manager/${relativePath}";
}
