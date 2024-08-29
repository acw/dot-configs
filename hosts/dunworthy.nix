{ config, pkgs, ... }:

let awick_id = 1000;
in {
  imports = [ # Include the results of the hardware scan.
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs = {
    forceImportRoot = false;
    extraPools = [ "pool0" ];
  };

  networking = {
    enableIPv6 = true;
    hostId = "a0119c15";
    hostName = "nixos-testing";
    useDHCP = true;

    firewall = {
      allowPing = true;
      enable = true;
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [ 22 1883 ];
    };
  };

  time.timeZone = "US/Pacific";
  programs.zsh.enable = true;

  users = {
    mutableUsers = false;

    users.awick = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      packages = with pkgs; [ ];
      uid = awick_id;
      shell = pkgs.zsh;
      hashedPassword =
        "$y$j9T$r8i/MvG.OVVLTk/fEVj8o/$Cs08cjyfSDSJtj1AaAE49jxKeSTBefoVs9SDSusKiR8";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+jF2FvPnS1C9kZGUAobU7Bnepq/9EI1BVyAWNAZDBA adamwick@ergates"
      ];
    };
  };

  environment.systemPackages = with pkgs; [ sudo vim wget zfs ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "awick" ];
      AllowAgentForwarding = true;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  services.zfs.autoScrub.enable = true;
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "24.05"; # Did you read the comment?

}

