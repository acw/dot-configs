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
    lean4
    nixfmt-rfc-style
  ];
}
