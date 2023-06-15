require("wrap")

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

if vim.g.neovide then
    vim.keymap.set('n', '<C-S-v>', '"+P') -- Paste normal mode
    vim.keymap.set('v', '<C-S-v>', '"+P') -- Paste visual mode
    vim.keymap.set('c', '<C-S-v>', '<C-R>+') -- Paste command mode
    vim.keymap.set('i', '<C-S-v>', '<ESC>l"+Pli') -- Paste insert mode

    vim.o.guifont = "JetBrainsMonoNL NF Regular:h9"

    vim.g.neovide_refresh_rate_idle = 160
    vim.g.neovide_refresh_rate = 160


    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0

    vim.g.neovide_scroll_animation_length = 0.2
end
