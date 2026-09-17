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
    ./packages.nix
    ./vim.nix
  ];
  home.username = "gabri";
  home.homeDirectory = "/home/gabri";

  home.file.".config/nvim/".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim";
  home.stateVersion = "25.05"; # Please read the comment before changing.
  targets.genericLinux.enable = true;

  xdg = {
    enable = true;
    userDirs = {
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
    #LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
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

  programs.git = {
    enable = true;
    settings = {
      user.name = "Gabriel Howe";
      user.email = "me@gabe.how";
      commit.gpgsign = true;
      gpg.format = "openpgp";
      tag.gpgSign = true;
      user.signingkey = if host == "furunculus" then "8F73AC7627D18889" else "54A940168323447B";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      receive.denyCurrentBranch = "updateInstead";
      safe.directory = [ "/etc/nixos" ];
      alias = {
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
      };
    };
  };
  programs.bash = {
    enable = true;
    initExtra = ''
      	eval "$(direnv hook bash)" 
      	bind '"\e[5~": history-search-backward'
      	bind '"\e[6~": history-search-forward'
      	shopt -s histappend
      	PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
          export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      	'';
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;
    dotDir = "${config.xdg.configHome}/zsh";
    oh-my-zsh = {
      # "ohMyZsh" without Home Manager
      enable = true;
      plugins = [ ];
      # theme = "custom";
      custom = "$HOME/.oh-my-zsh/custom";
    };
    initContent = ''
                precmd() {
                  psvar=(''${(s:/:)PWD})
                }
                 	eval "$(direnv hook zsh)" 
                 	bindkey "\e[5~" up-line-or-search
                 	bindkey "\e[6~" down-line-or-search
                 	PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
            		export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
                  if [[ -v CONTAINER_ID ]]; then
                    PROMPT="%F{14}%n%F{15}@%F{${
                      if host == "furunculus" then
                        "14"
                      else if host == "minimus" then
                        "1"
                      else
                        "13"
                    }}$CONTAINER_ID%F{15}:%F{5}%4(v.‥/.)%4~%F{15}$%f "
                  else
                    PROMPT="%F{14}%n%F{15}@%F{${
                      if host == "furunculus" then
                        "14"
                      else if host == "minimus" then
                        "1"
                      else
                        "13"
                    }}%m%F{15}:%F{5}%4(v.‥/.)%4~%F{15}$%f "
                  fi
      	'';
  };
  #programs.gpg.enable=true;
  xdg.userDirs.setSessionVariables = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
    maxCacheTtl = 7200;
    defaultCacheTtl = 3600;
    enableSshSupport = true;
  };
  programs.neovim = {
    withRuby = false;
    withPython3 = true;
    enable = true;
    sideloadInitLua = true;
  };
  programs.home-manager.enable = true;
  programs.zathura = {
    enable = true;
    options = {
      font = "Fira Sans normal 11";
    };
  };
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "ghostty.desktop" ];
  };
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "papercolor-dark";
      shell-integration-features = "cursor,sudo,title,ssh-env,path";
      command = "tmux new-session -A -t ghostty";
      keybind = [
        "global:ctrl+grave_accent=toggle_quick_terminal"
        "ctrl+b>c=new_tab"
        "ctrl+b>o=goto_split:next"
        "ctrl+b>shift+5=new_split:right"
        "ctrl+b>shift+'=new_split:down "
        "ctrl+b>shift+;=toggle_command_palette"
        "ctrl+b>alt+1=equalize_splits"
        "ctrl+b>n=next_tab"
        "ctrl+b>p=previous_tab"
        "ctrl+b>x=close_surface"
        "ctrl+b>shift+7=close_window"
        "ctrl+b>z=toggle_split_zoom"
      ];
      confirm-close-surface = false;
      gtk-single-instance = "true";
      window-decoration = "none";
      quick-terminal-autohide = true;
    };
    #clearDefaultKeybinds = true;
    themes = {
      papercolor-dark = {
        palette = [
          "0 = #1c1c1c"
          "1 = #af005f"
          "2 = #5faf00"
          "3 = #d7af5f"
          "4 = #5fafd7"
          "5 = #808080"
          "6 = #d7875f"
          "7 = #d0d0d0"
          "8 = #585858"
          "9 = #5faf5f"
          "10= #afd700"
          "11= #af87d7"
          "12= #ffaf00"
          "13= #ff5faf"
          "14= #00afaf"
          "15= #5f8787"
        ];
        background = "#1c1c1c";
        foreground = "#d0d0d0";
        cursor-color = "#5faf5f";
        cursor-text = "#c6c6c6";
        selection-background = "#8787af";
        selection-foreground = "#000000";
      };
    };
  };
}
