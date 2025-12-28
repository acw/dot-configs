{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnupg
    pinentry-curses
  ];

  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;

    extraConfig = ''
      pinentry-program ${pkgs.pinentry-curses}/bin/pinentry-curses
    '';
  };
}
