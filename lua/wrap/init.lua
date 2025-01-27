require("wrap.lazy")

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

vim.g.b = {case_labels = 0}

local my_group = vim.api.nvim_create_augroup("my-group", { clear = true })

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.o.swapfile = false
vim.o.shadafile = "NONE"
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.o.hlsearch = true
vim.cmd.nohlsearch()

if vim.fn.has('win32') then
    -- Set the shell to pwsh
    vim.o.shell = "pwsh.exe"
    vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command $PSStyle.OutputRendering = 'PlainText';"
    vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
end

vim.api.nvim_create_autocmd("TermOpen", {
    group = my_group,
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.signcolumn = "no"
    end
})

require("wrap.remaps")
require("wrap.theme")
require("wrap.lsp")
require("wrap.setup")
require("wrap.raddbg")
