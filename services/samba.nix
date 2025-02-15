{ pkgs, ... }:

let
  backups_gid = 3001;
in
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;

    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };

    extraServiceFiles = {
      ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
      smb = ''
        <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
        </service-group>
      '';
    };
  };

  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        workgroup = "WICKHOUSE";
        "server string" = "The Wick Data Store";
        "server role" = "standalone server";
        "smb encrypt" = "desired";
        "server smb encrypt" = "required";
        "server min protocol" = "SMB3_00";
        deadtime = 30;
        "use sendfile" = "yes";
        security = "user";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };

      timemachine = {
        comment = "Time Machine";
        path = "/pool0/backups";
        browseable = "yes";
        writeable = "yes";
        "create mask" = "0660";
        "directory mask" = "0770";
        "spotlight" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
        "force group" = "backups";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
      };

      av = {
        comment = "AV Files";
        path = "/pool0/av";
        browseable = "yes";
        writeable = "yes";
        "create mask" = "0660";
        "directory mask" = "0770";
        "spotlight" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "force group" = "av";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  users.groups.backups.gid = backups_gid;
}
