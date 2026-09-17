{
  config,
  lib,
  pkgs,
  ...
}:
{
  fonts.packages = with pkgs; [
    fira-code
    cm_unicode
    fira
    nerd-fonts.ubuntu
  ];
}
