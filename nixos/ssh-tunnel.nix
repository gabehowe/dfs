{ pkgs, lib, ... }:
let
  ports = {
    "5522" = "22";
    "25565" = "25565";
    "7777" = "7777";
  };
  arg = lib.strings.concatStringsSep " " (
    builtins.attrValues (
      lib.attrsets.mapAttrs (key: value: "-R 0.0.0.0:${key}:localhost:${value}") ports
    )
  );
in
{
  environment.systemPackages = [ pkgs.openssh ];
  systemd.services.sshtunnel = {
    description = "Expose ports via a GCP instance";
    after = [ "ssh.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "30s";
      # You must ssh into the GCP instance as root before it will work, so this isn't quite pure.
      ExecStart = ''${pkgs.openssh}/bin/ssh -i /home/gabri/.ssh/gcp_id -g -N -T -o "ExitOnForwardFailure yes" ${arg} -p 23 gabri@bitty.gabe.how'';
    };
  };
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      GatewayPorts = "yes";
    };
  };
}
