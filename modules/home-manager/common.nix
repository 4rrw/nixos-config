# home-manager configuration shared by every host.
#
# Each host's hosts/<name>/home.nix imports this and can add anything it needs
# on top of it.

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
  # home-manager is pinned to release-26.05 in flake.nix. Bumping this from
  # 25.05 is a no-op for what is configured here: the only 26.05-gated defaults
  # are in modules this config does not enable (docker-cli, mergiraf, zsh,
  # colima) or Darwin-only paths.
  home.stateVersion = "26.05";

  home.packages = [ ];

  home.sessionVariables = {
    EDITOR = "nvim";
    # Enable bitwarden SSH Agent
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
  };
}
