vim.g.b = {case_labels = 0}

require("wrap.lazy")

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.o.swapfile = false
vim.o.shadafile = "NONE"
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.o.hlsearch = true
vim.cmd.nohlsearch()

-- Set the shell to pwsh
vim.o.shell = "pwsh" -- and "pwsh" or "powershell"
vim.o.shellcmdflag = '-NoLogo -NonInteractive -NoProfile -ExecutionPolicy RemoteSigned -Command [System.Environment]::SetEnvironmentVariable("TERM","dumb")'
vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
vim.o.shellquote = ''
vim.o.shellxquote = ''


-- local server = '\\\\.\\pipe\\nvim-pipe-1234'
-- vim.fn.serverstart(server)

if vim.g.neovide then
    vim.keymap.set('n', '<C-S-v>', '"+P') -- Paste normal mode
    vim.keymap.set('v', '<C-S-v>', '"+P') -- Paste visual mode
    vim.keymap.set('c', '<C-S-v>', '<C-R>+') -- Paste command mode
    vim.keymap.set('i', '<C-S-v>', '<ESC>l"+Pli')

    vim.api.nvim_set_keymap('', '<C-S-v>', '+p<CR>', { noremap = true, silent = true})
    vim.api.nvim_set_keymap('!', '<C-S-v>', '<C-R>+', { noremap = true, silent = true})
    vim.api.nvim_set_keymap('t', '<C-S-v>', '<C-R>+', { noremap = true, silent = true})
    vim.api.nvim_set_keymap('v', '<C-S-v>', '<C-R>+', { noremap = true, silent = true})

    vim.o.guifont = "JetBrainsMonoNL NF:h10"

    vim.g.neovide_refresh_rate_idle = 160
    vim.g.neovide_refresh_rate = 240

    vim.g.neovide_theme = 'auto'

    vim.g.neovide_cursor_animation_length = 0.03
    vim.g.neovide_cursor_trail_size = 0.8

    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0

    vim.g.neovide_scroll_animation_length = 0.1
    vim.g.neovide_scroll_animation_far_lines = 999999

    vim.g.neovide_cursor_vfx_mode = ""
end

require("wrap.remaps")
require("wrap.theme")
require("wrap.lsp")
require("wrap.setup")
