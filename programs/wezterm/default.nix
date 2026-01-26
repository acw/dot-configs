{ pkgs, config, ... }:
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    package = if pkgs.stdenv.isDarwin then pkgs.wezterm else config.lib.nixGL.wrapOffload pkgs.wezterm;
  };

  home.file.".config/wezterm/wezterm.lua" = {
    source = ./wezterm.lua;
    recursive = false;
  };
}
