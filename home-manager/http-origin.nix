{ ... }:

{
  home.username = "awick";
  home.homeDirectory = "/home/awick";

  imports = [
    ../profiles/standard.nix
  ];

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
  programs.zsh.enable = true;
}
