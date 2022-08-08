" VIM CONFIG
let mapleader = " "
set termguicolors

set number
set relativenumber

" Tab spacing
set ts=4
set sw=4

set numberwidth=5
set signcolumn=yes:1

let g:gitgutter_git_executable = 'C:\Program Files\Git\bin\git.exe'

let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
set shellquote= shellxquote=

if exists("g:neovide")
	set guifont=JetBrainsMonoNL\ Nerd\ Font\ Mono:h11
endif


" Remaps
noremap <leader>fw <cmd>HopWord<cr>
noremap <leader>fc <cmd>HopChar1<cr>
noremap <leader>fc <cmd>HopWord<cr>

noremap <leader><leader>i <cmd>e ~/Appdata/Local/nvim/init.vim<cr>
noremap <leader><leader>s <cmd>e ~/.config/starship.toml<cr>
noremap <leader><leader>r <cmd>source $MYVIMRC<cr>

noremap <leader>v <cmd>NvimTreeToggle<cr>

" Windows sucks?
noremap <C-Z> u

" Plugins
call plug#begin()

" LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'

"  Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

Plug 'VonHeikemen/lsp-zero.nvim'


" Theme
Plug 'Mofiqul/vscode.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

" Icons
Plug 'kyazdani42/nvim-web-devicons'

Plug 'lewis6991/gitsigns.nvim'

Plug 'akinsho/toggleterm.nvim', {'tag' : 'v2.*'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'phaazon/hop.nvim'
Plug 'ziontee113/color-picker.nvim'
call plug#end()


" Initialize Plugins & Config

lua << END
--LSP
local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.setup()

--Theme
vim.o.background = 'dark'
require('vscode').setup({
	transparent = true
})

require("indent_blankline").setup {
	-- for example, context is off by default, use this to turn it on
	show_current_context = true,
	show_current_context_start = true,
}

require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'vscode'
	}
}

require("toggleterm").setup({
	open_mapping = [[<c-t>]],
	direction = "float",
	float_opts = {
		border = "curved"
	}
})
require('gitsigns').setup()
require("nvim-tree").setup()
require('hop').setup()
require('color-picker').setup()
END
