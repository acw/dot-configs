{
  pkgs,
  lib,
  ...
}:

let
  awick_id = 1000;
  vicky_id = 1001;
  kiwix_id = 2001;
in
{
  imports = [
    ./dunworthy-hardware.nix
  ];

  nix.extraOptions = ''experimental-features = nix-command flakes'';

  services.home-assistant = {
    enable = false;
    package = (pkgs.home-assistant.override {
      extraPackages = py: with py; [ psycopg2 ];
    }).overrideAttrs (oldAttrs: {
      doInstallCheck = false;
    });

    extraComponents = [
      "esphome"
      "met"
      "radio_browser"
    ];

    configDir = "/pool0/home-assistant";
    config = {
      default_config = {};
      recorder.db_url = "postgresql://@/hass";
    };
  };

  systemd.services.kiwix = {
    enable = false;
    description = "Kiwix local wiki server";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/sh -c \"${pkgs.kiwix-tools}/bin/kiwix-serve -r /kiwix --port=8080 /pool0/kiwix/*.zim\"";
      User = "kiwix";
    };
  };

  services.fwupd.enable = true;

  services.mosquitto = {
    enable = false;
    persistence = true;
    dataDir = "/pool0/mosquitto/";
    logDest = [ "syslog" ];
    logType = [
      "error"
      "warning"
      "information"
    ];

    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];

    settings.persistence_location = "/pool0/mosquitto/mosquitto.db";
  };

  services.nginx = {
    enable = false;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."home.uhsure.com" = {
      locations."/" = {
        root = "/pool0/www";
      };

      locations."/kiwix" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = false;
        extraConfig = "proxy_redirect default;";
      };

      locations."/hass" = {
        proxyPass = "http://127.0.0.1:8123";
        proxyWebsockets = false;
        extraConfig = "proxy_redirect default;";
      };
    };
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
    enable = false;
    dataDir = "/pool0/postgres";
    enableJIT = true;

    ensureDatabases = [ "hass" ];
    ensureUsers = [{
      name = "hass";
      ensureDBOwnership = true;
    }];
    settings = {
      fsync = true;

      log_destination = lib.mkForce "syslog";
    };
  };

  services.samba = {
    enable = false;
    openFirewall = true;

    settings = {
      global = {
        workgroup = "WICKHOUSE";
        "server string" = "The Wick Data Store";
        "server role" = "standalone server";
        "smb encrypt" = "desired";
        deadtime = 30;
        "use sendfile" = "yes";
        security = "user";
      };

      timemachine = {
        comment = "Time Machine";
        path = "/pool0/backups";
        public = "no";
        writeable = "yes";
        "create mask" = "0600";
        "directory mask" = "0700";
        "spotlight" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
        "force user" = "username";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
      };

      av = {
        comment = "AV Files";
        path = "/pool0/av";
        browseable = "yes";
        writeable = "yes";
        "create mask" = "0600";
        "directory mask" = "0700";
        "public" = "yes";
        "spotlight" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
        "fruit:aapl" = "yes";
      };
    };
  };

  services.samba-wsdd = {
    enable = false;
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

      allowedUDPPorts = [ 137 138 ];
      allowedTCPPorts = [ 80 139 445 8123 ];
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
    };

    users.kiwix = {
      isSystemUser = true;
      group = "kiwix";
      uid = kiwix_id;
    };

    groups.kiwix = {
      gid = kiwix_id;
    };
  };

  environment.systemPackages = with pkgs; [
    kiwix-tools
    linux-firmware
    sudo
    vim
    wget
    zfs
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "24.05"; # Did you read the comment?
}
