{ pkgs, ... }:

let
  kiwix_id = 2001;
in
{
  systemd.services.kiwix = {
    enable = true;
    description = "Kiwix local wiki server";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/sh -c \"${pkgs.kiwix-tools}/bin/kiwix-serve --port=8080 /pool0/kiwix/*.zim\"";
      User = "kiwix";
    };
  };

  services.nginx.virtualHosts."kb.uhsure.com" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
      proxyWebsockets = false;
      extraConfig = "proxy_redirect default;";
    };
  };

  users = {
    users.kiwix = {
      isSystemUser = true;
      group = "kiwix";
      uid = kiwix_id;
    };

    groups.kiwix.gid = kiwix_id;
  };
}
