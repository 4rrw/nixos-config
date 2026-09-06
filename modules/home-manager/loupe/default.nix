# Image viewer, plus the image/* defaults. Without those, images open in Brave:
# nothing ever set a default, so xdg falls back to whatever .desktop claims the
# type first, and brave-browser.desktop claims them all.

{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.loupe ];

  # Seeded once rather than written declaratively, the same way tms is: apps
  # write this file themselves (bitwarden and claude-code have both registered
  # scheme handlers in it), and the file manager's "Open With -> Set as default" writes here
  # too. A store symlink would be read-only and make both fail silently.
  #
  # The guard is on image/png specifically, so changing the default later in
  # nautilus sticks instead of being reset by the next rebuild.
  home.activation.seedImageMimeDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${pkgs.gnugrep}/bin/grep -q '^image/png=' "$HOME/.config/mimeapps.list" 2>/dev/null; then
      run ${pkgs.xdg-utils}/bin/xdg-mime default org.gnome.Loupe.desktop \
        image/png image/jpeg image/gif image/webp image/bmp image/tiff \
        image/avif image/heic image/jxl image/svg+xml
    fi
  '';
}
