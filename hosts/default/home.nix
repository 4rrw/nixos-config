{ config, pkgs, ... }:
{
  home.username = "stshalson";
  home.homeDirectory = "/home/stshalson";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [ ];

# Enable bitwarden SSH Agent
  home.sessionVariables.SSH_AUTH_SOCK =
    "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";

  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    focusEvents = true;
    terminal = "tmux-256color";
    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      gruvbox
      catppuccin
    ];
    extraConfig = builtins.readFile ./tmux/tmux-extra.conf;
  };
}
