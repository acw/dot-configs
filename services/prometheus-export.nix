{ config, ... }:

{
  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];

      extraFlags = [
        "--collector.ethtool"
        "--collector.softirqs"
        "--collector.tcpstat"
      ];
    };

    nginx.enable = config.services.nginx.enable;
    postgres = {
      enable = config.services.postgresql.enable;
      user = "postgres";
    };

    zfs.enable = true;
  };
}
