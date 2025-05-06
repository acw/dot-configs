{ ... }:

{
  services.mosquitto = {
    enable = true;
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
        port = 1883;
      }
    ];

    settings.persistence_location = "/pool0/mosquitto/data";
  };
}
