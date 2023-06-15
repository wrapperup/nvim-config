vim.g.mapleader = " "

local cfg = vim.fn.stdpath("config")
local cfg_core = cfg .. "/lua/wrap"

-- config
vim.keymap.set("n", "<leader>cv", function() vim.cmd.Ex(cfg_core) end)
vim.keymap.set("n", "<leader>ci", function() vim.cmd.e(cfg .. "/init.lua") end)
vim.keymap.set("n", "<leader>cr", function() vim.cmd.e(cfg_core .. "/remaps.lua") end)
vim.keymap.set("n", "<leader>cl", function() vim.cmd.e(cfg_core .. "/lazy.lua") end)

-- harpoon
vim.keymap.set("n", "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end)
vim.keymap.set("n", "<C-a>", function() require("harpoon.mark").add_file() end)

vim.keymap.set("n", "<C-h>", function() require("harpoon.ui").nav_file(1) end)
vim.keymap.set("n", "<C-j>", function() require("harpoon.ui").nav_file(2) end)
vim.keymap.set("n", "<C-k>", function() require("harpoon.ui").nav_file(3) end)
vim.keymap.set("n", "<C-l>", function() require("harpoon.ui").nav_file(4) end)

-- remaps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- bullshit bullshit bullshit
vim.api.nvim_create_user_command('W', 'w', { desc = 'Write' })
vim.api.nvim_create_user_command('Wq', 'wq', { desc = 'Write quit' })
vim.api.nvim_create_user_command('Wqa', 'wqa', { desc = 'Write quit all' })
vim.api.nvim_create_user_command('Q', 'q', { desc = 'Quit' })
vim.api.nvim_create_user_command('Qa', 'qa', { desc = 'Quit All' })

-- leader yank / paste
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- fuzzy finder / telescope
local telescope = require('telescope')
local builtin = require('telescope.builtin')

vim.keymap.set("n", "-", function() require('oil').open() end)
vim.keymap.set("n", "<leader>pv", function() require('oil').open() end)

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', 'gu', function() builtin.lsp_references({ include_declaration = false }) end, {})
vim.keymap.set('n', 'gd', function() builtin.lsp_definitions({}) end, {})

require('leap').add_default_mappings()
require('Comment').setup()
