{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    vim 
    discord
    obs-studio
    signal-desktop
    vlc
    jetbrains-toolbox
    spotify
    zathuraPkgs.zathura_pdf_mupdf
    tmux
    #inkscape
  ];
  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };
  programs.steam.enable = true;
  programs.firefox.enable = true;
}
