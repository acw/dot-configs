{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override{
      fonts = ["FiraCode"];
    })
  ];

  programs.alacritty = {
    enable = true;

    settings.font.size = pkgs.lib.mkDefault 13;

    # I'd love to figure out how to auto patch and
    # install M+2 Propo and Coisine, as alternatives
    settings.font.normal = pkgs.lib.mkDefault {
      family = "FiraCode Nerd Font";
      style = "Regular";
    };
  };
}
