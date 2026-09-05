{ config, pkgs, ... }:
{
  imports = [
    ../../modules/home-manager/tmux
    ../../modules/home-manager/neovim
    ../../modules/home-manager/lazygit
    ../../modules/home-manager/ghostty
    ../../modules/home-manager/fish
    ../../modules/home-manager/hypr
    ../../modules/home-manager/tms
  ];

  home.username = "stshalson";
  home.homeDirectory = "/home/stshalson";
  home.stateVersion = "25.05";

  home.packages = [ ];

  home.sessionVariables = {
    EDITOR = "nvim";
    # Enable bitwarden SSH Agent
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
  };
}
