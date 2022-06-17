local function set_color(name, info)
  local style = info.style and 'gui=' .. info.style or 'gui=NONE'
  local fg = info.fg and 'guifg=' .. info.fg or 'guifg=NONE'
  local bg = info.bg and 'guibg=' .. info.bg or 'guibg=NONE'
  vim.cmd('highlight ' .. name .. ' ' .. style .. ' ' .. fg .. ' ' .. bg)
end

mode = "light"

if(mode == "dark") then
  set_color("Comment", { fg = "#e23612" })
  set_color("SpecialComment", { fg = "#a165f3" })
  
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
  set_color("Todo", {fg = "#ffaf00" })
  
  set_color("Search", {fg = "#080808", bg="#ffff00" })
  
  set_color("SpellBad", {bg = "#5f0000" })
  set_color("SpellCap", {bg = "#005f00" })
  set_color("SpellRare", {bg = "#005f00" })
  set_color("SpellLocal", {fg = "#000000" })
  
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
else
  set_color("Comment", { fg = "#e23612" })
  set_color("SpecialComment", { fg = "#a165f3" })
  
  set_color("String", {fg = "#2c7764", style = "underline" })
  set_color("Character", {fg = "#2c7764" })
  set_color("Number", {fg = "#3da38a" })
  set_color("Boolean", {fg = "#3da38a" })
  set_color("Float", {fg = "#3da38a" })
  
  set_color("Identifier", {fg = "#2d44db" })
  set_color("Function", {fg = "#2d44db" })
  set_color("Statement", {fg = "#0d1c82" })
  set_color("Conditional", {fg = "#0d1c82" })
  set_color("Label", {fg = "#16a1d7" })
  set_color("Operator", {fg = "#0d1c82" })
  set_color("Keyword", {fg = "#0d1c82" })
  
  set_color("PreProc", {fg = "#6c8044" })
  set_color("Include", {fg = "#16a1d7" })
  set_color("Define", {fg = "#30a0ff" })
  set_color("Macro", {fg = "#649aba" })
  set_color("PreCondit", {fg = "#d716c9", style = "bold" }) 
  
  set_color("Type", {fg = "#b1bff1" })
  set_color("StorageClass", {fg = "#649aba" })
  set_color("Constant", {fg = "#ff8787" })
  set_color("Repeat", {bg = "#00FF00" })
  set_color("Exception", {bg = "#333333" })
  set_color("Structure", {fg = "#ff8787", bg = "#ff0000" })
  set_color("Typedef", {fg = "#8787d7", bg = "#00ff00" })
  
  set_color("Special", {fg = "#0f7197" })
  set_color("SpecialChar", {bg = "#333333" })
  set_color("Tag", {bg = "#333333" })
  set_color("Delimiter", {fg = "#0f7197" })
  set_color("Debug", {bg = "#333333" })
  
  set_color("Underlined", {fg = "#ffd7af", style = "underline" })
  set_color("Ignore", {fg = "#000000" })
  set_color("Error", {fg = "#ff0000" })
  set_color("Todo", {fg = "#ffaf00" })
  
  set_color("Search", {fg = "#080808", bg="#bbbb00" })
  
  set_color("SpellBad", {bg = "#ffdddd" })
  set_color("SpellCap", {bg = "#005f00" })
  set_color("SpellRare", {bg = "#005f00" })
  set_color("SpellLocal", {fg = "#000000" })
  
  set_color("SignColumn", {fg = "#000000" })
  
  set_color("Pmenu", {bg="#fbf0e4"})
  set_color("PmenuSel", {bg="#76aaea"})
  set_color("PmenuSbar", {bg="#444444"})
  set_color("PmenuThumb", {bg="#444444"})
  
  
  set_color("CmpItemAbbrMatch", {bg="#222222", fg="#569CD6"})
  set_color("CmpItemAbbrMatchFuzzy", {bg=NONE, fg="#569CD6"})
  set_color("CmpItemKindFunction", {bg=NONE, fg="#C586C0"})
  set_color("CmpItemKindMethod", {bg=NONE, fg="#C586C0"})
  set_color("CmpItemKindVariable", {bg=NONE, fg="#9CDCFE"})
  set_color("CmpItemKindKeyword", {bg=NONE, fg="#D4D4D4"})
  set_color("LineNr", {fg="#ffbe00"})
end
