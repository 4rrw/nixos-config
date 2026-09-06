# home-manager config shared by every host; per-machine extras go in hosts/<name>/home.nix.

{ config, ... }:
{
  imports = [
    ./tmux
    ./neovim
    ./lazygit
    ./ghostty
    ./git
    ./gtk
    ./fish
    ./hypr
    ./noctalia
    ./tms
  ];

  home.username = "stshalson";
  home.homeDirectory = "/home/stshalson";
  # Bumping this from 25.05 is a no-op here; the 26.05-gated defaults are all in
  # modules this config does not enable.
  home.stateVersion = "26.05";

  home.packages = [ ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
  };
}
