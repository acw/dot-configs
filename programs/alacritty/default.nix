{ pkgs, stdenv, ... }:

let
  wrapper =
    pkg:
    pkgs.runCommand "${pkg.name}-wrapped" { } ''
      mkdir $out
      ln -s ${pkg}/* $out
      rm $out/bin
      mkdir $out/bin
      for bin in ${pkg}/bin/*; do
        wrapped_bin=$out/bin/$(basename $bin)
        echo "export LD_LIBRARY_PATH=/usr/lib:${pkgs.mesa}/lib:${pkgs.libglvnd}/lib:${pkgs.mesa.drivers}/lib" > $wrapped_bin
        echo "export LIBGL_DRIVERS_PATH=${pkgs.mesa.drivers}/lib/dri" >> $wrapped_bin
        echo "exec ${pkgs.alacritty}/bin/alacritty \"\$@\"" >> $wrapped_bin
        chmod +x $wrapped_bin
      done
    '';
in
{
  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "RobotoMono"
      ];
    })
  ];

  programs.alacritty = {
    enable = true;
    settings.font.size = pkgs.lib.mkDefault 13;

    package = if pkgs.stdenv.isDarwin then pkgs.alacritty else wrapper pkgs.alacritty;

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
