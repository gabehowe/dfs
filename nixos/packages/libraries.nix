{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    sane-backends
  ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libxext
    wayland
    libxkbcommon
    xawtv
    libx11
    libxrender
    libxtst
    libxi
    libxft
    freetype
    fontconfig
  ];

}
