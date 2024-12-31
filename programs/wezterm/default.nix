{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
  ];

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    package = if pkgs.stdenv.isDarwin then pkgs.wezterm else config.lib.nixGL.wrapOffload pkgs.wezterm;

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
