{ lib, ... }:

{
  services.postgresql = {
    enable = true;
    dataDir = "/pool0/postgres";
    enableJIT = true;
    enableTCPIP = false;

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
        ensureClauses = {
          createdb = true;
        };
      }
    ];

    settings = {
      fsync = true;
      listen_addresses = lib.mkForce "";
      log_connections = false;
      log_destination = lib.mkForce "syslog";
    };
  };
}
