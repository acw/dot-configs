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
    theme = "github_dark",
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
