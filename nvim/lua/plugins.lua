-- Bootstrap packer installation
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	PACKER_CLONE = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(function(use)
  use "wbthomason/packer.nvim"  -- the package manager itself
  use "nvim-treesitter/nvim-treesitter" -- treesitter
  use "nvim-lualine/lualine.nvim" -- handy status line support
  use "norcalli/nvim-colorizer.lua" -- show colors as you define them
  use "lewis6991/impatient.nvim" -- for faster startup
  use "projekt0n/github-nvim-theme"
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-vsnip"

  use "neovim/nvim-lspconfig" -- language servers are awesome!
  use "simrat39/rust-tools.nvim" -- extra Rust stuff

  use "hrsh7th/vim-vsnip"

  use {
    "nvim-neorg/neorg",
    run = ":Neorg sync-parsers", -- This is the important bit!
    config = function()
        require("neorg").setup {
          -- configuration here
          load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {},
            ["core.dirman"] = {
              config = {
                workspaces = {
                  work = "~/.local/neorg"
                }
              }
            }
          }
        }
    end,
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_CLONE then
    require("packer").sync()
  end
end)
