{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override{
      fonts = ["FiraCode" "RobotoMono"];
    })
  ];

  programs.alacritty = {
    enable = true;

    settings.font.size = pkgs.lib.mkDefault 13;

    # I'd love to figure out how to auto patch and
    # install M+2 Propo and Coisine, as alternatives
    settings.font.normal = pkgs.lib.mkDefault {
      family = "RobotoMono Nerd Font";
      style = "Regular";
    };
    settings.font.bold = pkgs.lib.mkDefault {
      family = "RobotoMono Nerd Font";
      style = "Bold";
    };
    settings.font.italic = pkgs.lib.mkDefault {
      family = "RobotoMono Nerd Font";
      style = "Italic";
    };
    settings.font.bold_italic = pkgs.lib.mkDefault {
      family = "RobotoMono Nerd Font";
      style = "Bold Italic";
    };

    settings.window.opacity = 0.95;
    settings.window.blur = true;
  };
}
