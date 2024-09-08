{ config, pkgs, lib, ... }:

let awick_id = 1000;
in {
  imports = [
    ./dunworthy-hardware.nix

    ../containers/kiwix.nix
    ../containers/mosquitto.nix
    ../containers/postgresql.nix
    ../containers/samba.nix
    ../containers/tailscale.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs = {
    forceImportRoot = false;
    extraPools = [ "pool0" ];
  };

  containers = {
    kiwix = {
      autoStart = true;
      ephemeral = true;
  
      privateNetwork = true;
      localAddress = "10.0.0.1";
      hostAddress = "10.0.0.10";
  
      bindMounts = {
        "/data/" = {
          hostPath = "/pool0/kiwix/";
          isReadOnly = false;
        };
      };
  
      forwardPorts = [{
        containerPort = 8080;
        hostPort = 8080;
        protocol = "tcp";
      }];
    };

    mosquitto = {
      autoStart = true;
      ephemeral = true;
  
      bindMounts = {
        "/persistent_store/" = {
          hostPath = "/pool0/mosquitto/";
          isReadOnly = false;
        };
      };
  
      forwardPorts = [
        {
          containerPort = 1883;
          hostPort = 1883;
          protocol = "tcp";
        }
      ];
  
      privateNetwork = true;
      localAddress = "10.0.0.2";
      hostAddress = "10.0.0.20";
    };

    samba = {
      autoStart = true;
      ephemeral = true;
  
      privateNetwork = true;
      localAddress = "10.0.0.3";
      hostAddress = "10.0.0.30";
  
      bindMounts = {
        "/persistent_store/av" = {
          hostPath = "/pool0/av/";
          isReadOnly = false;
        };
  
        "/persistent_store/backups" = {
          hostPath = "/pool0/backups";
          isReadOnly = false;
        };
      };
  
      forwardPorts = [
        {
          containerPort = 137;
          hostPort = 137;
          protocol = "udp";
        }
        {
          containerPort = 138;
          hostPort = 138;
          protocol = "udp";
        }
        {
          containerPort = 139;
          hostPort = 139;
          protocol = "tcp";
        }
        {
          containerPort = 445;
          hostPort = 445;
          protocol = "tcp";
        }
      ];
    };

    tailscale = {
      autoStart = true;
      ephemeral = true;
  
      privateNetwork = true;
      bindMounts = {
        "/var/lib/tailscale/" = {
          hostPath = "/pool0/tailscale/";
          isReadOnly = false;
        };
      };
  
      forwardPorts = [{
        containerPort = config.services.tailscale.port;
        hostPort = config.services.tailscale.port;
        protocol = "udp";
      }];
  
      localAddress = "10.0.0.4";
      hostAddress = "10.0.0.40";
    };

    postgresql = {
      autoStart = true;
      ephemeral = true;

      config.users.users.awick = {
        isSystemUser = true;
        group = "users";
        uid = awick_id;
      };
  
      privateNetwork = true;
      bindMounts = {
        "/persistent_store/" = {
          hostPath = "/pool0/postgres/";
          isReadOnly = false;
        };

        "/run/postgresql/" = {
          hostPath = "/pool0/postgres/socket/";
          isReadOnly = false;
        };
      };
  
      config.services.postgresql = {
        authentication = lib.mkOverride 10 ''
          #type database DBuser   auth-method
          local all      postgres peer
          local sameuser all      peer
          local general  awick    peer
        '';

        identMap = ''
          # ArbitraryMapName systemUser DBUser
          superuser_map      root       postgres
          superuser_map      postgres   postgres
          user               /^(.*)$    \1
        '';

        ensureDatabases = [ "awick" ];

        ensureUsers = [
          {
            name = "awick";
          }
        ];
      };

 
      localAddress = "10.0.0.5";
      hostAddress = "10.0.0.50";
    };
  };
  
  networking = {
    enableIPv6 = true;
    hostId = "a0119c15";
    hostName = "nixos-testing";
    useDHCP = true;
  
    firewall = {
      allowPing = true;
      enable = true;
  
      allowedUDPPorts = [ config.services.tailscale.port 137 138 ];
      allowedTCPPorts = [ 22 139 445 1883 8080 ];
    };
  };

  time.timeZone = "US/Pacific";
  programs.zsh.enable = true;

  users = {
    mutableUsers = false;

    users.awick = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
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

