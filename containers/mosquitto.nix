{ config, ... }:

{
  users = {
    groups.mosquitto.gid = config.ids.gids.mosquitto;
    users.mosquitto = {
      isSystemUser = true;
      group = "mosquitto";
      uid = config.ids.uids.mosquitto;
    };
  };

  containers.mosquitto = {
    config =
      { lib, ... }:
      {
        users = {
          groups.mosquitto.gid = config.ids.gids.mosquitto;
          users.mosquitto = {
            isSystemUser = true;
            group = "mosquitto";
            uid = config.ids.uids.mosquitto;
          };
        };

        services.mosquitto = {
          enable = false;
          persistence = true;
          dataDir = "/persistent_store/data/";
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

          settings.persistence_location = "/persistent_store/mosquitto.db";
        };

        system.stateVersion = "24.05";

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 1883 ];
          };
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;
      };
  };
}
