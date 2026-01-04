{ pkgs, config, ... }:
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    package = if pkgs.stdenv.isDarwin then
      pkgs.wezterm
    else
      config.lib.nixGL.wrapOffload pkgs.wezterm;

    extraConfig = ''
      local wezterm = require "wezterm";
      local config = {}

      config.font = wezterm.font("GeistMono Nerd Font Mono")
      config.font_size = 14

      config.hide_tab_bar_if_only_one_tab = false

      config.window_background_opacity = 0.9

      config.leader = {
        key = "b",
        mods = "CTRL",
        timeout_milliseconds = 500,
      }

      config.keys = {
        { mods = "LEADER", key = "c", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
        { mods = "LEADER", key = "x", action = wezterm.action.CloseCurrentPane { confirm = true } },
        { mods = "LEADER", key = "b", action = wezterm.action.ActivateTabRelative(-1) },
        { mods = "LEADER", key = "o", action = wezterm.action.ActivateTabRelative(1) },
        { mods = "LEADER", key = "v", action = wezterm.action.SplitHorizontal{ domain = "CurrentPaneDomain" } },
        { mods = "LEADER", key = "s", action = wezterm.action.SplitVertical{ domain = "CurrentPaneDomain" } },

      }

      return config
    '';
  };
}
