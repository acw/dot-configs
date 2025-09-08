{ pkgs, ... }:

let
  kiwix_port = "9210";
in
{
  environment.systemPackages = with pkgs; [
    kiwix-tools
  ];

  systemd.services.kiwix = {
    enable = true;
    description = "Kiwix local wiki server";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/sh -c \"${pkgs.kiwix-tools}/bin/kiwix-serve --port=${kiwix_port} /pool0/kiwix/*.zim\"";
      User = "kiwix";
    };
  };

  services.nginx.virtualHosts."kb.uhsure.com" = {
    serverAliases = [ "kiwix.uhsure.com" ];

    locations."/" = {
      proxyPass = "http://127.0.0.1:${kiwix_port}";
      proxyWebsockets = false;
      extraConfig = "proxy_redirect default;";
    };
  };

  users = {
    users.kiwix = {
      isSystemUser = true;
      group = "kiwix";
    };

    groups.kiwix = { };
  };
}
