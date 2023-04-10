local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- theme
    { "folke/tokyonight.nvim", branch = "main" },
    -- { "rebelot/kanagawa.nvim" },

    -- syntax highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- fuzzy finder
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- navigation / controls
    { 'ggandor/leap.nvim' },

    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },

    -- lsp
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		dependencies = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{                                      -- Optional
			    'williamboman/mason.nvim',
			    build = function()
				    pcall(vim.cmd, 'MasonUpdate')
			    end,
			},
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},     -- Required
			{'hrsh7th/cmp-nvim-lsp'}, -- Required
			{'L3MON4D3/LuaSnip'},     -- Required
		}
	},

    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("trouble").setup {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            }
        end
    },

    -- status line
    { 'nvim-lualine/lualine.nvim', dependencies = {'nvim-tree/nvim-web-devicons'} },
    { 'arkav/lualine-lsp-progress' },
})

