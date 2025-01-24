----------------------------------------------------------------------------
-- Vanilla remaps
----------------------------------------------------------------------------

vim.g.mapleader = " "

local cfg = vim.fn.stdpath("config")
local cfg_core = cfg .. "/lua/wrap"

-- config
vim.keymap.set("n", "<leader>cv", function() vim.cmd.Ex(cfg_core) end)
vim.keymap.set("n", "<leader>ci", function() vim.cmd.e(cfg .. "/init.lua") end)
vim.keymap.set("n", "<leader>cr", function() vim.cmd.e(cfg_core .. "/remaps.lua") end)
vim.keymap.set("n", "<leader>cl", function() vim.cmd.e(cfg_core .. "/lazy.lua") end)
vim.keymap.set("n", "<leader>ck", function() vim.cmd.e(cfg_core .. "/lsp.lua") end)

vim.keymap.set("n", "Q", "@@")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "<S-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<S-Up>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<S-Left>",  "<gv")
vim.keymap.set("v", "<S-Right>", ">gv")

vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end)
vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end)

vim.keymap.set("n", "<C-]>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-[>", "<cmd>cprev<CR>zz")

vim.keymap.set('n', '<C-Down>', function() vim.cmd.wincmd('j') end)
vim.keymap.set('n', '<C-Up>', function() vim.cmd.wincmd('k') end)
vim.keymap.set('n', '<C-Left>', function() vim.cmd.wincmd('h') end)
vim.keymap.set('n', '<C-Right>', function() vim.cmd.wincmd('l') end)

vim.keymap.set('n', '<C-S-Down>', ':resize +20<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-Up>', ':resize -20<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-Left>', ':vertical resize +20<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-Right>', ':vertical resize -20<CR>', { noremap = true, silent = true })

-- Center on page scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- idk sometimes I just hit shift and it's annoying
vim.api.nvim_create_user_command("W", "w", { desc = "Write" })
vim.api.nvim_create_user_command("Wq", "wq", { desc = "Write quit" })
vim.api.nvim_create_user_command("Wqa", "wqa", { desc = "Write quit all" })
vim.api.nvim_create_user_command("Q", "q", { desc = "Quit" })
vim.api.nvim_create_user_command("Qa", "qa", { desc = "Quit All" })

-- leader yank / paste
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

----------------------------------------------------------------------------
-- harpoon
----------------------------------------------------------------------------

vim.keymap.set("n", "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end)
vim.keymap.set("n", "<C-a>", function() require("harpoon.mark").add_file() end)

vim.keymap.set("n", "<C-h>", function() require("harpoon.ui").nav_file(1) end)
vim.keymap.set("n", "<C-j>", function() require("harpoon.ui").nav_file(2) end)
vim.keymap.set("n", "<C-k>", function() require("harpoon.ui").nav_file(3) end)
vim.keymap.set("n", "<C-l>", function() require("harpoon.ui").nav_file(4) end)

----------------------------------------------------------------------------
-- oil.nvim
----------------------------------------------------------------------------

local oil = require("oil")
if oil then
    vim.keymap.set("n", "-", function() oil.open() end)
else
    vim.keymap.set("n", "-", function() vim.cmd "E" end)
end
vim.keymap.set("n", "<leader>pv", function() require("oil").open() end)

----------------------------------------------------------------------------
-- telescope
----------------------------------------------------------------------------

local builtin = require('telescope.builtin')

local filetype_to_std_lib = {
  jai = "C:/Repos/jai/jai",
  odin = "C:/Repos/odin/Odin",
}

local find_file_in_std = function()
  local filetype = vim.bo.filetype;

  if filetype_to_std_lib[filetype] ~= nil then
    builtin.find_files({ cwd = filetype_to_std_lib[filetype] })
  end
end

local live_grep_in_std = function()
  local filetype = vim.bo.filetype;

  if filetype_to_std_lib[filetype] ~= nil then
    builtin.live_grep({ cwd = filetype_to_std_lib[filetype] })
  end
end

if builtin then
  vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
  vim.keymap.set("n", "<leader>F",  find_file_in_std, {})
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
  vim.keymap.set("n", "<leader>G",  live_grep_in_std, {})
  vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
  vim.keymap.set("n", "<leader>fr", builtin.resume, {})
  vim.keymap.set("n", "<leader>fq", builtin.quickfix, {})
  vim.keymap.set("n", "gu", function() builtin.lsp_references({}) end, {})
  vim.keymap.set("n", "gd", function() builtin.lsp_definitions({}) end, {})
end

----------------------------------------------------------------------------
-- Overseer.nvim
----------------------------------------------------------------------------

local overseer = require('overseer')

if overseer then
  vim.api.nvim_create_user_command("OverseerRestartLast", function()
    local tasks = overseer.list_tasks({ recent_first = true })
    if vim.tbl_isempty(tasks) then
      -- no tasks to restart, let the user pick
      overseer.run_template()
    else
      overseer.run_action(tasks[1], "restart")
    end
  end, {})

  vim.keymap.set("n", "<F5>", function() vim.cmd "OverseerRestartLast" end)
  vim.keymap.set("n", "<S-F5>", function() vim.cmd "OverseerRun" end)
end

----------------------------------------------------------------------------
-- Formatting / Code Completion /Misc
----------------------------------------------------------------------------

vim.keymap.set('i', '<C-cr>', function() require("cmp").complete() end)

require("Comment").setup()

vim.keymap.set("n", "<M-o>", function() vim.cmd("ClangdSwitchSourceHeader") end)

vim.keymap.set("n", "<F3>", function() require("conform").format({
    lsp_fallback = true,
    async = true,
}) end)
