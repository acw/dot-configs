{ pkgs, ... }:

{
  home.packages = with pkgs; [
    autoconf
    automake
    clang
    libiconv
    openssl
    clang-tools
    zlib
  ];
}
