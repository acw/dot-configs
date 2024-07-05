local which = require 'which-key'

vim.g.mapleader = ' '

which.register{
  -- telescope
  ['<leader>b'] = { '<cmd>Telescope buffers<cr>', 'Buffers' },
  ['<leader>f'] = { '<cmd>Telescope find_files<cr>', 'Files' },
  ['<leader>xx'] = { '<cmd>TroubleToggle<cr>', 'Diagnostics (Trouble)' },
}
