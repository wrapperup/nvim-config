-- auto indent
require('guess-indent').setup {}

vim.filetype.add({
    extension = {
        wgsl = "wgsl",
    }
})

local parser_confg = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.jinja2 = {
    install_info = {
        url = "https://github.com/dbt-labs/tree-sitter-jinja2.git",
        files = { "src/parser.c" },
        branch = "main",
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
    },
    filetype = "html",
}

-- syntax highlighting
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "lua", "typescript", "javascript", "astro", "wgsl", "pug", "html", "jinja2" },
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

require("mason-null-ls").setup({
    ensure_installed = {
        -- Opt to list sources here, when available in mason.
    },
    automatic_installation = false,
    handlers = {},
})

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.djhtml,
    },
})
