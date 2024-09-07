{ ... }:

{
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';

  containers.samba = {
    config = { lib, ... }: {
      services.samba = {
        enable = true;
        securityType = "user";
        openFirewall = true;

        extraConfig = ''
          workgroup = WICKHOUSE
          server string = The Wick Data Store
          server role = standalone server
          smb encrypt = desired
          deadtime = 30
          use sendfile = yes
        '';

        shares = {
          timemachine = {
            comment = "Time Machine";
            path = "/persistent_store/backups";
            public = "no";
            writeable = "yes";
            "create mask" = "0600";
            "directory mask" = "0700";
            "spotlight" = "yes";
            "vfs objects" = "catia fruit streams_xattr";
            "force user" = "username";
            "fruit:aapl" = "yes";
            "fruit:time machine" = "yes";
          };

          av = {
            comment = "AV Files";
            path = "/persistent_store/av";
            browseable = "yes";
            writeable = "yes";
            "create mask" = "0600";
            "directory mask" = "0700";
            "public" = "yes";
            "spotlight" = "yes";
            "vfs objects" = "catia fruit streams_xattr";
            "fruit:aapl" = "yes";
          };
        };
      };

      services.samba-wsdd = {
        enable = true;
        openFirewall = true;
      };

      system.stateVersion = "24.05";

      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [ 139 445 ];
          allowedUDPPorts = [ 137 138 ];
        };
        useHostResolvConf = lib.mkForce false;
      };

      services.resolved.enable = true;
    };
  };
}
