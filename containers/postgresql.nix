{ config, ... }:

{
  users = {
    groups.postgres.gid = config.ids.gids.postgres;
    users.postgres = {
      isSystemUser = true;
      group = "postgres";
      uid = config.ids.uids.postgres;
    };
  };

  containers.postgresql = {
    autostart = true;
    ephemeral = true;
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

    config =
      { lib, ... }:
      {
        services.postgresql = {
          enable = true;
          dataDir = "/persistent_store/data";
          enableJIT = true;

          settings = {
            fsync = true;

            log_destination = lib.mkForce "syslog";
          };
        };

        system.stateVersion = "24.05";

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ ];
          };
          useHostResolvConf = lib.mkForce false;
        };
      };
  };
}
