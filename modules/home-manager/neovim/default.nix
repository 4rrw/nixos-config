{ lib, pkgs, ... }:
let
  configRepo = "https://github.com/4rrw/nvim.git";
  configDir = "$HOME/.config/nvim";
in
{
  # it just copies vim config from the repo
  # nvim packages are managed by lazy itself
  home.packages = with pkgs; [
    neovim

    # tools nvim shells out to
    fzf
    ripgrep
    luaPackages.tree-sitter-cli
    fd

    # nix language support
    nil
    statix
  ];

  # clone the config when it's not cloned yet
  # no autoupdates
  home.activation.cloneNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "${configDir}" ]; then
      run ${pkgs.git}/bin/git clone ${configRepo} "${configDir}"
    fi
  '';
}
