{ config, ... }:

{
  services.gitea = {
    enable = true;
    appName = "UhSure Git Repositories";

    database.type = "postgres";
    database.createDatabase = true;
    lfs.enable = true;
    stateDir = "/pool0/gitea";

    settings.server = {
      DISABLE_SSH = false;
      DOMAIN = "git.uhsure.com";
      ROOT_URL = "http://git.uhsure.com";
      HTTP_PORT = 3021;
      SSH_PORT = 22;
    };

    # NOTE: If you ever have to completely reset this again, such
    # that user information is lost, you'll need to comment this one
    # out until you can establish an administrator
    settings.service = {
      DISABLE_REGISTRATION = true;
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

  services.openssh.settings.AllowUsers = [ "gitea" ];
}
