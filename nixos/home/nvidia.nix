{
  config,
  pkgs,
  inputs,
  ...
}:
{
  targets.genericLinux.gpu.nvidia = {
    enable = true;
    version = "590.48.01";
    sha256 = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
  };
}
