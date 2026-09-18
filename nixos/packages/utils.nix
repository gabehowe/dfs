{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    wget
    parted
    git
    distrobox
    unzip
    nixfmt
    nixfmt-tree
    nix-search
    nix-tree
    killall
    pciutils
    iperf3
    libnotify
    i2c-tools
    dust
    htmlq
    pinentry-curses
    gnupg
    pandoc
    ffmpeg
    ripdrag
    ripgrep
    imagemagick
    bat
    xclip
    jq
    nmap
    viu
    direnv
    netcat
    bluetui
    dig
    ack
    tcpdump
    unison
    usbutils
    pax
    socat
    inotify-tools
    tree-sitter
    poppler-utils
    file-rename
    git-lfs
    parted
    dmidecode
    wl-clipboard
    tree
    brightnessctl
  ];
  # traceroute/ping
  programs.mtr.enable = true;

  # Make plocate work.
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "daily";
    prunePaths = [
      "/var/lib"
      "/var/run"
      "/var/spool"
      "/var/tmp"
    ];
  };


}
