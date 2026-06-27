# Minimal hardware configuration template for a generic machine.
# Replace this with the output of `nixos-generate-config` when installing on a new host.
{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Generic filesystem setup mounting by label.
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  # Generic boot loader modules
  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  swapDevices = [];

  # CPU architecture definition
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
