# Sites run as their own windows
#
# To add one: drop files/<name>.desktop and icons/<name>.png in, then rebuild.
# Copy already existing one and modify the fields + download the icon from dashboardicons.com
#
# @HOME is substituted on nix build so after change you have to do nix switch

{ config, lib, pkgs, ... }:
let
  repoLink = import ../repo-link.nix { inherit config; };

  entries = lib.filter (lib.hasSuffix ".desktop") (lib.attrNames (builtins.readDir ./files));

  render =
    file:
    pkgs.writeText file (
      lib.replaceStrings [ "@HOME@" ] [ config.home.homeDirectory ] (builtins.readFile ./files/${file})
    );
in
{
  xdg.dataFile =
    lib.listToAttrs (
      map (file: lib.nameValuePair "applications/${file}" { source = render file; }) entries
    )
    // {
      # Linked as a directory so a new icon needs no entry here.
      "icons/hicolor/512x512/apps" = repoLink "webapps/icons";
    };
}
