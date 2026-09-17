{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.system76-scheduler.enable = true;
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-term
  ];
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
}
