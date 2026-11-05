{ config, ... }:
let
repoLink = import ../repo-link.nix { inherit config; };
in
{
xdg.configFile."lf" = repoLink "lf/files";
}
