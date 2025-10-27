{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clang-tools
    cmake-language-server
    docker-compose-language-service
    fd
    gopls
    lua-language-server
    luarocks
    nixd
    pyright
    tree-sitter
    yaml-language-server
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      nvim-colorizer-lua
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      vimspector
      nvim-dap
      nvim-dap-ui
      telescope-fzf-native-nvim
      telescope-nvim
      trouble-nvim
      nvim-cmp
      cmp-nvim-lsp
      which-key-nvim
      vim-fugitive
    ];
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
