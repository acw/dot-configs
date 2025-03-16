{
  pkgs,
  ...
}:

let
  awick_id = 1000;
  vicky_id = 1001;
in
{
  imports = [
    ./dunworthy-hardware.nix
    ../services/gitea.nix
    ../services/home-assistant.nix
    ../services/jellyfin.nix
    ../services/kiwix.nix
    ../services/postgres.nix
    ../services/samba.nix
    ../services/stats.nix
  ];

  nix.extraOptions = ''experimental-features = nix-command flakes'';

  services.fwupd.enable = true;

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  services.tailscale = {
    enable = true;
  };

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

  networking = {
    enableIPv6 = true;

    hostId = "d9692086";
    hostName = "dunworthy";
    useDHCP = false;

    interfaces = {
      enp4s0 = {
        useDHCP = true;
      };
      enp6s0 = {
        useDHCP = true;
      };
    };

    firewall = {
      allowPing = true;
      enable = true;

      allowedTCPPorts = [
        80 # HTTP
        1883 # MQTT
        8096 # Jellyfin
      ];
    };
  };

  time.timeZone = "US/Pacific";
  programs.zsh.enable = true;

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;

    users.awick = {
      isNormalUser = true;
      home = "/home/awick";
      description = "Adam C. Wick";
      extraGroups = [
        "wheel"
        "networkmanager"
        "av"
        "backups"
        "hass"
        "ollama"
      ];
      uid = awick_id;
      shell = pkgs.zsh;
      hashedPasswordFile = "/etc/nixos/awick";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+jF2FvPnS1C9kZGUAobU7Bnepq/9EI1BVyAWNAZDBA adamwick@ergates"
      ];
    };

    users.vicky = {
      isNormalUser = true;
      home = "/home/vicky";
      description = "Victoria E. Wick";
      uid = vicky_id;
      shell = pkgs.zsh;
      hashedPasswordFile = "/etc/nixos/vicky";
      extraGroups = [
        "av"
        "backups"
      ];
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    ffmpeg-full
    kiwix-tools
    iotop
    linux-firmware
    podman-tui
    podman-compose
    pv
    sudo
    vim
    wget
    zfs
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "24.05"; # Did you read the comment?
}
