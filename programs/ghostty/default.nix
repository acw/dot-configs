{
  config,
  pkgs,
  lib,
  ...
}:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.geist-mono
    nerd-fonts.lilex
  ];

  programs.ghostty = lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
    #package = config.lib.nixGL.wrapOffload pkgs.ghostty;
  };

  home.file = {
    ".config/ghostty/config".text = ''
      background = 000000
      background-opacity = 0.75
      background-blur = 20
      foreground = eeeeee
      font-family = "GeistMono Nerd Font Mono"
      font-size = 15

      term = xterm-256color
    '';
  };
}
