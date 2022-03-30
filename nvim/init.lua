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

local function set_color(name, info)
  local style = info.style and 'gui=' .. info.style or 'gui=NONE'
  local fg = info.fg and 'guifg=' .. info.fg or 'guifg=NONE'
  local bg = info.bg and 'guibg=' .. info.bg or 'guibg=NONE'
  vim.cmd('highlight ' .. name .. ' ' .. style .. ' ' .. fg .. ' ' .. bg)
end

set_color("Comment", { fg = "#e23612" }) -- good
set_color("SpecialComment", { fg = "#a165f3" }) -- good

set_color("String", {fg = "0x12b616", style = "underline" }) -- good
set_color("Character", {fg = "#5fffd7" }) -- good
set_color("Number", {fg = "#5fd7ff" }) -- good
set_color("Boolean", {fg = "#5fd7ff" }) -- good
set_color("Float", {fg = "#5fd7ff" }) -- good

set_color("Identifier", {fg = "#c2e2f4" }) -- good
set_color("Function", {fg = "#cacbf2" }) -- good
set_color("Statement", {fg = "#7dc1e8" })
set_color("Conditional", {fg = "#7dc1e8" })
set_color("Label", {fg = "#e2c7f5" }) -- good
set_color("Operator", {fg = "#7dc1e8" })
set_color("Keyword", {fg = "#7dc1e8" }) -- good

set_color("PreProc", {fg = "#d7ff87" }) -- good
set_color("Include", {fg = "#c7f5ed" }) -- good
set_color("Define", {fg = "#f5c7cd" }) -- good
set_color("Macro", {fg = "#7dc1e8" }) -- good
set_color("PreCondit", {fg = "#eeeeee", style = "bold" })  -- good

set_color("Type", {fg = "#b1bff1" }) -- good
set_color("StorageClass", {fg = "#7dc1e8" }) -- good
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
set_color("Todo", {fg = "#ffaf00" })

set_color("Search", {fg = "#080808", bg="#ffff00" })

set_color("SpellBad", {bg = "#5f0000" })
set_color("SpellCap", {bg = "#005f00" })
set_color("SpellRare", {bg = "#005f00" })
set_color("SpellLocal", {fg = "#000000" })

set_color("SignColumn", {fg = "#000000" })
