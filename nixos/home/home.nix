{
  config,
  pkgs,
  modulesPath,
  host,
  ...
}:
{
  imports = [
    ./config.nix
    ./vim.nix
    ./management.nix
  ];
  home.username = "gabri";
  home.homeDirectory = "/home/gabri";
  programs.home-manager.enable = true;
  home.stateVersion = "25.05"; # Please read the comment before changing.
  targets.genericLinux.enable = true;

  xdg = {
    enable = true;
    terminal-exec = {
      enable = true;
      settings.default = [ "ghostty.desktop" ];
    };
    userDirs = {
      setSessionVariables = true;
      createDirectories = true;
      enable = true;
      desktop = "$HOME/xdg-dump";
      download = "$HOME/xdg-dump";
      templates = "$HOME/xdg-dump";
      publicShare = "$HOME/xdg-dump";
      documents = "$HOME/xdg-dump";
      music = "$HOME/xdg-dump";
      pictures = "$HOME/xdg-dump";
      videos = "$HOME/xdg-dump";
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
    PROJECT_DATABASE = "$HOME/dev/projects";
    PRJ_DB_DIR = "$HOME/dev/database";
    LIBVIRT_DEFAULT_URI = "qemu:///system";
  };
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/dev/database/bin"
    "$HOME/.local/share/JetBrains/Toolbox/scripts"
  ];
  home.shellAliases = {
    py = "python3";
    rd = "ripdrag -n -x";
    clip = "xclip -selection clipboard";
    mpy = "py -i -c \"import sympy as sp; import scipy as sci; import numpy as np; from sympy.abc import x,y,z\"";
  };
}
