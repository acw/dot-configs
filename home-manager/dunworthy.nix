{ pkgs, ... }:

{
  # Basic info
  home.username = "awick";
  home.homeDirectory = "/home/awick";

  imports = [
    ../profiles/standard.nix
    ../profiles/programming.nix
  ];

  home.stateVersion = "23.11";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nmap
    python3
    yt-dlp
    zola
  ];

  programs.home-manager.enable = true;
  programs.zsh.enable = true;
}
