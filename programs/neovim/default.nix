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
      impatient-nvim
      lualine-nvim
      mason-nvim
      mason-lspconfig-nvim
      nvim-colorizer-lua
      nvim-lspconfig
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

    extraLuaConfig = ''
      local submodules = {
        "options",
        "colors",
        "config/mason",
        "config/colorizer",
        "config/statusline",
        "config/diagnostic",
        "config/completes",
        "config/vimspector",
        "config/treesitter",
        "config/trouble",
        "config/lspconfig",
        "config/telescope",
        "config/keys",
      }

      
      for _, module_name in ipairs(submodules) do
        local ok, err = pcall(require, module_name)
        if not ok then
          print("Error loading submodule " .. module_name .. ": " .. err)
        end
      end
    '';
  };

  home.file = {
    ".config/nvim/lua" = {
      source = ./nvim;
      recursive = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
