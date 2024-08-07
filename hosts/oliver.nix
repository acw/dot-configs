{ config, pkgs, ... }:

let
  nixGLWrap = import ../lib/nixgl.nix { inherit pkgs; };
in {
  # Basic info
  home.username = "awick";
  home.homeDirectory = "/home/awick";

  nixpkgs.config.allowUnfree = true;

  imports = [
    ../programs/alacritty
    ../programs/haskell
    ../programs/neovim
    ../programs/rust
    ../programs/tmux
    ../programs/wezterm
    ../programs/zsh
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
  #programs.alacritty.package = nixGLWrap "alacritty" pkgs.alacritty;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs._1password
    pkgs.btop
    pkgs.calc
    pkgs.clang
    pkgs.docker-credential-helpers
    pkgs.git
    pkgs.gnupg
    pkgs.lean4
    pkgs.pass
    pkgs.ripgrep
    pkgs.spotify-player
    pkgs.tmux
    pkgs.fastly
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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
  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
  programs.zsh.enable = true;
}
