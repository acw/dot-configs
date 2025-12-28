{ ... }:

{
  # Basic info
  home.username = "awick";
  home.homeDirectory = "/home/awick";

  imports = [
    ../profiles/standard.nix
  ];

  home.stateVersion = "23.11"; # Please read the comment before changing.

  programs.home-manager.enable = true;
  programs.zsh.enable = true;
}
