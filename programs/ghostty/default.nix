{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    (if pkgs.stdenv.isDarwin then pkgs.ghostty else config.lib.nixGL.wrapOffload pkgs.ghostty)
  ];

  home.file = {
    ".config/ghostty/config".text = ''
    background = 000000
    background-opacity = 0.85
    font-family = "Cousine Nerd Font Mono"
    font-size = 14
    '';
  };
}
