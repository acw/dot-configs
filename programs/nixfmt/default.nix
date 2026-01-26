{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixfmt
    nixfmt-tree
  ];
}
