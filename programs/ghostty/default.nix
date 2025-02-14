{ config, pkgs, lib, ... }:
{
  programs.ghostty = lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
    package = config.lib.nixGL.wrapOffload pkgs.ghostty;
  };


  home.file = {
    ".config/ghostty/config".text = ''
    background = 000000
    background-opacity = 0.85
    font-family = "Cousine Nerd Font Mono"
    font-size = 14

    term = xterm-256color
    '';
  };
}
