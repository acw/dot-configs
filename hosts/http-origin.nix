{ config, pkgs, ... }:
let awick_id = 1000;
in {
  imports = [
    ../services/ssh.nix
    ../services/tailscale.nix
  ];

    boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "sr_mod"
    "virtio_blk"
  ];
  boot.initrd.kernelModules = [ ];
  boot.loader.grub.device = "/dev/vda";
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  virtualisation.hypervGuest.enable = true;

  networking = {
    hostName = "http-origin";
    enableIPv6 = true;
    useDHCP = false;
    dhcpcd.persistent = true;
    interfaces.ens3.useDHCP = true;
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
    wget
    zsh
  ];

  programs.zsh.enable = true;


  services.nginx = {
  };

  services.openssh.extraConfig = ''
    Match User gitea
      ForceCommand ssh -W %h:%p mensah.tail9414b.ts.net
      PermitTunnel yes
      AllowTcpForwarding yes
      PasswordAuthentication no
      PermitTTY no
  '';

  services.resolved = {
    enable = true;
  };

  services.tailscale.useRoutingFeatures = "server";

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;

    users.awick = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      uid = awick_id;
      shell = pkgs.zsh;
      hashedPasswordFile = "/etc/nixos/awick";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+jF2FvPnS1C9kZGUAobU7Bnepq/9EI1BVyAWNAZDBA adamwick@ergates"
      ];
    };
  };


  system.stateVersion = "25.05";
}
