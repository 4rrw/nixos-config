{ pkgs, ... }:
{
  # GTK is the one desktop piece noctalia themes through *system* settings
  # rather than a config file it owns, so this is a home-manager module rather
  # than a symlinked app-native config: the icon theme has to be a store path,
  # and the settings only exist as a generated settings.ini plus dconf keys.
  #
  # Ownership is split deliberately, the same way noctalia's own two layers are:
  #
  #   this module -> icon-theme          (static; noctalia never writes it)
  #   noctalia    -> gtk-theme,          (flipped at runtime by the gtk3/gtk4
  #                  color-scheme         templates, on every dark/light change)
  #
  # So `gtk.theme` and `gtk.gtk3.colorScheme` are deliberately left unset. The
  # home-manager module writes only the dconf keys whose option is non-null, and
  # its activation runs `dconf load /` without -f, which merges -- so leaving
  # those two unset is what keeps a rebuild from reverting noctalia's choice.
  gtk = {
    enable = true;

    # Restores the default GTK icon set. Without an icon theme installed only
    # `hicolor` exists, which is the fallback spec and carries no real icons --
    # that is why nemo came up with blank icons. Adwaita's symbolic icons are
    # recolored by GTK to match the active theme, so they follow dark/light on
    # their own; a fixed pair like Papirus-Dark would not.
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  # The theme noctalia's gtk apply.sh switches between: it looks for adw-gtk3 /
  # adw-gtk3-dark in the themes directories and silently skips setting a theme
  # at all when neither is found. GTK3 has no notion of `color-scheme`, so
  # swapping this name is the only thing that actually makes GTK3 apps dark.
  home.packages = [ pkgs.adw-gtk3 ];
}
