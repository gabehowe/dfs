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
  boot.binfmt.emulatedSystems = [ "armv7l-linux" ];

  security.pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];
  imports = [
    ./${host}-hardware.nix
    ./packages.nix
  ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # grub
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

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = host; # Define your hostname.
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
    # useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.flatpak.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # compatibility things build for other linux distributions
  services.envfs.enable = true;
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

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";
  services.xserver.autoRepeatDelay = 400;
  services.xserver.autoRepeatInterval = 40;
  # use gnome
  # services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome = {
  #   enable = true;
  #   sessionPath = [
  #     pkgs.gnomeExtensions.pop-shell
  #     pkgs.gnomeExtensions.super-key
  #     pkgs.pop-launcher
  #   ];
  # };
  # nixpkgs.overlays = [
  #   (import ./overlays/pop-shell-overlay.nix)
  # ];

  services.printing.enable = true;

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.sane.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  # Enable sound.
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
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
          wireplumber.settings = {
            bluetooth.autoswitch-to-headset-profile = true
          }
        '')
      ];
    };
  };

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

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
    ]; # Enable ‘sudo’ for the user.
    description = "Gabriel Howe";
  };
  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };
  programs.steam.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
      inherit pkgs;
    };
  };
  #virtualisation.docker.enable = true;
  #virtualisation.containers.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  systemd.services.systemd-udev-settle.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  services.tlp = {
    enable = battery;
    pd.enable = battery;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.nixos.label = "g${inputs.self.shortRev or inputs.self.dirtyShortRev}";

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
