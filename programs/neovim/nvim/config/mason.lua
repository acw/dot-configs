require("mason").setup({
  ensure_installed = {
    "codelldb",
  },
})
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
  },
})
