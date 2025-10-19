-- putting this here to make the lua lsp not freak out too much, ironically
local vim = vim

-- General config, for all LSPs. According to the docs, this
-- gets unioned into all the other definitions
vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  },
  root_markers = { '.git' },
})

vim.lsp.enable({
  "clangd",
  "docker_compose_language_service",
  "gopls",
  "hls",
  "lua_ls",
  "nixd",
  "pyright",
  "rust_analyzer",
  "yamlls"
})

vim.diagnostic.config({
  virtual_lines = true;
  virtual_text = true;
  severity_sort = true;
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
        [vim.diagnostic.severity.ERROR] = "󰅚 ",
        [vim.diagnostic.severity.WARN] = "󰀪 ",
        [vim.diagnostic.severity.INFO] = "󰋽 ",
        [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
        [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})

vim.lsp.inlay_hint.enable(true);

local function reload_workspace(bufnr)
  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr, name = 'rust_analyzer' }) do
    vim.notify('Reloading Cargo Workspace')
    client.request('rust-analyzer/reloadWorkspace', nil, function(err)
      if err then
        vim.notify('Error reloading workspace: ' .. tostring(err), vim.log.levels.ERROR)
        return
      end
      vim.notify('Cargo workspace reloaded')
    end, bufnr)
  end
end

vim.lsp.config('rust_analyzer', {
  capabilities = {
    experimental = { serverStatusNotification = true },
  },
  filetypes = { "rust", "toml.Cargo" },
  root_markers = { "Cargo.toml", "Cargo.lock", "build.rs" },
  -- See more: https://rust-analyzer.github.io/book/configuration.html
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
        features = "all",
        allTargets = true,
      },
      diagnostics = {
        styleLints = { enable = true }
      },
      procMacro = {
        enable = true,
        ignored = {
          ["async-trait"] = { "async_trait" },
          ["napi-derive"] = { "napi" },
          ["async-recursion"] = { "async_recursion" },
        },
      },
    },
  },
  before_init = function(init_params, config)
    -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
    if config.settings and config.settings['rust-analyzer'] then
      init_params.initializationOptions = config.settings['rust-analyzer']
    end
  end,
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCargoReload', function()
      reload_workspace(bufnr)
    end, { desc = 'Reload current cargo workspace' })
  end,
})

vim.lsp.config('clangd', {
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
})

vim.lsp.config('docker_compose_language_service', {
  filetypes = { "yaml.docker-compose" },
})

vim.lsp.config('gopls', {
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
})

vim.lsp.config('yamlls', {
  autostart = true,
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  cmd = { 'yamlls' },
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
--
--local cmp = require('cmp')
--cmp.setup({
----  snippet = {
----    expand = function(args)
----        vim.fn["vsnip#anonymous"](args.body)
----    end,
----  },
--  mapping = {
--    ['<C-p>'] = cmp.mapping.select_prev_item(),
--    ['<C-n>'] = cmp.mapping.select_next_item(),
--    -- Add tab support
--    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
--    ['<Tab>'] = cmp.mapping.select_next_item(),
--    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--    ['<C-f>'] = cmp.mapping.scroll_docs(4),
--    ['<C-Space>'] = cmp.mapping.complete(),
--    ['<C-e>'] = cmp.mapping.close(),
--    ['<CR>'] = cmp.mapping.confirm({
--      behavior = cmp.ConfirmBehavior.Insert,
--      select = true,
--    })
--  },
--
--  -- Installed sources
--  sources = {
--    { name = 'nvim_lsp' },
--    { name = 'vsnip' },
--    { name = 'path' },
--    { name = 'buffer' },
--  },
--})
