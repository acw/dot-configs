{ pkgs, ... }:

let
  sillytavern_port = "9939";
in
{
  environment.systemPackages = [
    pkgs.sillytavern
  ];

  users.groups.sillytavern = { };
  users.users.sillytavern = {
    isSystemUser = true;
    group = "sillytavern";
  };

  systemd.services.sillytavern = {
    enable = true;
    description = "SillyTavern AI Chat Server";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    environment = {
      XDG_DATA_HOME="/pool0/ai/sillytavern";
    };

    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/sh -c \"${pkgs.sillytavern}/bin/sillytavern --listen --port ${sillytavern_port}\"";
      User = "sillytavern";
    };
  };

  services.nginx.virtualHosts."tavern.ai.uhsure.com" = {
    extraConfig = "
      send_timeout 7200s;
      client_header_timeout 7200s;
      client_body_timeout 7200s;
    ";

    locations."/" = {
      proxyPass = "http://127.0.0.1:${sillytavern_port}";
      proxyWebsockets = false;
      extraConfig = "
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $http_connection;
        proxy_http_version 1.1;
        proxy_redirect default;
        proxy_read_timeout 3600s;
        proxy_connect_timeout 3600s;
        proxy_send_timeout 3600s;
      ";
    };
  };
}
