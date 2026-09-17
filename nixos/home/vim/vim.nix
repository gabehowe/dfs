{
  config,
  pkgs,
  inputs,
  ...
}:
let
  vimrc = builtins.readFile ./vimrc;
in
{

  home.file.".vim/plugin" = {
    source = ./plugin;
    recursive = true;
  };
  home.file.".vim/ftplugin" = {
    source = ./ftplugin;
    recursive = true;
  };

  home.packages = with pkgs; [
    xdotool
    ruff
  ];
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-highlightedyank
      vim-easymotion
      vimtex
      ultisnips
      rainbow
      nerdtree
      YouCompleteMe
      vim-polyglot
      vim-airline-themes
      papercolor-theme
      vim-surround
      nerdcommenter
      #ale
      delimitMate
      (pkgs.vimUtils.buildVimPlugin {
        name = "ultisnips-highlight";
        src = ./plugin;
      })
    ];
    extraConfig = vimrc;
  };

}
