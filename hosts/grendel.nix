{ config, pkgs, ... }:

let
  awick_id = 1000;
in
{
  imports = [
    ./grendel-hardware.nix
  ];

  nix.extraOptions = ''experimental-features = nix-command flakes'';

  networking = {
    hostName = "grendel";
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

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "24.05";
}
