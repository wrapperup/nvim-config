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
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" }
    },

    { 'stevearc/oil.nvim' },

    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
    },

    { 'echasnovski/mini.comment', version = false },

    -- lsp
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    -- {  "L3MON4D3/LuaSnip" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
    },

    -- { "github/copilot.vim" },

    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        cmd = "Trouble",
        config = function()
            require("trouble").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end,
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },

    -- status line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
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

    -- {
    --     "nvimdev/hlsearch.nvim",
    --     event = 'BufRead',
    --     config = function()
    --         require('hlsearch').setup()
    --     end
    -- },

    {
        'stevearc/overseer.nvim',
        event = "VeryLazy",
        opts = {},
    },

    {
        'rluba/jai.vim',
        init = function ()
            vim.g.b = {case_labels = 0}
        end
    },
})
