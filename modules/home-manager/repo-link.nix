# Symlinks a config out of the nix store to the live repo, so edits take effect
# without a rebuild. The link resolves outside nix's control, so the repo has to
# exist at this path or the config is simply missing.
#
# Takes a path relative to modules/home-manager.

{ config }:

relativePath: {
  source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/.config/nixos/modules/home-manager/${relativePath}";
}
