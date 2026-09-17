{
  config,
  pkgs,
  inputs,
  ...
}:
{

  home.file.".vim/" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/vim";
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
        src = ../../vim/plugin;
      })
    ];
    extraConfig = builtins.readFile ../../vim/vimrc;
  };

}
