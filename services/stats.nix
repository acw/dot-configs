{ config, ... }:

{
  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3535;
        domain = "data.uhsure.com";
        root_url = "https://data.uhsure.com";
      };
    };
    dataDir = "/pool0/grafana";
  };

  services.prometheus = {
    enable = true;

    globalConfig.scrape_interval = "15s";
    scrapeConfigs = [
      {
        job_name = "prometheus";
        honor_timestamps = true;
        scrape_timeout = "10s";
        metrics_path = "/metrics";

        static_configs = [{
          targets = [
            "dunworthy.tail9414b.ts.net:${toString config.services.prometheus.exporters.node.port}"
            "http-origin.tail9414b.ts.net:9100"
            "home.tail9414b.ts.net:9000"
          ];
        }];
      }

      {
        job_name = "tailscale";
        honor_timestamps = true;
        scrape_timeout = "10s";
        metrics_path = "/metrics";

        static_configs = [{
          targets = [
            "dunworthy.tail9414b.ts.net:5252"
            "http-origin.tail9414b.ts.net:5252"
            "home.tail9414b.ts.net:5252"
            "ergates.tail9414b.ts.net:5252"
            "gaming.tail9414b.ts.net:5252"
            "victorismacbook.tail9414b.ts.net:5252"
          ];
        }];
      }

      {
        job_name = "nginx";
        honor_timestamps = true;
        scrape_timeout = "10s";
        metrics_path = "/metrics";

        static_configs = [{
          targets = [
            "dunworthy.tail9414b.ts.net:9113"
          ];
        }];
      }

      {
        job_name = "postgres";
        honor_timestamps = true;
        scrape_timeout = "10s";
        metrics_path = "/metrics";

        static_configs = [{
          targets = [
            "dunworthy.tail9414b.ts.net:9187"
          ];
        }];
      }

      {
        job_name = "zfs";
        honor_timestamps = true;
        scrape_timeout = "10s";
        metrics_path = "/metrics";

        static_configs = [{
          targets = [
            "dunworthy.tail9414b.ts.net:9134"
          ];
        }];
      }
    ];

    exporters.node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      extraFlags = [ "--collector.ethtool" "--collector.softirqs" "--collector.tcpstat" ];
    };

    exporters.nginx.enable = true;
    exporters.postgres.enable = true;
    exporters.zfs.enable = true;
  };
  systemd.tmpfiles.rules = [
    "D /pool0/prometheus 0751 prometheus prometheus - -"
    "L+ /var/lib/prometheus2/data - - - - /pool0/prometheus"
  ];

  services.nginx.virtualHosts."data.uhsure.com" = {
    extraConfig = "
      proxy_http_version 1.1;
      proxy_set_header Connection $http_connection;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-Protocol $scheme;
      client_max_body_size 512M;
    ";

    locations."/" = {
      proxyPass = "http://127.0.0.1:3535";
    };
  };
}
