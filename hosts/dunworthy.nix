{
  pkgs,
  lib,
  ...
}:

let
  awick_id = 1000;
  vicky_id = 1001;
  kiwix_id = 2001;
  backups_gid = 3001;
  av_gid = 4001;
in
{
  imports = [
    ./dunworthy-hardware.nix
    ../services/gitea.nix
    ../services/home-assistant.nix
    ../services/jellyfin.nix
    ../services/kiwix.nix
    ../services/stats.nix
  ];

  nix.extraOptions = ''experimental-features = nix-command flakes'';

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;

    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };

    extraServiceFiles = {
      ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
      smb = ''
        <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
        </service-group>
      '';
    };
  };

  #  services.forgejo = {
  #    enable = true;
  #
  #    database.type = "postgres";
  #    lfs.enable = true;
  #    settings = {
  #      server = {
  #        DOMAIN = "git.uhsure.com";
  #        ROOT_URL = "https://git.uhsure.com/";
  #        HTTP_PORT = 3000;
  #      };
  #      actions = {
  #        ENABLED = true;
  #        DEFAULT_ACTIONS_URL = "github";
  #      };
  #    };
  #  };

  services.fwupd.enable = true;

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  services.ollama = {
    enable = true;
    acceleration = "rocm";

    user = "ollama";
    group = "ollama";
    models = "/pool0/ai-models/ollama";
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

  services.postgresql = {
    enable = true;
    dataDir = "/pool0/postgres";
    enableJIT = true;

    ensureDatabases = [
      "awick"
      "hass"
    ];
    ensureUsers = [
      {
        name = "hass";
        ensureDBOwnership = true;
      }
      {
        name = "awick";
        ensureDBOwnership = true;
      }
    ];
    settings = {
      fsync = true;

      log_destination = lib.mkForce "syslog";
    };
  };

  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        workgroup = "WICKHOUSE";
        "server string" = "The Wick Data Store";
        "server role" = "standalone server";
        "smb encrypt" = "desired";
        "server smb encrypt" = "required";
        "server min protocol" = "SMB3_00";
        deadtime = 30;
        "use sendfile" = "yes";
        security = "user";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };

      timemachine = {
        comment = "Time Machine";
        path = "/pool0/backups";
        browseable = "yes";
        writeable = "yes";
        "create mask" = "0660";
        "directory mask" = "0770";
        "spotlight" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
        "force group" = "backups";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
      };

      av = {
        comment = "AV Files";
        path = "/pool0/av";
        browseable = "yes";
        writeable = "yes";
        "create mask" = "0660";
        "directory mask" = "0770";
        "spotlight" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "force group" = "av";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
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
        80
        1883
        8123
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

    users.kiwix = {
      isSystemUser = true;
      group = "kiwix";
      uid = kiwix_id;
    };

    groups.av = {
      gid = av_gid;
    };

    groups.kiwix = {
      gid = kiwix_id;
    };

    groups.backups = {
      gid = backups_gid;
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
    linux-firmware
    podman-tui
    podman-compose
    sudo
    vim
    wget
    zfs
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "24.05"; # Did you read the comment?
}
