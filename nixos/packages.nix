{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    parted
    git
    distrobox
    unzip
    nixfmt
    nixfmt-tree
    killall
    pciutils
    iperf3
    sane-backends
    android-tools
  ];

  fonts.packages = with pkgs; [
    fira-code
    cm_unicode
    fira
    nerd-fonts.ubuntu
  ];
}
