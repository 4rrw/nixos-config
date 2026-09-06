{ config, ... }:
let
  repoLink = import ../repo-link.nix { inherit config; };
in
{
  # Symlinked out of the store to the live repo (see repo-link.nix), so editing
  # the TOML takes effect via `noctalia msg config-reload` with no rebuild.
  #
  # Noctalia does watch both config layers, but whether its watcher fires for an
  # edit made through this symlink is untested -- config-reload is the reliable
  # trigger, exactly as `hyprctl reload` is for the lua files.
  #
  # Deliberately NOT using inputs.noctalia.homeModules.default. Its `settings`
  # option would render this TOML from a Nix attrset, which means a rebuild per
  # edit and a config expressed in Nix rather than in noctalia's own format. The
  # NixOS module in modules/nixos/common.nix already installs the package and
  # the companion services, which is all that actually needs to be system-level.
  #
  # Linked file by file rather than as a directory: ~/.config/noctalia also
  # holds palettes/, and a whole-directory link would put anything dropped in
  # there under this repo's control.
  xdg.configFile."noctalia/config.toml" = repoLink "noctalia/files/config.toml";
}
