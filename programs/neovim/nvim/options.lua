local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables

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
