{
  config,
  pkgs,
  inputs,
  ...
}:
{
    xdg.configFile."nvim/".source = config.lib.file.mkOutOfStoreSymlink "../../nvim";

    home.file."texmf/tex/latex/local/".source = config.lib.file.mkOutOfStoreSymlink "../../tex";
}
