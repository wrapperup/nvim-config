-- auto indent
require('guess-indent').setup {}

vim.filetype.add({
    extension = {
        wgsl = "wgsl",
        eta = "vue",
    }
})

-- syntax highlighting
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "lua", "typescript", "javascript", "astro", "wgsl", "pug", "html", "htmldjango" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})

-- lsp
local lsp = require('lsp-zero').preset({})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#default_keymapsopts
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    require "lsp_signature".on_attach({
        floating_window = false,
    }, bufnr)
end)

lsp.set_sign_icons({
    error = '',
    warn = '',
    hint = '',
    info = '󰋼'
})

local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
lspconfig.rust_analyzer.setup {
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                loadOutDirsFromCheck = "true",
            },
        },
    },
}

lsp.setup()
