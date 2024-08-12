local which = require 'which-key'

vim.g.mapleader = ' '

which.add({
  -- telescope
  { '<leader>b', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
  {'<leader>f', '<cmd>Telescope find_files<cr>', desc = 'Files' },
  -- LSP bindngs
  {'<leader>ls',
    function()
      vim.lsp.buf.rename()
    end,
    desc = 'LSP Rename'
  },
  {'<leader>ld',
    function()
      vim.lsp.buf.definition()
    end,
    desc = 'LSP Definition'
  },
  {'<leader>lD',
    function()
      vim.lsp.buf.declaration()
    end,
    desc = 'LSP Definition'
  },
  {'<leader>lr',
    function()
      vim.lsp.buf.references()
    end,
    desc = 'LSP Definition'
  },
  -- trouble
  {'<leader>tt', '<cmd>TroubleToggle<cr>', desc = 'Diagnostics (Trouble)' },
  {'<leader>tn',
    function()
      require("trouble").next({skip_groups = true, jump = true})
    end,
    desc = 'Next Trouble',
  },
  {'<leader>tp',
    function()
      require("trouble").previous({skip_groups = true, jump = true})
    end,
    desc = 'Next Trouble',
  },
})
