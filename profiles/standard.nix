{ pkgs, ... }:

{
  imports = [ ../programs/neovim ../programs/tmux ../programs/zsh ];

  home.packages = with pkgs; [
    _1password
    btop
    calc
    git
    jq
    ripgrep
    tmux
    unixtools.watch
    unixtools.xxd
  ];
}