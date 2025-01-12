{ pkgs, ... }:

{
  imports = [
    ../programs/clang
    ../programs/go
    ../programs/haskell
    ../programs/rust
  ];

  home.packages = with pkgs; [
    gh
    nixfmt-rfc-style
  ];
}
