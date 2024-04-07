{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nerdfonts
  ];

  programs.alacritty = {
    enable = true;

    settings.font.size = pkgs.lib.mkDefault 13;

    settings.font.normal = pkgs.lib.mkDefault {
      family = "Coisine Nerd Font";
      style = "Regular";
    };
  };
}
