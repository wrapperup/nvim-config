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

-- syntax highlighting
require("nvim-treesitter.configs").setup({
    ensure_installed = { "vimdoc", "html", "htmldjango", "c", "cpp", "lua", "typescript", "javascript", "astro", "wgsl", "rust", "embedded_template", "vento" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

local cmp = require('cmp')

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

-- lsp.on_attach(function(client, bufnr)
--     lsp.default_keymaps({ buffer = bufnr })
--     require "lsp_signature".on_attach({
--         floating_window = false,
--     }, bufnr)
-- end)
--
-- lsp.set_sign_icons({
--     error = '',
--     warn = '',
--     hint = '',
--     info = '󰋼'
-- })

require("conform").setup({
    formatters_by_ft = {
        html = { "dprint" },
        vto = { "dprint" },
        vento = { "dprint" },
        jinja = { "dprint" },
    },
})

local lspconfig = require('lspconfig')

lspconfig.ols.setup {}

lspconfig.slangd.setup {
    filetypes = {
        "slang",
    },
}

lspconfig.ts_ls.setup {
    on_attach = on_attach,
    root_dir = lspconfig.util.root_pattern("package.json"),
    single_file_support = false
}

lspconfig.lua_ls.setup({})

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
