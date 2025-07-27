{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./mensah.nix

#    ../services/forgejo.nix
#    ../services/gitea.nix
#    ../services/jellyfin.nix
#    ../services/kiwix.nix
#    ../services/llama.nix
#    ../services/mosquitto.nix
#    ../services/postgres.nix
#    ../services/prometheus.nix
#    ../services/prometheus-export.nix
#    ../services/ssh.nix
#    ../services/samba.nix
#    ../services/sillytavern.nix
#    ../services/tailscale.nix
  ];

  nix.extraOptions = ''experimental-features = nix-command flakes'';

  services.fwupd.enable = true;
  services.nginx = {
    enable = true;
    eventsConfig = "worker_connections 512;";
    defaultListen = [
      { addr = "0.0.0.0"; port = 80; }
      { addr = "[::0]";   port = 80; }
    ];

    virtualHosts.home = {
      default = true;
      root = "/pool0/nginx/static";
    };
  };
  services.resolved.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  networking = {
    enableIPv6 = true;

    hostId = "7a520bec";
    hostName = "mensah";
    useDHCP = lib.mkDefault true;

    firewall = {
      allowPing = true;
      enable = true;

      trustedInterfaces = [ "tailscale0" ];
      allowedTCPPorts = []
        ++ builtins.map (listener: listener.port) config.services.mosquitto.listeners
        ++ builtins.map (listen: listen.port) config.services.nginx.defaultListen
        ++ [config.services.gitea.settings.server.SSH_PORT];
    };
  };

  systemd.tmpfiles.rules = [
    #Type  Path                     Mode User     Group      Age  Argument
    # The age here specifies that the contents should be cleaned up after 1 day
    "d     /var/run/comfyui/inputs  775  comfy    comfy      1d"
    "d     /var/run/comfyui/outputs 775  comfy    comfy      1d"
  ];

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
        "cdrom"
        "networkmanager"
        "av"
        "backups"
        "hass"
        "docker"
        "prometheus"
#        "comfy"
      ];
      shell = pkgs.zsh;
      hashedPasswordFile = "/etc/nixos/awick";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+jF2FvPnS1C9kZGUAobU7Bnepq/9EI1BVyAWNAZDBA adamwick@ergates"
      ];
    };
 
    #users.comfy = generate_system_user "comfy" 989 // {
    #  extraGroups = [ "render" "video" ];
    #};
    #users.llama = generate_system_user "llama" 986 // {
    #  extraGroups = [ "render" "video" ];
    #};

    users.vicky = {
      isNormalUser = true;
      home = "/home/vicky";
      description = "Victoria E. Wick";
      shell = pkgs.zsh;
      hashedPasswordFile = "/etc/nixos/vicky";
      extraGroups = [
        "av"
        "backups"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    clinfo
    cpio
    docker-compose
    ffmpeg-full
    iotop
    linux-firmware
    makemkv
    pciutils
    pv
    sudo
    vim
    wget
    zfs
  ];

  security.sudo.wheelNeedsPassword = false;
  #virtualisation.docker = {
  #  enable = true;

  #  rootless = {
  #    enable = true;
  #    setSocketVariable = true;
  #  };

  #  daemon.settings = {
  #    userland-proxy = false;
  #    experimental = false;
  #    fixed-cidr-v6 = "fd00::/80";
  #    ipv6 = true;
  #    data-root = "/pool0/docker";
  #    metrics-addr = "127.0.0.1:9323";
  #  };
  #}; 

  system.stateVersion = "24.05"; # Did you read the comment?
}
