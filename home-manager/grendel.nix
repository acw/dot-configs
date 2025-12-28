{ ... }:

{
  home.username = "awick";
  home.homeDirectory = "/home/awick";

  imports = [
    ../profiles/standard.nix
  ];

  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zsh.enable = true;
}
