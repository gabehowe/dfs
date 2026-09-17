{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    android-tools
    (texliveMedium.withPackages (
      ps: with ps; [
        latexmk
        texcount
        collection-latexextra
        collection-bibtexextra
        collection-latexrecommended
        biblatex-mla
        spie
      ]
    ))
    luarocks
    lua5_1
    cargo
    uv
    (python313.withPackages (
      ps: with ps; [
        numpy
        pandas
        requests
        pynvim
        sympy
        wand
        scipy
        matplotlib
        openpyxl
        lark
      ]
    ))
    rustc
    clippy
    gradle_9
    pkg-config
    gcc
    clang
    cmake
    gnumake
  ];
}
