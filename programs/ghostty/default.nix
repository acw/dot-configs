{ config, pkgs, ... }:
{

  programs.ghostty.enable = !pkgs.stdenv.isDarwin;

  home.file = {
    ".config/ghostty/config".text = ''
    background = 000000
    background-opacity = 0.85
    font-family = "Cousine Nerd Font Mono"
    font-size = 14
    '';
  };
}
