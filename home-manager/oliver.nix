{ pkgs, ... }:

{
  # Basic info
  home.username = "awick";
  home.homeDirectory = "/home/awick";

  nixpkgs.config.allowUnfree = true;

  imports = [
    ../programs/alacritty
    ../programs/ghostty
    ../programs/wezterm

    ../profiles/programming.nix
    ../profiles/standard.nix
  ];

  home.stateVersion = "23.11";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    aider-chat-full
    alsa-plugins
    awscli2
    claude-code
    docker-credential-helpers
    google-cloud-sdk
    gnupg
    pass
    pipewire
    pulseaudio
    fastly
    lld
    vault
    wireshark
  ];

  fonts.fontconfig.enable = true;
  programs.spotify-player.enable = true;

  programs.home-manager.enable = true;
  programs.zsh.enable = true;
}
