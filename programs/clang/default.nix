{ pkgs, ... }:

{
  home.packages = with pkgs; [
    autoconf
    automake
    clang
    openssl
    clang-tools
  ];
}
