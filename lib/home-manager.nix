inputs: pkgs:
{
  user ? "awick",
  use,
  gui ? false,
}:

let optionalPackages = condition: packageList:
      if condition then packageList else [];
in
{
  home-manager.sharedModules = [ inputs.agenix.homeManagerModules.default ];
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    systemUse = use;
  };

  home-manager.users.${user} = {
    home.username = "${user}";
    home.homeDirectory = "/Users/adamwick"; # FIXME

    imports = [
      ../programs/gpg
      ../programs/neovim
      ../programs/tmux
      ../programs/zsh
    ] ++ optionalPackages gui [
      ../programs/alacritty
      ../programs/ghostty
      ../programs/kitty
      ../programs/wezterm
    ] ++ optionalPackages (gui && pkgs.stdenv.isLinux) [
      ../programs/nixGL
    ] ++ optionalPackages (use != "infrastructure") [
      ../programs/clang
      ../programs/claude
      ../programs/go
      ../programs/haskell
      ../programs/nixfmt
      ../programs/rust
    ];

    home.stateVersion = "23.11";
    home.packages = with pkgs; [ # FIXME
      _1password-cli
      age
      btop
      calc
      git
      jq
      ripgrep
      unixtools.watch
      unixtools.xxd
      which
      zstd
    ] ++ optionalPackages (use == "personal") [
      nmap
      yt-dlp
      zola
    ] ++ optionalPackages (use == "work") [
      awscli2
      docker-credential-helpers
      nodejs
      pass
      vault
    ] ++ optionalPackages ((use == "work") && gui) [
      alsa-plugins
      pipewire
      pulseaudio
      wireshark
    ] ++ optionalPackages (use != "infrastructure") [
      fastly
      gh
    ];

    fonts.fontconfig.enable = gui;
    programs.spotify-player.enable = gui;

    programs.home-manager.enable = true;
    programs.zsh.enable = true;
  };
}
