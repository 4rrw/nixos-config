{ config, pkgs, ... }:
let
  repoLink = import ../repo-link.nix { inherit config; };
in
{
  # Symlinked out of the store to the live repo (see repo-link.nix), so editing
  # config.fish or a function takes effect in the next shell, or on `source`,
  # with no rebuild.
  #
  # These files are placed rather than expressed through `programs.fish` so
  # they stay byte-identical to what was hand-written. The system-level
  # `programs.fish.enable` in configuration.nix writes /etc/fish, not
  # ~/.config, so the two do not collide.
  #
  # fish_variables is deliberately NOT managed: `set -U` rewrites it, and
  # universal variables are machine-local state rather than config.
  xdg.configFile = {
    "fish/config.fish" = repoLink "fish/config.fish";
    "fish/functions/auto_venv.fish" = repoLink "fish/functions/auto_venv.fish";
    "fish/functions/envsource.fish" = repoLink "fish/functions/envsource.fish";

    # Stays a store path, unlike the files above: Nix generates it from
    # home.sessionVariables, so there is no repo file to edit and nothing to
    # gain from linking it out.
    #
    # home.sessionVariables is only written as POSIX sh, which fish cannot
    # source. Home-manager does translate it, but only inside `programs.fish`,
    # which is off here -- so without this, home.sessionVariables reached fish
    # not at all (EDITOR stayed at the NixOS default rather than nvim).
    #
    # conf.d is sourced before config.fish, so config.fish can still override.
    "fish/conf.d/hm-session-vars.fish".source =
      pkgs.runCommandLocal "hm-session-vars.fish" { } ''
        ${pkgs.buildPackages.babelfish}/bin/babelfish \
          <${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh \
          >$out
      '';
  };
}
