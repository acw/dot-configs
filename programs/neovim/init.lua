local vim = vim;

local scopes = { o = vim.o, b = vim.bo, w = vim.wo }

local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= "o" then
        scopes["o"][key] = value
    end
end

-- a whole mess of options I like
opt("b", "tabstop", 4) -- Put tabs 4 spaces out
opt("b", "softtabstop", 4) -- ibid
opt("b", "shiftwidth", 2) -- Shift over 2 spaces by default
opt("b", "expandtab", true) -- Don't inject tabs by default
opt("o", "backup", false) -- Don't generate backup files
opt("o", "writebackup", false) -- ibid
opt("o", "number", true) -- show line numbers on the left
opt("o", "title", true) -- set the title sometimes
opt("o", "textwidth", 80) -- wrap at 80 characters, by default
opt("o", "history", 50) -- keep 50 lines of command history
opt("o", "ruler", true) -- show the cursor position at all times
opt("o", "showcmd", true) -- display incomplete commands
opt("o", "hlsearch", true) -- highlight search items
opt("o", "incsearch", true) -- search incrementally
opt("o", "ignorecase", true) -- search case-insensitively
opt("o", "smartcase", true) -- ... except if there are capitals
opt("o", "laststatus", 2) -- always show the status bar
opt("o", "modelines", 10) -- check the first 10 lines of a file for modelines
opt("o", "foldenable", false) -- disable folding
opt("o", "confirm", true) -- ask if we want to save, rather than just failing
opt("b", "spelllang", "en_us")
opt("b", "spellfile", "~/.local/share/nvim/en.utf-8.add")
opt("b", "spellcapcheck", "")
opt("w", "spell", true)
opt("b", "autoindent", true) -- if we know nothing about ftype, keep current indent
opt("o", "termguicolors", true) -- use gui names for colors

-- define our colorset
local function set_color(name, info)
  local style = info.style and 'gui=' .. info.style or 'gui=NONE'
  local fg = info.fg and 'guifg=' .. info.fg or 'guifg=NONE'
  local bg = info.bg and 'guibg=' .. info.bg or 'guibg=NONE'
  vim.cmd('highlight ' .. name .. ' ' .. style .. ' ' .. fg .. ' ' .. bg)
end

set_color("Normal", { fg = "#eeeeee" })
set_color("Comment", { fg = "#e23612" })
set_color("SpecialComment", { fg = "#a165f3" })
set_color("LspInlayHint", { fg = "#999999", style = "italic" })

set_color("String", {fg = "0x12b616", style = "underline" })
set_color("Character", {fg = "#5fffd7" })
set_color("Number", {fg = "#5fd7ff" })
set_color("Boolean", {fg = "#5fd7ff" })
set_color("Float", {fg = "#5fd7ff" })

set_color("Identifier", {fg = "#c2e2f4" })
set_color("Function", {fg = "#cacbf2" })
set_color("Statement", {fg = "#7dc1e8" })
set_color("Conditional", {fg = "#7dc1e8" })
set_color("Label", {fg = "#e2c7f5" })
set_color("Operator", {fg = "#7dc1e8" })
set_color("Keyword", {fg = "#7dc1e8" })

set_color("PreProc", {fg = "#d7ff87" })
set_color("Include", {fg = "#c7f5ed" })
set_color("Define", {fg = "#30a0ff" })
set_color("Macro", {fg = "#7dc1e8" })
set_color("PreCondit", {fg = "#eeeeee", style = "bold" })

set_color("Type", {fg = "#b1bff1" })
set_color("StorageClass", {fg = "#7dc1e8" })
-- set_color("Constant", {fg = "#333333" })
-- set_color("Repeat", {fg = "#00FF00" })
-- set_color("Exception", {fg = "#333333" })
-- set_color("Structure", {fg = "#ff8787", bg = "#ff0000" })
-- set_color("Typedef", {fg = "#8787d7", bg = "#00ff00" })

-- set_color("Special", {fg = "#333333" })
-- set_color("SpecialChar", {fg = "#333333" })
-- set_color("Tag", {fg = "#333333" })
-- set_color("Delimiter", {fg = "#333333" })
-- set_color("Debug", {fg = "#333333" })

set_color("Underlined", {fg = "#ffd7af", style = "underline" })
set_color("Ignore", {fg = "#000000" })
set_color("Error", {fg = "#ff0000" })
set_color("Todo", {fg = "#ffae00" })

set_color("Search", {fg = "#080808", bg="#ffff00" })

set_color("SpellBad", {bg = "#5f0000" })
set_color("SpellCap", {bg = "#005f00" })
set_color("SpellRare", {bg = "#005f00" })
set_color("SpellLocal", {bg = "#005f00" })

set_color("SignColumn", {fg = "#000000" })

set_color("Pmenu", {bg="#444444"})
set_color("PmenuSel", {bg="#999999"})
set_color("PmenuSbar", {bg="#444444"})
set_color("PmenuThumb", {bg="#444444"})

set_color("CmpItemAbbrMatch", {bg=NONE, fg="#569CD6"})
set_color("CmpItemAbbrMatchFuzzy", {bg=NONE, fg="#569CD6"})
set_color("CmpItemKindFunction", {bg=NONE, fg="#C586C0"})
set_color("CmpItemKindMethod", {bg=NONE, fg="#C586C0"})
set_color("CmpItemKindVariable", {bg=NONE, fg="#9CDCFE"})
set_color("CmpItemKindKeyword", {bg=NONE, fg="#D4D4D4"})

-- Set up the status line
local lualine = require('lualine')

local colors = {
  bg       = '#111416',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#B7BD82',
  orange   = '#8d6141',
  violet   = '#B294BB',
  magenta  = '#AE84BB',
  blue     = '#81A2BE',
  red      = '#CC8282',
}

local config = {
  options = {
    theme = "wombat",
  },

  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_w = {'diagnostics'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  }
}

lualine.setup(config)
vim.opt.laststatus = 3

-- Set up the colorizer thing
require("colorizer").setup({
  lua = {
    RGB = true;
    RRGGBB = true;
    RRGGBBAA = true;
    mode = "background";
  }
})

vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option('updatetime', 300)

-- LSP!

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
  cmd = { "rust-analyzer" },
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
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
})

vim.lsp.config('docker_compose_language_service', {
  cmd = { "docker_compose_language_service" },
  filetypes = { "yaml.docker-compose" },
})

vim.lsp.config('gopls', {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
})

vim.lsp.config('yamlls', {
  autostart = true,
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  cmd = { 'yaml-language-server' },
})

vim.lsp.config('lua_ls', {
  autostart = true,
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
})

vim.lsp.config('hls', {
  autostart = true,
  cmd = { "hls" },
  filetypes = { "haskell" },
})

vim.lsp.config('nixd', {
  autostart = true,
  cmd = { "nixd" },
  filetypes = { "nix" },
})

vim.lsp.config('pyright', {
  autostart = true,
  cmd = { "pyright" },
  filetypes = { "python" },
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
--  snippet = {
--    expand = function(args)
--        vim.fn["vsnip#anonymous"](args.body)
--    end,
--  },
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

-- Telescope
local telescope = require("telescope")
telescope.setup({
  defaults = {
    layout_strategy = 'vertical',
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})
telescope.load_extension('fzf')

-- which-key
vim.g.mapleader = ' '
require("which-key").add({
  -- telescope
  { '<leader>b', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
  { '<leader>f', '<cmd>Telescope find_files<cr>', desc = 'Files' },
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
