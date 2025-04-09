{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ ];

  boot = {
    extraModulePackages = [ ];
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [ "amdgpu" ];
    initrd.systemd.tpm2.enable = false;
    kernelModules = [ "kvm-amd" ];

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    #    zfs = {
    #      extraPools = [ "pool0" ];
    #      forceImportAll = false;
    #      forceImportRoot = false;
    #      devNodes = "/dev/disk/by-path";
    #    };
  };

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a769e83c-c16c-4fc0-b4f7-7d68099c3877";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C503-66DB";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/pool0" = {
    device = "pool0";
    fsType = "zfs";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/98283c18-c39e-43b4-a1e9-2389a6ca7685"; }
  ];
  systemd.tpm2.enable = false;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableAllFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    amdvlk
  ];
  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
  environment.systemPackages = with pkgs; [
    linux-firmware
  ];
}
