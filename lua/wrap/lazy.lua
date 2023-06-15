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
    { "rebelot/kanagawa.nvim" },
    { "lukas-reineke/indent-blankline.nvim" },

    { 'nmac427/guess-indent.nvim' },

    -- syntax highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- fuzzy finder
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    { 'stevearc/oil.nvim' },

    -- navigation / controls
    { 'ggandor/leap.nvim' },

    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
    },

    { 'numToStr/Comment.nvim' },

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

    { "ray-x/lsp_signature.nvim" },

    { "github/copilot.vim" },

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

    { 'ThePrimeagen/vim-be-good' },
    { 'ThePrimeagen/harpoon' },
    {
        'saecki/crates.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function()
            require('crates').setup()
        end,
    }


    -- RUST ANALYZER doesn't like this
    -- {
    --     'rmagatti/auto-session',
    --     config = function()
    --         require('auto-session').setup {
    --             require("auto-session").setup {
    --                 log_level = "error",
    --                 auto_session_enable_last_session = true,
    --             }
    --         }
    --     end
    -- }
})
