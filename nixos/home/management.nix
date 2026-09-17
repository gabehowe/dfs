{
  config,
  pkgs,
  inputs,
  dotfiles,
  ...
}:
{
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
    home.file."texmf/tex/latex/local".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tex";
}
