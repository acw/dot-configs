{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    homebridge
    homebridge-config-ui-x
  ];

  services.homebridge = {
    enable = true;

    openFirewall = true;
    userStoragePath = "/pool0/homebridge";
    uiSettings = {
      port = 9092;
    };
  };
}
