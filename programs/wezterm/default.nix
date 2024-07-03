{ pkgs, ... }:

let
  nixGL = import <nixgl> {};
in
{
  home.packages = with pkgs; [
    (nerdfonts.override{
      fonts = ["FiraCode" "RobotoMono"];
    })
    nixGL.auto.nixGLNvidia
    nixGL.auto.nixVulkanNvidia
    nixGL.nixGLIntel
    nixGL.nixVulkanIntel
  ];

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    package = pkgs.writeShellScriptBin "wezterm" ''
      #!/bin/sh

      ${nixGL.auto.nixGLNvidia}/bin/nixGLNvidia-550.90.07 ${pkgs.wezterm}/bin/wezterm "$@"
    '';

    extraConfig = ''
      return {
        font = wezterm.font("FiraCode Nerd Font"),
        font_size = 14.0,
        hide_tab_bar_if_only_one_tab = true,
        window_background_opacity = 0.9,
      }
    '';
  };
}
