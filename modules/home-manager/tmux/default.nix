{ pkgs, ... }:
{

  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    focusEvents = true;
    terminal = "tmux-256color";
    sensibleOnTop = true;
    secureSocket = false;
    plugins = with pkgs.tmuxPlugins; [
      yank
      gruvbox
      catppuccin
    ];
    extraConfig = builtins.readFile ./tmux-extra.conf;
  };
}
