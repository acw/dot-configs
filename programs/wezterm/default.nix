{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
  ];

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    package =
      if pkgs.stdenv.isDarwin then
        pkgs.wezterm
      else
        config.lib.nixGL.wrapOffload pkgs.wezterm;

    extraConfig = ''
      return {
        font = wezterm.font("Cousine Nerd Font Mono"),
        font_size = 14.0,
        hide_tab_bar_if_only_one_tab = true,
        window_background_opacity = 0.9,
      }
    '';
  };
}
