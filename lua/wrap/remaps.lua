vim.g.mapleader = " "

local cfg = vim.fn.stdpath("config")
local cfg_core = cfg .. "/lua/wrap"

-- config
vim.keymap.set("n", "<leader>cv", function() vim.cmd.Ex(cfg_core) end)
vim.keymap.set("n", "<leader>ci", function() vim.cmd.e(cfg .. "/init.lua") end)
vim.keymap.set("n", "<leader>cr", function() vim.cmd.e(cfg_core .. "/remaps.lua") end)
vim.keymap.set("n", "<leader>cl", function() vim.cmd.e(cfg_core .. "/lazy.lua") end)

-- project
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- fuzzy finder / telescope
local telescope = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})
vim.keymap.set('n', 'gu', function() telescope.lsp_references({ include_declaration = false }) end, {})
vim.keymap.set('n', 'gd', function() telescope.lsp_definitions({}) end, {})

require('leap').add_default_mappings()
