{ config, ... }:

{
  services.gitea = {
    enable = true;
    appName = "UhSure Git Repositories";

    database.type = "postgres";
    database.createDatabase = true;

    settings.server = {
      DOMAIN = "git.uhsure.com";
      ROOT_URL = "http://git.uhsure.com";
      HTTP_PORT = 3021;
    };
  };

  services.nginx.virtualHosts."git.uhsure.com" = {
    extraConfig = "
        proxy_set_header Connection $http_connection;
        proxy_set_header Upgrade $http_upgrade;
        client_max_body_size 512M;
      ";

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.gitea.settings.server.HTTP_PORT}";
    };
  };
}
