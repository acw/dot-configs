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
      }
    ];
    settings = {
      fsync = true;
      log_connections = true;
      log_destination = lib.mkForce "syslog";
    };
  };
}
