{ pkgs, ... }:
{
  # A home-manager module rather than a symlink because the icon theme has to be
  # a store path. Only icon-theme is set here -- noctalia flips gtk-theme and
  # color-scheme at runtime, and leaving those unset is what stops a rebuild
  # reverting its choice.
  gtk = {
    enable = true;

    # Without this only `hicolor` exists, which carries no real icons -- that is
    # why nemo came up blank. Adwaita's symbolic icons follow dark/light on their
    # own, which a fixed pair like Papirus-Dark would not.
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  # noctalia's gtk apply.sh switches between adw-gtk3 and adw-gtk3-dark, and
  # silently sets no theme at all when neither is installed. GTK3 has no
  # `color-scheme`, so the theme name is the only thing that makes it dark.
  home.packages = [ pkgs.adw-gtk3 ];
}
