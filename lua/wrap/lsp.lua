-- auto indent
require('guess-indent').setup {
    filetype_exclude = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
    }
}

vim.filetype.add({
    extension = {
        wgsl = "wgsl",
        bee = "lisp",
        bsc = "rust",
        vto = "vento",
        jinja = "htmldjango",
        html = "htmldjango",
    }
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

-- syntax highlighting
require("nvim-treesitter.configs").setup({
    ensure_installed = { "vimdoc", "html", "htmldjango", "c", "cpp", "lua", "typescript", "javascript", "astro", "wgsl", "rust", "embedded_template", "vento" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})

-- lsp
local lsp = require('lsp-zero').preset({})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup {
  sources = { { name = 'nvim_lsp', trigger_characters = { '-' } } }
}

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

lspconfig.emmet_language_server.setup {
    filetypes = {
        "html",
        "vento",
    },
}

lspconfig.tailwindcss.setup {
    filetypes = {
        "html",
        "vento",
    },
}

lspconfig.denols.setup {
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
}

lspconfig.tsserver.setup {
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("package.json"),
  single_file_support = false
}

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

require("conform").setup({
  formatters_by_ft = {
    html = { "dprint" },
    vto = { "dprint" },
    vento = { "dprint" },
    jinja = { "dprint" },
  },
})
