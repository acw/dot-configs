{ pkgs, ... }:

{
  home.packages = with pkgs; [
    luarocks
    tree-sitter
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
      neorg
      nvim-colorizer-lua
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      rustaceanvim
      vimspector
    ];

    extraLuaConfig = ''
      local submodules = {
        "options",
        "colors",
        "config/colorizer",
        "config/statusline",
        "config/neorg",
        "config/lspconfig",
        "config/diagnostic",
        "config/completes",
        "config/vimspector",
        "config/treesitter",
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
