{ ... }:
{
  # Files are placed directly rather than through `programs.fish` so they stay
  # byte-identical to what was hand-written. The system-level
  # `programs.fish.enable` in configuration.nix writes /etc/fish, not ~/.config,
  # so the two do not collide.
  #
  # fish_variables is deliberately NOT managed: `set -U` rewrites it, and
  # universal variables are machine-local state rather than config.
  xdg.configFile = {
    "fish/config.fish".source = ./config.fish;
    "fish/functions/auto_venv.fish".source = ./functions/auto_venv.fish;
    "fish/functions/envsource.fish".source = ./functions/envsource.fish;
  };
}
