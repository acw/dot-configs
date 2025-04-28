{
  config,
  options,
  pkgs,
  ...
}:

let
  awick_id = 1000;
  vicky_id = 1001;
  generate_system_user = name: uid: {
      isSystemUser = true;
      group = name;
      uid = uid;
      subUidRanges = [{
        startUid = uid;
        count = 1;
      }];
  };
in
{
  imports = [
    ./dunworthy-hardware.nix
    ../services/samba.nix
  ];

  nix.extraOptions = ''experimental-features = nix-command flakes'';

  services.fwupd.enable = true;

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

  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      extraFlags = [
        "--collector.ethtool"
        "--collector.softirqs"
        "--collector.tcpstat"
      ];
    };

    zfs.enable = true;
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

  systemd.tmpfiles.rules = [
    #Type  Path                     Mode User     Group      Age  Argument
    "L+    /opt/rocm/hip            -    -        -          -    ${pkgs.rocmPackages.clr}"
    "d     /var/run/postgresql      775  postgres postgres"
    # The age here specifies that the contents should be cleaned up after 1 day
    "d     /var/run/comfyui/inputs  775  comfy    comfy      1d"
    "d     /var/run/comfyui/outputs 775  comfy    comfy      1d"
  ];

  time.timeZone = "US/Pacific";
  programs.zsh.enable = true;

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;

    groups.comfy = { };
    groups.gitea = { };
    groups.hass = { };
    groups.jellyfin = { };
    groups.kiwix = { };
    groups.llama = { };
    groups.nginx = { };
    groups.postgres = { };
    groups.prometheus = { };
    groups.sillytavern = { };

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
        "nginx"
        "prometheus"
        "comfy"
      ];
      uid = awick_id;
      shell = pkgs.zsh;
      hashedPasswordFile = "/etc/nixos/awick";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+jF2FvPnS1C9kZGUAobU7Bnepq/9EI1BVyAWNAZDBA adamwick@ergates"
      ];
    };
  
    users.comfy = generate_system_user "comfy" 989 // {
      extraGroups = [ "render" "video" ];
    };
    users.gitea = generate_system_user "gitea" 988;
    users.hass = generate_system_user "hass" config.ids.uids.hass;
    users.jellyfin = generate_system_user "jellyfin" 993;
    users.kiwix = generate_system_user "kiwix" 987;
    users.llama = generate_system_user "llama" 986 // {
      extraGroups = [ "render" "video" ];
    };
    users.nginx = generate_system_user "nginx" config.ids.uids.nginx;
    users.postgres = generate_system_user "postgres" config.ids.uids.postgres;
    users.prometheus = generate_system_user "prometheus" 984;
    users.sillytavern = generate_system_user "sillytavern" 985;

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

  environment.systemPackages = with pkgs; [
    clinfo
    cpio
    docker-compose
    ffmpeg-full
    iotop
    linux-firmware
    makemkv
    pciutils
    postgresql_17
    pv
    radeontop
    rocmPackages.clr
    rocmPackages.half
    rocmPackages.hipcc
    rocmPackages.hip-common
    rocmPackages.rocminfo
    sudo
    vim
    vulkan-tools
    wget
    zfs
  ];

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };

  security.sudo.wheelNeedsPassword = false;
  virtualisation.docker = {
    enable = true;

    rootless = {
      enable = true;
      setSocketVariable = true;
    };

    daemon.settings = {
      userland-proxy = false;
      experimental = false;
      fixed-cidr-v6 = "fd00::/80";
      ipv6 = true;
      data-root = "/pool0/docker";
      metrics-addr = "127.0.0.1:9323";
    };
  }; 

  system.stateVersion = "24.05"; # Did you read the comment?
}
