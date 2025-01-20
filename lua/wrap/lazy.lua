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
    {
        "rose-pine/neovim",
        as = "rose-pine",
        config = function()
            require("rose-pine").setup({
                styles = {
                    bold = true,
                    italic = false,
                    transparency = true,
                },
                before_highlight = function(group, highlight, palette)
                    if highlight.undercurl then
                        highlight.undercurl = false
                    end
                end,
            })

            vim.cmd('colorscheme rose-pine')
        end
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            -- require("ibl").setup {
            --     indent = { char = "│" },
            -- }
        end
    },

    { 'NMAC427/guess-indent.nvim' },

    -- syntax highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    { 'stevearc/oil.nvim' },

    -- navigation / controls
    {
        'ggandor/leap.nvim',
        event = "VeryLazy",
    },

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
            { 'neovim/nvim-lspconfig' }, -- Required
            {                            -- Optional
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    },

    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
    },

    -- { "github/copilot.vim" },

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
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        event = "VeryLazy",
    },

    {
        'arkav/lualine-lsp-progress',
        event = "VeryLazy",
    },

    {
        'ThePrimeagen/harpoon',
        event = "VeryLazy",
    },

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    -- formatting
    {
        'stevearc/conform.nvim',
        event = "VeryLazy",
        opts = {},
    },

    {
        "olrtg/nvim-emmet",
        config = function()
        end,
    },

    {
        "nvimdev/hlsearch.nvim",
        event = 'BufRead',
        config = function()
            require('hlsearch').setup()
        end
    },

    {
        'stevearc/overseer.nvim',
        event = "VeryLazy",
        opts = {},
    },

    {
        'gabrielpoca/replacer.nvim',
        event = "VeryLazy",
        opts = { rename_files = false },
        keys = {
            {
                '<leader>h',
                function() require('replacer').run() end,
                desc = "run replacer.nvim"
            }
        },
    },

    -- {
    --     'windwp/nvim-autopairs',
    --     event = "InsertEnter",
    --     config = true
    --     -- use opts = {} for passing setup options
    --     -- this is equalent to setup({}) function
    -- },

    {
        'rluba/jai.vim',
        init = function ()
            vim.g.b = {case_labels = 0}
        end
    },
})
