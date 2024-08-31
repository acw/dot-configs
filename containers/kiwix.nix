{ ... }:

let guid_kiwix = 1300;
in {
  users = {
    groups.kiwix.gid = guid_kiwix;
    users.kiwix = {
      isSystemUser = true;
      group = "kiwix";
      uid = guid_kiwix;
    };
  };

  containers.kiwix = {
    autoStart = true;
    ephemeral = true;

    privateNetwork = true;
    hostAddress = "192.168.200.1";
    localAddress = "192.168.200.13";

    bindMounts = {
      "/data/" = {
        hostPath = "/pool0/kiwix/";
        isReadOnly = false;
      };
    };

    forwardPorts = [{
      containerPort = 1883;
      hostPort = 1883;
      protocol = "tcp";
    }];

    config = { lib, pkgs, ... }: {
      users = {
        groups.kiwix.gid = guid_kiwix;
        users.kiwix = {
          isSystemUser = true;
          group = "kiwix";
          uid = guid_kiwix;
        };
      };

      environment.systemPackages = [
        pkgs.kiwix-tools
      ];

      systemd.services.kiwix = {
        enable = true;
        description = "Kiwix local wiki server";
        after = [ "network.target" ];
        wantedBy = [ "default.target" ];

        serviceConfig = {
          ExecStart = "/run/current-system/sw/bin/sh -c \"${pkgs.kiwix-tools}/bin/kiwix-serve --port=8080 /data/*.zim\"";
          Restart = "always";
          RestartSec = 5;
          User = "kiwix";
        };
      };

      system.stateVersion = "24.05";

      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [ 8080 ];
        };
        useHostResolvConf = lib.mkForce false;
      };

      services.resolved.enable = true;
    };
  };
}
