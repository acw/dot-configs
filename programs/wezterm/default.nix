{ pkgs, ... }:

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
        echo "exec ${pkgs.wezterm}/bin/wezterm \"\$@\"" >> $wrapped_bin
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

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    package = if pkgs.stdenv.isDarwin then pkgs.wezterm else wrapper pkgs.wezterm;

    extraConfig = ''
      return {
        font = wezterm.font("FiraCode Nerd Font"),
        font_size = 13.0,
        hide_tab_bar_if_only_one_tab = true,
        window_background_opacity = 0.9,
      }
    '';
  };
}
