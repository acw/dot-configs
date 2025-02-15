{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usbhid"
    "usb_storage"
  ];
  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  hardware.enableRedistributableFirmware = true;
}
