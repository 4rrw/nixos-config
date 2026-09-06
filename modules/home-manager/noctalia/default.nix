{ config, ... }:
let
  repoLink = import ../repo-link.nix { inherit config; };
in
{
  # Symlinked to the live repo (see repo-link.nix); reload with `noctalia msg
  # config-reload`. Not using the upstream home module on purpose -- its
  # `settings` option would render this TOML from Nix, so every edit would need a
  # rebuild. Linked file by file because ~/.config/noctalia also holds palettes/.
  xdg.configFile."noctalia/config.toml" = repoLink "noctalia/files/config.toml";
}
