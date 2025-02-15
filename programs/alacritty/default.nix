{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
  ];

  programs.alacritty = {
    enable = true;
    settings.font.size = pkgs.lib.mkDefault 14;

    package =
      if pkgs.stdenv.isDarwin then
        pkgs.alacritty
      else
        config.lib.nixGL.wrapOffload pkgs.alacritty;

    # I'd love to figure out how to auto patch and
    # install M+2 Propo and Coisine, as alternatives
    settings.font.normal = pkgs.lib.mkDefault {
      family = "Cousine Nerd Font Mono";
      style = "Regular";
    };
    settings.font.bold = pkgs.lib.mkDefault {
      family = "Cousine Nerd Font Mono";
      style = "Bold";
    };
    settings.font.italic = pkgs.lib.mkDefault {
      family = "Cousine Nerd Font Mono";
      style = "Italic";
    };
    settings.font.bold_italic = pkgs.lib.mkDefault {
      family = "Cousine Nerd Font Mono";
      style = "Bold Italic";
    };

    settings.window.opacity = 0.95;
    settings.window.blur = true;
  };
}
