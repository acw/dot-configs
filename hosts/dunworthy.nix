{
  config,
  pkgs,
  lib,
  ...
}:

let
  awick_id = 1000;
  vicky_id = 1002;
in
{
  imports = [
    ./dunworthy-hardware.nix

    ../containers/kiwix.nix
#    ../containers/mosquitto.nix
#    ../containers/postgresql.nix
#    ../containers/samba.nix
#    ../containers/tailscale.nix
  ];

#  containers = {
#    mosquitto = {
#      autoStart = true;
#      ephemeral = true;
#
#      bindMounts = {
#        "/persistent_store/" = {
#          hostPath = "/pool0/mosquitto/";
#          isReadOnly = false;
#        };
#      };
#
#      forwardPorts = [
#        {
#          containerPort = 1883;
#          hostPort = 1883;
#          protocol = "tcp";
#        }
#      ];
#
#      privateNetwork = true;
#      localAddress = "10.0.1.1";
#      hostAddress = "10.0.1.6";
#    };
#
#    samba = {
#      autoStart = true;
#      ephemeral = true;
#
#      privateNetwork = true;
#      localAddress = "10.0.2.1";
#      hostAddress = "10.0.2.6";
#
#      bindMounts = {
#        "/persistent_store/av" = {
#          hostPath = "/pool0/av/";
#          isReadOnly = false;
#        };
#
#        "/persistent_store/backups" = {
#          hostPath = "/pool0/backups";
#          isReadOnly = false;
#        };
#      };
#
#      forwardPorts = [
#        {
#          containerPort = 137;
#          hostPort = 137;
#          protocol = "udp";
#        }
#        {
#          containerPort = 138;
#          hostPort = 138;
#          protocol = "udp";
#        }
#        {
#          containerPort = 139;
#          hostPort = 139;
#          protocol = "tcp";
#        }
#        {
#          containerPort = 445;
#          hostPort = 445;
#          protocol = "tcp";
#        }
#      ];
#    };
#
#    tailscale = {
#      autoStart = true;
#      ephemeral = true;
#
#      privateNetwork = true;
#      bindMounts = {
#        "/var/lib/tailscale/" = {
#          hostPath = "/pool0/tailscale/";
#          isReadOnly = false;
#        };
#      };
#
#      forwardPorts = [
#        {
#          containerPort = config.services.tailscale.port;
#          hostPort = config.services.tailscale.port;
#          protocol = "udp";
#        }
#      ];
#
#      localAddress = "10.0.3.1";
#      hostAddress = "10.0.3.6";
#    };
#
#    postgresql = {
#      config.users.users.awick = {
#        isSystemUser = true;
#        group = "users";
#        uid = awick_id;
#      };
#

#      config.services.postgresql = {
#        authentication = lib.mkOverride 10 ''
#          #type database DBuser   auth-method
#          local all      postgres peer
#          local sameuser all      peer
#          local general  awick    peer
#        '';
#
#        identMap = ''
#          # ArbitraryMapName systemUser DBUser
#          superuser_map      root       postgres
#          superuser_map      postgres   postgres
#          user               /^(.*)$    \1
#        '';
#
#        ensureDatabases = [ "awick" ];
#
#        ensureUsers = [
#          {
#            name = "awick";
#          }
#        ];
#      };
#
#      localAddress = "10.0.4.1";
#      hostAddress = "10.0.4.6";
#    };
#  };

  networking = {
    enableIPv6 = true;
    hostId = "a0119c15";
    hostName = "nixos-testing";
    useDHCP = false;

    interfaces = {
      ens160 = {
        useDHCP = true;
      };

      kiwix0 = {
        virtual = true;
        virtualType = "tun";
      };

      kiwix1 = {
        virtual = true;
        virtualType = "tun";
      };
    };

    nat = {
      enable = true;
      enableIPv6 = true;

      externalInterface = "ens160";
      internalInterfaces = [ ];
    };
    

    firewall = {
      allowPing = true;
      enable = true;

#        config.services.tailscale.port
#        137
#        138
      allowedUDPPorts = [
      ];
#        22
#        139
#        445
#        1883
#        8080
      allowedTCPPorts = [
      ];
    };
  };

  time.timeZone = "US/Pacific";
  programs.zsh.enable = true;

  users = {
    mutableUsers = false;

    users.awick = {
      isNormalUser = true;
      home = "/home/awick";
      description = "Adam Wick";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      uid = awick_id;
      shell = pkgs.zsh;
      hashedPasswordFile = "/pool0/secrets/awick";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+jF2FvPnS1C9kZGUAobU7Bnepq/9EI1BVyAWNAZDBA adamwick@ergates"
      ];
    };

    users.vicky = {
      isNormalUser = true;
      home = "/home/vicky";
      description = "Victoria Wick";
      uid = vicky_id;
      shell = pkgs.zsh;
      hashedPasswordFile = "/pool0/secrets/vicky";
    };
  };

  environment.systemPackages = with pkgs; [
    sudo
    vim
    wget
    zfs
  ];

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

  security.sudo.wheelNeedsPassword = false;

  services.zfs = {
     autoScrub = {
       enable = true;
       pools = [ "pool0" ];
     };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
