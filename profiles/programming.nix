{ pkgs, ... }:

{
  imports = [
    ../programs/clang
    ../programs/go
    ../programs/haskell
    ../programs/rust
  ];

  home.packages = with pkgs; [
    aider-chat-full
    cmake
    gh
    nixfmt-rfc-style
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
  };
}
