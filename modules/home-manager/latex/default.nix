# texlive env built from a scheme + explicit CTAN packages; tlmgr can't work on a
# read-only store, so anything missing gets added to the withPackages list below.

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (texlive.withPackages (
      ps: with ps; [
        scheme-medium

        latexmk # the build driver texlab/vimtex shell out to
        biber
        biblatex
        koma-script
        pgfplots
        cm-super # scalable T1 fonts, otherwise PDFs render blurry
      ]
    ))

    texlab # LSP for nvim
    tex-fmt
    zathura # synctex-capable viewer
  ];
}
