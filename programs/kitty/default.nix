{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "FiraCode Nerd Font Mono";
      size = 14;
    };

    settings = {
      macos_option_as_alt = "yes";
    };
  };
}
