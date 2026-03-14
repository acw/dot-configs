inputs: pkgs:
{
  user ? "awick",
  use,
  gui ? false,
}:

let
  optionalPackages = condition: packageList: if condition then packageList else [ ];
in
{
  home-manager.sharedModules = [ inputs.agenix.homeManagerModules.default ];
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    systemUse = use;
  };

  home-manager.users.${user} = {
    home.username = "${user}";
    home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}";

    imports = [
      ../programs/neovim
      ../programs/tmux
      ../programs/zsh
      # it may seem strange to have wezterm here, but I want it installed on
      # servers so that SshDomain stuff works well.
      ../programs/wezterm
    ]
    ++ optionalPackages gui [
      ../programs/alacritty
      ../programs/ghostty
      ../programs/kitty
    ]
    ++ optionalPackages (gui && pkgs.stdenv.isLinux) [
      ../programs/nixGL
    ]
    ++ optionalPackages (use != "infrastructure") [
      ../programs/clang
      ../programs/claude
      ../programs/go
      ../programs/gpg
      ../programs/haskell
      ../programs/nixfmt
      ../programs/rust
    ];

    home.stateVersion = "23.11";
    home.packages =
      with pkgs;
      [
        age
        git
        unixtools.watch
        which
      ]
      ++ optionalPackages (use == "personal") [
        nmap
        yt-dlp
        zola
      ]
      ++ optionalPackages (use == "work") [
        awscli2
        docker-credential-helpers
        google-cloud-sdk
        nodejs
        pass
        vault
      ]
      ++ optionalPackages ((use == "work") && gui) [
        alsa-plugins
        pipewire
        pulseaudio
        wireshark
      ]
      ++ optionalPackages (use != "infrastructure") [
        _1password-cli
        btop
        calc
        fastly
        gh
        jq
        pv
        ripgrep
        tokei
        unixtools.xxd
        zstd
      ];

    fonts.fontconfig.enable = gui;

    programs.git.enable = true;
    programs.git.lfs.enable = true;
    programs.home-manager.enable = true;
    programs.nh = {
      enable = true;
      clean.enable = true;
    };
    programs.zsh.enable = true;
  };
}
