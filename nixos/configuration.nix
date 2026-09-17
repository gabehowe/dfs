# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  config,
  lib,
  pkgs,
  host,
  battery,
  ...
}:
{
  imports = [
    ./${host}-hardware.nix
    ./packages/apps.nix
    ./packages/fonts.nix
    ./packages/lang-tools.nix
    ./packages/libraries.nix
    ./packages/utils.nix
  ];

  ## Nix configuration
  system.nixos.label = "g${inputs.self.shortRev or inputs.self.dirtyShortRev}";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  services.flatpak.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
      inherit pkgs;
    };
  };

  # Compatibility
  services.envfs.enable = true;
  boot.binfmt.emulatedSystems = [ "armv7l-linux" ];

  ## Boot configuration
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 2;
    grub = {
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 10;
    };
  };

  ## Localization and networking
  # Don't wait for network to boot.
  systemd.services.NetworkManager-wait-online.enable = false;
  security.pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];
  networking.hostName = host;
  networking.networkmanager.enable = true;
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "allow-downgrade";
      DNSOverTLS = "opportunistic";
      DNS = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      Domains = [ "~." ];
    };
  };

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  i18n.extraLocaleSettings.LC_CTYPE = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  ## Printer and scanner
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  services.printing.enable = true;
  hardware.sane.enable = true;


  ## Xilinx Vivado udev rules
  systemd.services.systemd-udev-settle.enable = true;
  services.udev.extraRules = ''
      # Xilinx rules
    ATTR{idVendor}=="1443", MODE:="666"
    ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
    ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Xilinx", MODE:="666"

    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"

  '';

  ## X Server
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.options = "eurosign:e,caps:escape";
    autoRepeatDelay = 400;
    autoRepeatInterval = 40;
  };

  ## Sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    wireplumber = {
      enable = true;
      configPackages = [
        # Disable headset auto switching.
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
          wireplumber.settings = {
            bluetooth.autoswitch-to-headset-profile = true
          }
        '')
      ];
    };
  };

  ## Hardware management
  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  services.libinput.enable = true;
  services.tlp = {
    enable = battery;
    pd.enable = battery;
  };

  ## User configuration
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.gabri = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "dialout"
      "libvirtd"
      "libvirt"
      "kvm"
      "adbusers"
      "uinput"
      "scanner"
      "lp"
      "networkmanager"
    ];
    description = "Gabriel Howe";
  };

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
