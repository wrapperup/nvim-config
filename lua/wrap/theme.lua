-- color scheme
require("tokyonight").setup({
  on_highlights = function(hl, c)
    local prompt = "#2d3149"
    hl.TelescopeNormal = {
      bg = c.bg_dark,
      fg = c.fg_dark,
    }
    hl.TelescopeBorder = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
    hl.TelescopePromptNormal = {
      bg = prompt,
    }
    hl.TelescopePromptBorder = {
      bg = prompt,
      fg = prompt,
    }
    hl.TelescopePromptTitle = {
      bg = c.magenta2,
      fg = c.dark1,
    }
    hl.TelescopePreviewTitle = {
      bg = c.magenta2,
      fg = c.dark1,
    }
    hl.TelescopeResultsTitle = {
      bg = c.magenta2,
      fg = c.dark1,
    }
  end,
})
vim.cmd.colorscheme("tokyonight")

-- status line
require('lualine').setup({
    sections = {
        lualine_c = {
            'lsp_progress'
        }
    }
})
