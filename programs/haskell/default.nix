{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.cabal-install
    pkgs.ghc
  ];
}
