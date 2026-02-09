{ pkgs, ... }:

{
  services.home-assistant = {
    enable = true;
    package =
      (pkgs.home-assistant.override {
        extraPackages = py: with py; [ psycopg2 ];
      }).overrideAttrs
        (oldAttrs: {
          doInstallCheck = false;
        });

    extraComponents = [
      "apple_tv"
      "august"
      "enphase_envoy"
      "esphome"
      "homekit"
      "homekit_controller"
      "hue"
      "ipp"
      "lutron"
      "lutron_caseta"
      "met"
      "mqtt"
      "nanoleaf"
      "radio_browser"
      "tasmota"
      #      "tradfri"
      "unifi"
      "unifiprotect"
    ];

    configDir = "/pool0/home-assistant";
    config = {
      default_config = { };
      http = {
        server_host = "::1";
        trusted_proxies = [ "::1" ];
        use_x_forwarded_for = true;
      };
      recorder.db_url = "postgresql://@/hass";
    };
  };

  services.nginx.virtualHosts."hass.uhsure.com" = {
    extraConfig = "
      proxy_buffering off;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
    ";

    locations."/" = {
      proxyPass = "http://[::1]:8123";
      proxyWebsockets = true;
    };
  };
}
