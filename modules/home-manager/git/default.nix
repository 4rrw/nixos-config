{ config, ... }:
let
  repoLink = import ../repo-link.nix { inherit config; };
in
{
  # The XDG path, so ~/.gitconfig stays free for `git config --global` and
  # machine-local keys like safe.directory.
  xdg.configFile."git/config" = repoLink "git/files/config";
}
