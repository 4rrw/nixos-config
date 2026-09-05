{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.tmux-sessionizer ];

  # Seeded rather than symlinked: `tms config ...` writes this file, so it has
  # to stay a real writable file. Home-manager plants it once on a fresh
  # machine and never touches it again.
  home.activation.seedTmsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "$HOME/.config/tms/config.toml" ]; then
      run ${pkgs.coreutils}/bin/install -Dm644 ${./config.toml} "$HOME/.config/tms/config.toml"
    fi
  '';
}
