{ config, pkgs, ... }:

{
  # Basic info
  home.username = "adamwick";
  home.homeDirectory = "/Users/adamwick";

  imports = [
    ../programs/alacritty
    ../programs/ghostty
#    ../programs/kitty
    ../programs/wezterm

    ../profiles/standard.nix
    ../profiles/programming.nix
  ];

  sops = {
    defaultSecretsMountPoint = "%r/secrets.d";
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/Users/adamwick/.config/sops/age/keys.txt";
      generateKey = false;
    };

    secrets = {
      openrouter_api_key = {
        sopsFile = ../secrets/personal_ai.yaml;
      };
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
#    fastly
    nmap
    reattach-to-user-namespace
    sops
    spotify-player
    zstd
    zola
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".cargo/config.toml".text = ''
      [env]
      CC = "/usr/bin/cc"
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/awick/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = { };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zsh.enable = true;
}
