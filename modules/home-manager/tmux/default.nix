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
      # Colors come from noctalia's tmux template (see tmux-extra.conf), so no
      # theme plugin: one would hard-code colors over noctalia's.
      yank
    ];
    extraConfig = builtins.readFile ./tmux-extra.conf;
  };
}
