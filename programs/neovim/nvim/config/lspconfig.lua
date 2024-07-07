local lspconfig = require("lspconfig")

lspconfig.rust_analyzer.setup({
  autostart = true,
  filetypes = {"rust"},
})

lspconfig.nixd.setup({
  autostart = true,
  filetypes = {"nix"},
})

lspconfig.clangd.setup({
  autostart = true,
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
})

lspconfig.cmake.setup({
  autostart = true,
  filetypes = { "cmake" },
})

lspconfig.docker_compose_language_service.setup({
  autostart = true,
  filetypes = { "yaml.docker-compose" },
})

lspconfig.gopls.setup({
  autostart = true,
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
})

lspconfig.hls.setup({
  autostart = true,
  filetypes = { "haskell", "lhaskell" },
})

lspconfig.lua_ls.setup({
  autostart = true,
  filetypes = { "lua" },
})

lspconfig.pyright.setup({
  autostart = true,
  filetypes = { "python" },
})

lspconfig.yamlls.setup({
  autostart = true,
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, {bufnr = args.buf})
        end
    end
})

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
