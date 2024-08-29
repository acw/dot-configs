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

    config = { lib, ... }: {
      services.kiwix = {
        enable = true;
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
