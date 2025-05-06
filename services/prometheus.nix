{ config, ... }:

{
  fileSystems."/var/lib/prometheus2" = {
    depends = [ "/pool0" ];
    device = "/pool0/prometheus";
    fsType = "none";
    options = [ "bind" ];
  };

  services.prometheus = {
    enable = true;

    globalConfig.scrape_interval = "15s";
    stateDir = "prometheus2";

    scrapeConfigs = [
      {
        job_name = "prometheus";
        scrape_timeout = "10s";
        metrics_path = "/metrics";

        static_configs = [
          {
            targets = [
              "dunworthy.tail9414b.ts.net:${toString config.services.prometheus.exporters.node.port}"
              "http-origin.tail9414b.ts.net:9100"
              "home.tail9414b.ts.net:9000"
            ];
          }
        ];
      }

      {
        job_name = "tailscale";
        honor_timestamps = true;
        scrape_timeout = "10s";
        metrics_path = "/metrics";

        static_configs = [
          {
            targets = [
              "dunworthy.tail9414b.ts.net:5252"
              "http-origin.tail9414b.ts.net:5252"
              "home.tail9414b.ts.net:5252"
              "ergates.tail9414b.ts.net:5252"
              "gaming.tail9414b.ts.net:5252"
              "victorismacbook.tail9414b.ts.net:5252"
            ];
          }
        ];
      }

      {
        job_name = "nginx";
        honor_timestamps = true;
        scrape_timeout = "10s";
        metrics_path = "/metrics";

        static_configs = [
          {
            targets = [
              "dunworthy.tail9414b.ts.net:9113"
            ];
          }
        ];
      }

      {
        job_name = "postgres";
        honor_timestamps = true;
        scrape_timeout = "10s";
        metrics_path = "/metrics";

        static_configs = [
          {
            targets = [
              "dunworthy.tail9414b.ts.net:9187"
            ];
          }
        ];
      }

      {
        job_name = "zfs";
        honor_timestamps = true;
        scrape_timeout = "10s";
        metrics_path = "/metrics";

        static_configs = [
          {
            targets = [
              "dunworthy.tail9414b.ts.net:9134"
            ];
          }
        ];
      }
    ];

  };

  services.nginx.virtualHosts."data.uhsure.com" = {
    extraConfig = "
      proxy_http_version 1.1;
      proxy_set_header Connection $http_connection;
      proxy_set_header Upgrade $http_upgrade;
      client_max_body_size 512M;
    ";

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
    };
  };
}
