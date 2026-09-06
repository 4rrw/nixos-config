# Nautilus with the pieces a GNOME session would normally provide. On its own the
# package is just the browser -- previews, search, thumbnails and network shares
# all come from separate services that nothing else here turns on.

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nautilus
    file-roller # nautilus extracts archives itself via gnome-autoar, but this is the GUI for the rest

    # Thumbnailers are found through /share/thumbnailers, which is already in
    # environment.pathsToLink, so installing the package is enough.
    ffmpegthumbnailer # video and audio
    gnome-epub-thumbnailer # epub and mobi
    papers # PDFs; also gives a document viewer
    webp-pixbuf-loader # webp, which gdk-pixbuf cannot decode on its own
  ];

  # Trash, the Other Locations pane, and the smb:// sftp:// dav:// backends.
  services.gvfs.enable = true;

  # Space-bar quick preview, the way it works in GNOME.
  services.gnome.sushi.enable = true;

  # Full-text search in the search bar. localsearch does the indexing and
  # tinysparql is the store it indexes into; nautilus falls back to plain
  # filename matching without them.
  services.gnome.localsearch.enable = true;
  services.gnome.tinysparql.enable = true;

  # Right-click -> Open in Terminal. "ghostty" is one of the terminals the
  # extension knows how to launch.
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };

  # Nautilus keeps its view settings, sort order and bookmarks in dconf.
  programs.dconf.enable = true;
}
