{ pkgs, ... }:

{
  imports =
    [ ../programs/clang ../programs/go ../programs/haskell ../programs/rust ];

  home.packages = with pkgs; [ lean4 nixfmt-rfc-style ];
}
