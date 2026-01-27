{ pkgs, systemUse, ... }:
let
  minimalInstall = systemUse == "infrastructure";
in
{
  home.packages =
    with pkgs;
    [
      fd
      nixd
      tree-sitter
    ]
    ++ (
      if minimalInstall then
        [ ]
      else
        [
          clang-tools
          cmake-language-server
          docker-compose-language-service
          gopls
          lua-language-server
          luarocks
          pyright
          yaml-language-server
        ]
    );

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins =
      with pkgs.vimPlugins;
      [
        lualine-nvim
        nvim-colorizer-lua
        nvim-web-devicons
        vimspector
        nvim-dap
        nvim-dap-ui
        plenary-nvim
        telescope-fzf-native-nvim
        telescope-nvim
        trouble-nvim
        nvim-cmp
        cmp-nvim-lsp
        which-key-nvim
        vim-fugitive
      ]
      ++ (
        if minimalInstall then
          [
          ]
        else
          [
            nvim-treesitter.withAllGrammars
          ]
      );
  };

  home.file = {
    ".config/nvim/init.lua" = {
      source = ./init.lua;
      recursive = false;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
