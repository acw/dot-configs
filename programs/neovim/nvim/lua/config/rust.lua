require('rust-tools').setup({
  tools = { -- rust-tools options
    autoSetHints = true,
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },

  server = {
    -- on_attach is a callback called when the language server attachs to the buffer
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_Actions, { buffer = bufnr })
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
    settings = {
      ["rust-analyzer"] = {
        -- enable clippy on save
        checkOnSave = {
          command = "clippy"
        },
      }
    }
  },
})
