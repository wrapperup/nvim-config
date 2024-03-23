require("wrap.lazy")

require("wrap.remaps")
require("wrap.theme")
require("wrap.lsp")
require("wrap.setup")

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.o.swapfile = false
vim.o.shadafile = "NONE"
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.o.hlsearch = true
vim.cmd.nohlsearch()

-- Set the shell to pwsh
-- vim.o.shell = vim.fn.executable("pwsh") and "pwsh" or "powershell"
-- vim.o.shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[\'Out-File:Encoding\']=\'utf8\';'
-- vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
-- vim.o.shellpipe = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
-- vim.o.shellquote = ""
-- vim.o.shellxquote = ""


-- vim.fn.serverstart('\\\\.\\pipe\\nvim-pipe-1234')
