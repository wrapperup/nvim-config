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
        hlsl = "hlsl",
        slang = "slang"
    }
})

local parser_config = require ("nvim-treesitter.parsers").get_parser_configs()

-- parser_config.jai = {
--     install_info = {
--         url = "https://github.com/constantitus/tree-sitter-jai",
--         files = { "src/parser.c" },
--     },
--     filetype = "jai",
--     filetype_to_parsername = "jai",
--     indent = {
--         enable = true
--     }
-- }
--
-- require('nvim-treesitter.configs').setup {
--     highlight = {
--         enable = true,
--         additional_vim_regex_highlighting = false,
--     },
--     indent = {
--         enable = true,
--     },
--     ensure_installed = {"jai"}, -- Add "jai" here if needed, or leave it empty
-- }
--
-- vim.filetype.add({
--     extension = {
--         jai = "jai",
--     },
-- })

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

-- cmp.setup {
--     sources = { { name = 'nvim_lsp', trigger_characters = { '-' } } },
-- }
--
-- -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#default_keymapsopts
-- local cmp_mappings = lsp.defaults.cmp_mappings({
--     ['<CR>'] = cmp.mapping.confirm({
--         behavior = cmp.ConfirmBehavior.Replace,
--         select = true
--     }),
-- })

-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil

-- lsp.setup_nvim_cmp({
--     mapping = cmp_mappings,
-- })

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        {name = 'luasnip'},
    },
    mapping = {
        ['<C-y>'] = cmp.mapping.confirm({ select = false }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Up>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
        ['<Down>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
        ['<C-p>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item({ behavior = 'insert' })
            else
                cmp.complete()
            end
        end),
        ['<C-n>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item({ behavior = 'insert' })
            else
                cmp.complete()
            end
        end),
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
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
local configs = require("lspconfig.configs")

-- if not configs.jails then
--   configs.jails = {
--     default_config = {
--       cmd = { 'jails' },
--       root_dir = lspconfig.util.root_pattern("jails.json", "build.jai", "main.jai"),
--       filetypes = { 'jai' },
--       name = "Jails",
--     },
--   }
-- end
-- lspconfig.jails.setup {}

lspconfig.ols.setup {}

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

lspconfig.slangd.setup {
    filetypes = {
        "slang",
    },
}

vim.lsp.start({
	name = "jai",
	cmd = { "jails" },
	root_dir = vim.fn.getcwd(), -- Use PWD as project root dir.
})

lspconfig.denols.setup {
    on_attach = on_attach,
    root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
}

lspconfig.ts_ls.setup {
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
            checkOnSave = false,
        },
    },
}

lspconfig.clangd.setup {
    on_attach = on_attach,
    cmd = {
        "clangd",
        "--offset-encoding=utf-16",
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
