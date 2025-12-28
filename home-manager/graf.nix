{ pkgs, ... }:

{
  home.username = "awick";
  home.homeDirectory = "/home/awick";

  imports = [
    ../profiles/programming.nix
    ../profiles/standard.nix

    ../programs/gpg
  ];

  home.stateVersion = "23.11";

  home.packages = [
    pkgs.awscli2
    pkgs.docker-credential-helpers
    pkgs.fastly
    pkgs.nodejs
    pkgs.pass
    pkgs.which
  ];

  programs.home-manager.enable = true;
  programs.zsh.enable = true;
}
