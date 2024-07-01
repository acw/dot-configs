{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override{
      fonts = ["FiraCode" "RobotoMono"];
    })
  ];

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
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
