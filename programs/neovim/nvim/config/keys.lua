local which = require 'which-key'

vim.g.mapleader = ' '

which.register{
  -- telescope
  ['<leader>b'] = { '<cmd>Telescope buffers<cr>', 'Buffers' },
  ['<leader>f'] = { '<cmd>Telescope find_files<cr>', 'Files' },
  -- LSP bindngs
  ['<leader>ls'] = {
    function()
      vim.lsp.buf.rename()
    end,
    'LSP Rename'
  },
  ['<leader>ld'] = {
    function()
      vim.lsp.buf.definition()
    end,
    'LSP Definition'
  },
  ['<leader>lD'] = {
    function()
      vim.lsp.buf.declaration()
    end,
    'LSP Definition'
  },
  ['<leader>lr'] = {
    function()
      vim.lsp.buf.references()
    end,
    'LSP Definition'
  },
  -- trouble
  ['<leader>tt'] = { '<cmd>TroubleToggle<cr>', 'Diagnostics (Trouble)' },
  ['<leader>tn'] = {
    function()
      require("trouble").next({skip_groups = true, jump = true})
    end,
    'Next Trouble',
  },
  ['<leader>tp'] = {
    function()
      require("trouble").previous({skip_groups = true, jump = true})
    end,
    'Next Trouble',
  },
}
