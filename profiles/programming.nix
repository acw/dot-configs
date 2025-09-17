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
    claude-code
    cmake
    gh
    nixfmt-rfc-style
    nixfmt-tree
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
  };
}
