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
    mathematica
    claude-code
    #inkscape
  ];
  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };
  programs.steam.enable = true;
  programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ];
  programs.firefox.enable = true;
}
