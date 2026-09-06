{ config, pkgs, ... }:
let
  repoLink = import ../repo-link.nix { inherit config; };
in
{
  # Symlinked to the live repo (see repo-link.nix), so edits take effect in the
  # next shell. fish_variables is left unmanaged on purpose -- `set -U` rewrites
  # it, so it is machine-local state rather than config.
  xdg.configFile = {
    "fish/config.fish" = repoLink "fish/config.fish";
    "fish/functions/auto_venv.fish" = repoLink "fish/functions/auto_venv.fish";
    "fish/functions/envsource.fish" = repoLink "fish/functions/envsource.fish";

    # home.sessionVariables is only written as POSIX sh, and home-manager only
    # translates it for fish inside `programs.fish`, which is off here -- without
    # this it never reached fish at all. conf.d loads before config.fish.
    "fish/conf.d/hm-session-vars.fish".source =
      pkgs.runCommandLocal "hm-session-vars.fish" { } ''
        ${pkgs.buildPackages.babelfish}/bin/babelfish \
          <${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh \
          >$out
      '';
  };
}
