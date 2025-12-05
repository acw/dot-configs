{ config, ... }:

let gitea_port = 3021;
    define_runner = num: {
      autoStart = true;
      restartIfChanged = true;
      privateNetwork = true;
      privateUsers = "pick";
      hostBridge = "giteabr0";
      localAddress = "192.168.99.1${toString num}/24";

      config = { lib, pkgs, ... }: rec {
        services.gitea-actions-runner.instances.runner0 = {
          enable = true;
          name = "Local Runner #${toString num}";
          url = "http://192.168.2.92:${toString gitea_port}/";
          labels = [ "x86_64-linux" "native:host" ];
          tokenFile = config.age.secrets.gitea_runner_token.path;
          settings = {
            cache.enabled = true;
            log.level = "debug";
            runner.envs.PATH = "/run/current-system/sw/bin"; 
          };
          
          hostPackages = with pkgs; [
            bash
            clang
            coreutils
            curl
            gawk
            git
            gnused
            nodejs_20
            nodejs
            rustup
            wget
          ];
        };

        environment.systemPackages = services.gitea-actions-runner.instances.runner0.hostPackages;

        system.stateVersion = "23.11";
        networking.defaultGateway = "192.168.99.1";
        networking.firewall.enable = true;
        networking.useHostResolvConf = lib.mkForce false;
        services.resolved.enable = true;
        users.users."gitea-runner" = {
          isNormalUser = true;
          group = "users";
        };
      };
    };
in
{
  age.secrets.gitea_runner_token = {
    file = ../data/gitea_runner_token.age;
  };

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
      HTTP_PORT = gitea_port;
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

  systemd.network = {
    netdevs = {
      "31-gitea-worker-bridge0" = {
        bridgeConfig.STP = true;
        enable = true;

        netdevConfig = {
          Kind = "bridge";
          Name = "giteabr0";
        };
      };
    };

    networks = {
      "33-gitea-host-network" = {
        matchConfig.Name = "giteabr0";
        address = [
          "192.168.99.1/24"
        ];

        networkConfig = {
          "IPv4Forwarding" = "yes";
          "IPv6Forwarding" = "yes";
          "IPMasquerade" = "yes";
        };
        
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  containers.gitea-runner0 = define_runner 0;
  containers.gitea-runner1 = define_runner 1;
  containers.gitea-runner2 = define_runner 2;
  containers.gitea-runner3 = define_runner 3;
  containers.gitea-runner4 = define_runner 4;
  containers.gitea-runner5 = define_runner 5;
  containers.gitea-runner6 = define_runner 6;
  containers.gitea-runner7 = define_runner 7;
  containers.gitea-runner8 = define_runner 8;
  containers.gitea-runner9 = define_runner 9;

  networking.firewall.interfaces."giteabr0" = {
    allowedTCPPorts = [ gitea_port ];
  };
}
