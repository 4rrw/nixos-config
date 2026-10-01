# The video/* defaults. mpv itself comes from systemPackages in
# modules/nixos/common.nix; this module only claims the mime types, which
# otherwise fall through to whatever .desktop lists them first (brave).

{ lib, pkgs, ... }:
{
  # Seeded once rather than written declaratively, for the same reason as loupe:
  # apps and nautilus's "Open With -> Set as default" both write this file, and a
  # read-only store symlink would make them fail silently.
  #
  # The guard is on video/mp4 specifically, so changing the default later sticks
  # instead of being reset by the next rebuild.
  home.activation.seedVideoMimeDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${pkgs.gnugrep}/bin/grep -q '^video/mp4=' "$HOME/.config/mimeapps.list" 2>/dev/null; then
      run ${pkgs.xdg-utils}/bin/xdg-mime default mpv.desktop \
        video/mp4 video/x-matroska video/webm video/quicktime video/mpeg \
        video/x-msvideo video/avi video/x-flv video/ogg video/x-ms-wmv \
        video/x-m4v video/3gpp video/mp2t video/dv
    fi
  '';
}
