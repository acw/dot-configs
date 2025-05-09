{ pkgs, ... }:

{
  imports = [
    ../programs/clang
    ../programs/go
    ../programs/haskell
    ../programs/rust
  ];

  home.packages = with pkgs; [
    cmake
    gh
    nixfmt-rfc-style
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
  };
}
