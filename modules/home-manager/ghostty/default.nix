{ pkgs, ... }:
{
  home.packages = [ pkgs.ghostty ];

  # names ghostty as the preferred terminal for xdg-terminal-exec
  xdg.configFile."xdg-terminals.list".source = ./xdg-terminals.list;

  xdg.configFile."ghostty/config".source = ./ghostty.conf;
}
