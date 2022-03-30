-- Bootstrap packer installation
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.api.nvim_command("packadd packer.nvim")
end

return require("packer").startup(function()
  use({ "wbthomason/packer.nvim" }) -- the package manager itself

  use({ "neovim/nvim-lspconfig" }) -- language servers are awesome!
  use({ "simrat39/rust-tools.nvim" }) -- extra Rust stuff
end)
