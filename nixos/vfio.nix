{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  #dev_ids = ["10de:2414" "10de:2288"];
  #pci_ids = ["0000:01:00.0" "0000:01:00.1"];
  dev_ids = [ ];
  pci_ids = [ ];
  enabled = false;
in
if enabled then
  {
    boot = {
      initrd.kernelModules = [
        "vfio"
        "vfio_pci"
        "vfio_iommu_type1"
      ];
      extraModprobeConfig = "options vfio-pci ids=${lib.concatStringsSep "," dev_ids}";
      kernelParams = [ "intel_iommu=on" ];
      postBootCommands = ''
        DEVS="${lib.concatStringsSep " " pci_ids}"

        for DEV in $DEVS; do
          echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
        done
        modprobe -i vfio-pci
      '';
      blacklistedKernelModules = [
        "nvidia"
        "nouveau"
      ];
    };
    programs.virt-manager.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    users.extraUsers.gabri.extraGroups = [ "libvirtd" ];
    users.groups.libvirtd.members = [ "gabri" ];
    environment.systemPackages = [
      inputs.winapps.packages."x86_64-linux".winapps
    ];
  }
else
  { }
