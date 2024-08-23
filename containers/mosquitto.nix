{ ... }:

let guid_mosquitto = 1200;
in {
  users = {
    groups.mosquitto.gid = guid_mosquitto;
    users.mosquitto = {
      isSystemUser = true;
      group = "mosquitto";
      uid = guid_mosquitto;
    };
  };

  containers.mosquitto = {
    autoStart = true;
    ephemeral = true;

    privateNetwork = true;
    hostAddress = "192.168.200.1";
    localAddress = "192.168.200.12";

    bindMounts = {
      "/persistent_store/" = {
        hostPath = "/pool0/mosquitto/";
        isReadOnly = false;
      };
    };

    forwardPorts = [{
      containerPort = 1883;
      hostPort = 1883;
      protocol = "tcp";
    }];

    config = { lib, ... }: {
      services.mosquitto = {
        enable = true;
        persistence = true;
        dataDir = "/persistent_store/data/";
        logDest = [ "syslog" ];
        logType = [ "error" "warning" "information" ];

        listeners = [{
          acl = [ "pattern readwrite #" ];
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
        }];

        settings.persistence_location = "/persistent_store/mosquitto.db";
      };

      system.stateVersion = "24.05";

      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [ 1883 9001 ];
        };
        useHostResolvConf = lib.mkForce false;
      };

      services.resolved.enable = true;
    };
  };
}
