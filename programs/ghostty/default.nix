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
    package = config.lib.nixGL.wrapOffload pkgs.ghostty;
  };

  home.file = {
    ".config/ghostty/config".text = ''
      background = ffffff
      background-opacity = 0.95
      foreground = 000000
      font-family = "GeistMono Nerd Font Mono"
      font-size = 14

      term = xterm-256color
    '';
  };
}
