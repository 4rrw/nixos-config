{ config, ... }:
let
  repoLink = import ../repo-link.nix { inherit config; };
in
{
  # ~/.config/git/config, which is also where home-manager's own `programs.git`
  # writes. Linking the XDG file rather than ~/.gitconfig leaves the latter free
  # for `git config --global` and for machine-local keys like safe.directory,
  # instead of pointing a managed link at git's own write target.
  xdg.configFile."git/config" = repoLink "git/files/config";
}
