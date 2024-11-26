{ config, pkgs, ... }:

let
  awick_id = 1000;
in {
  imports = [
    ./vultr-vpn-name.nix
  ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [];
  boot.loader.grub.device = "/dev/vda";
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [ {
    device = "/dev/disk/by-label/swap";
  } ];

  virtualisation.hypervGuest.enable = true;

  networking = {
    enableIPv6 = true;
    useDHCP = true;
    dhcpcd.persistent = true;
    nftables.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [ 22 ];
    };
  };

  environment.systemPackages = with pkgs; [
    sudo
    git
    neovim
    tailscale
    wget
    zsh
  ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      # PasswordAuthentication = false;
      AllowUsers = [ "awick" ];
      AllowAgentForwarding = true;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  users = {
    mutableUsers = false;

    users.awick = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      uid = awick_id;
      shell = pkgs.zsh;
      hashedPasswordFile = "/etc/nixos/awick";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+jF2FvPnS1C9kZGUAobU7Bnepq/9EI1BVyAWNAZDBA adamwick@ergates"
      ];
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  system.stateVersion = "24.05";
}
