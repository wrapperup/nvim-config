" VIM CONFIG
let mapleader = " "
set termguicolors

set number
set numberwidth=6
set relativenumber

" Tab spacing
set ts=4
set sw=4

let g:gitgutter_git_executable = 'C:\Program Files\Git\bin\git.exe'


" Remaps
noremap <leader>fw <cmd>HopWord<cr>
noremap <leader>fc <cmd>HopChar1<cr>
noremap <leader>fc <cmd>HopWord<cr>

noremap <leader><leader>i <cmd>e ~/Appdata/Local/nvim/init.vim<cr>
noremap <leader><leader>r <cmd>source $MYVIMRC<cr>

noremap <leader>v <cmd>NvimTreeToggle<cr>

" Windows sucks?
noremap <C-Z> u


" Plugins
call plug#begin()

" Theme
Plug 'Mofiqul/vscode.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

" Icons
Plug 'kyazdani42/nvim-web-devicons'

Plug 'airblade/vim-gitgutter', {'on': 'GitGutterEnable'}

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'phaazon/hop.nvim'
call plug#end()


" Initialize Plugins & Config

lua << END
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

require("nvim-tree").setup()

require('hop').setup()
require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'vscode'
	}
}
END
