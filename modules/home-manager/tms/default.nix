{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.tmux-sessionizer ];

  # Seeded, not symlinked: `tms config` writes this file, so it has to stay writable.
  home.activation.seedTmsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "$HOME/.config/tms/config.toml" ]; then
      run ${pkgs.coreutils}/bin/install -Dm644 ${./config.toml} "$HOME/.config/tms/config.toml"
    fi
  '';
}
