{ pkgs, ... }:

{
#  environment.systemPackages = [
#    pkgs.sillytavern
#  ];

  users.groups.sillytavern = {};
  users.users.sillytavern = {
    isSystemUser = true;
    group = "sillytavern";
  };
}
