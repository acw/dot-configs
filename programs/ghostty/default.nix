{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.ghostty = lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
    package = config.lib.nixGL.wrapOffload pkgs.ghostty;
  };

  home.file = {
    ".config/ghostty/config".text = ''
      background = ffffff
      background-opacity = 0.95
      foreground = 000000
      font-family = "Cousine Nerd Font Mono"
      font-family-bold = "Cousine Nerd Font Mono Bold"
      font-size = 14

      term = xterm-256color
    '';
  };
}
