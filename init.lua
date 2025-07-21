----------------------------------------------------------------------------
-- vim opts
----------------------------------------------------------------------------

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.g.b = {case_labels = 0}

local my_group = vim.api.nvim_create_augroup("my-group", { clear = true })

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.o.swapfile = false
vim.o.shadafile = "NONE"
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.o.hlsearch = true
vim.cmd.nohlsearch()

vim.opt.shortmess:append("I")

if vim.fn.has('win32') then
    -- Set the shell to pwsh
    vim.o.shell = "pwsh.exe"
    vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command $PSStyle.OutputRendering = 'PlainText';"
    vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
end

vim.api.nvim_create_autocmd("TermOpen", {
    group = my_group,
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.signcolumn = "no"
    end
})

----------------------------------------------------------------------------
-- lazy plugins
----------------------------------------------------------------------------

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

require("lazy").setup({
    -- theme
    {
        "rose-pine/neovim",
        as = "rose-pine",
        config = function()
            require("rose-pine").setup({
                styles = {
                    bold = false,
                    italic = false,
                    transparency = true,
                },
                before_highlight = function(_, highlight, _)
                    if highlight.undercurl then
                        highlight.undercurl = false
                    end
                end,
            })

            vim.cmd("colorscheme rose-pine")
        end
    },

    -- syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = 'nvim-treesitter.configs',
        opts = {
            ensure_installed = {
                "vimdoc",
                "html",
                "c",
                "cpp",
                "lua",
                "typescript",
                "javascript",
                "rust",
                "vento",
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        }
    },

    -- fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
            },
        }
    },

    -- the goat
    {
        "stevearc/oil.nvim",
        config = function()
            require('oil').setup({
                view_options = {
                    show_hidden = true,
                    is_hidden = function()
                        return false
                    end,
                },
            })
        end
    },

    { "stevearc/conform.nvim" },
    {
        "stevearc/overseer.nvim",
        config = function ()
            require('overseer').setup()

            vim.api.nvim_create_user_command("Make", function(params)
              -- Insert args at the '$*' in the makeprg
              local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
              if num_subs == 0 then
                cmd = cmd .. " " .. params.args
              end
              local task = require("overseer").new_task({
                cmd = vim.fn.expandcmd(cmd),
                components = {
                  { "on_output_quickfix", open = not params.bang, open_height = 8 },
                  "default",
                },
              })
              task:start()
            end, {
              desc = "Run your makeprg as an Overseer task",
              nargs = "*",
              bang = true,
            })
        end
    },

    {
        'stevearc/quicker.nvim',
        event = "FileType qf",
        ---@module "quicker"
        ---@type quicker.SetupOptions
        opts = {},
    },

    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",

        config = function()
            require('nvim-surround').setup()
        end
    },

    { "echasnovski/mini.comment", version = false },

    -- lsp
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
    },

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
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
    },

    {
        "ThePrimeagen/harpoon",
        event = "VeryLazy",
    },

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    {
        "rluba/jai.vim",
        init = function ()
            vim.g.b = {case_labels = 0}
        end
    },

    {
        "nvimdev/hlsearch.nvim",
        event = "BufRead",
        config = function()
            require("hlsearch").setup()
        end
    },

    { 'mistweaverco/kulala.nvim', opts = {} },

    {
        "aileot/ex-colors.nvim",
        lazy = true,
        cmd = "ExColors",
        ---@type ExColors.Config
        opts = {},
        config = function()
            require("ex-colors").setup()
        end
    },

    {
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        config = function()
            local mc = require("multicursor-nvim")

            mc.setup()

            local set = vim.keymap.set

            -- Add or skip cursor above/below the main cursor.
            set({"n", "x"}, "<c-up>",
                function() mc.lineAddCursor(-1) end)
            set({"n", "x"}, "<c-down>",
                function() mc.lineAddCursor(1) end)
            set({"n", "x"}, "<leader><up>",
                function() mc.lineSkipCursor(-1) end)
            set({"n", "x"}, "<leader><down>",
                function() mc.lineSkipCursor(1) end)

            -- Add or skip adding a new cursor by matching word/selection
            set({"n", "x"}, "<leader>n",
                function() mc.matchAddCursor(1) end)
            set({"n", "x"}, "<leader>s",
                function() mc.matchSkipCursor(1) end)
            set({"n", "x"}, "<leader>N",
                function() mc.matchAddCursor(-1) end)
            set({"n", "x"}, "<leader>S",
                function() mc.matchSkipCursor(-1) end)

            -- In normal/visual mode, press `mwap` will create a cursor in every match of
            -- the word captured by `iw` (or visually selected range) inside the bigger
            -- range specified by `ap`. Useful to replace a word inside a function, e.g. mwif.
            set({"n", "x"}, "mw", function()
                mc.operator({ motion = "iw", visual = true })
                -- Or you can pass a pattern, press `mwi{` will select every \w,
                -- basically every char in a `{ a, b, c, d }`.
                -- mc.operator({ pattern = [[\<\w]] })
            end)

            -- Press `mWi"ap` will create a cursor in every match of string captured by `i"` inside range `ap`.
            set("n", "mW", mc.operator)

            -- Add all matches in the document
            set({"n", "x"}, "<leader>A", mc.matchAllAddCursors)

            -- You can also add cursors with any motion you prefer:
            -- set("n", "<right>", function()
            --     mc.addCursor("w")
            -- end)
            -- set("n", "<leader><right>", function()
            --     mc.skipCursor("w")
            -- end)

            -- Rotate the main cursor.
            set({"n", "x"}, "<c-left>", mc.nextCursor)
            set({"n", "x"}, "<c-right>", mc.prevCursor)

            -- Delete the main cursor.
            set({"n", "x"}, "<leader>x", mc.deleteCursor)

            -- Add and remove cursors with control + left click.
            set("n", "<c-leftmouse>", mc.handleMouse)
            set("n", "<c-leftdrag>", mc.handleMouseDrag)

            -- Easy way to add and remove cursors using the main cursor.
            set({"n", "x"}, "<c-q>", mc.toggleCursor)

            -- Clone every cursor and disable the originals.
            set({"n", "x"}, "<leader><c-q>", mc.duplicateCursors)

            set("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                elseif mc.hasCursors() then
                    mc.clearCursors()
                else
                    -- Default <esc> handler.
                end
            end)

            -- bring back cursors if you accidentally clear them
            set("n", "<leader>gv", mc.restoreCursors)

            -- Align cursor columns.
            set("n", "<leader>a", mc.alignCursors)

            -- Split visual selections by regex.
            set("x", "S", mc.splitCursors)

            -- Append/insert for each line of visual selections.
            set("x", "I", mc.insertVisual)
            set("x", "A", mc.appendVisual)

            -- match new cursors within visual selections by regex.
            set("x", "M", mc.matchCursors)

            -- Rotate visual selection contents.
            set("x", "<leader>t",
                function() mc.transposeCursors(1) end)
            set("x", "<leader>T",
                function() mc.transposeCursors(-1) end)

            -- Jumplist support
            set({"x", "n"}, "<c-i>", mc.jumpForward)
            set({"x", "n"}, "<c-o>", mc.jumpBackward)

            -- Customize how cursors look.
            local hl = vim.api.nvim_set_hl
            hl(0, "MultiCursorCursor", { link = "Cursor" })
            hl(0, "MultiCursorVisual", { link = "Visual" })
            hl(0, "MultiCursorSign", { link = "SignColumn"})
            hl(0, "MultiCursorMatchPreview", { link = "Search" })
            hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
            hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
            hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
        end
    }
})

----------------------------------------------------------------------------
-- remaps
----------------------------------------------------------------------------

vim.g.mapleader = " "

local cfg = vim.fn.stdpath("config")

vim.keymap.set("n", "j", "gj", { silent = true, noremap = true })
vim.keymap.set("n", "k", "gk", { silent = true, noremap = true })
vim.keymap.set("n", "<Down>", "gj", { silent = true, noremap = true })
vim.keymap.set("n", "<Up>", "gk", { silent = true, noremap = true })

-- config
vim.keymap.set("n", "<leader>ci", function() vim.cmd.e(cfg .. "/init.lua") end)

vim.keymap.set("n", "Q", "@@")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "<S-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<S-Up>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<S-Left>",  "<gv")
vim.keymap.set("v", "<S-Right>", ">gv")

vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end)
vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end)

vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end)

vim.keymap.set("n", "<C-]>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-[>", "<cmd>cprev<CR>zz")

-- vim.keymap.set("n", "<C-Down>", function() vim.cmd.wincmd("j") end)
-- vim.keymap.set("n", "<C-Up>", function() vim.cmd.wincmd("k") end)
-- vim.keymap.set("n", "<C-Left>", function() vim.cmd.wincmd("h") end)
-- vim.keymap.set("n", "<C-Right>", function() vim.cmd.wincmd("l") end)

vim.keymap.set("n", "<C-S-Down>", ":resize +20<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-Up>", ":resize -20<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-Left>", ":vertical resize +20<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-Right>", ":vertical resize -20<CR>", { noremap = true, silent = true })

-- Center on page scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- idk sometimes I just hit shift and it"s annoying
vim.api.nvim_create_user_command("W", "w", { desc = "Write" })
vim.api.nvim_create_user_command("Wq", "wq", { desc = "Write quit" })
vim.api.nvim_create_user_command("Wqa", "wqa", { desc = "Write quit all" })
vim.api.nvim_create_user_command("Q", "q", { desc = "Quit" })
vim.api.nvim_create_user_command("Qa", "qa", { desc = "Quit All" })
vim.api.nvim_create_user_command("Vs", "vs", { desc = "Vertical split" })
vim.api.nvim_create_user_command("Sp", "sp", { desc = "Horizontal split" })

-- leader yank / paste
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Exit terminal mode like insert 
vim.keymap.set("t", "<ESC>", "<C-\\><C-N>")

-- harpoon
vim.keymap.set("n", "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end)
vim.keymap.set("n", "<C-a>", function() require("harpoon.mark").add_file() end)

vim.keymap.set("n", "<C-h>", function() require("harpoon.ui").nav_file(1) end)
vim.keymap.set("n", "<C-j>", function() require("harpoon.ui").nav_file(2) end)
vim.keymap.set("n", "<C-k>", function() require("harpoon.ui").nav_file(3) end)
vim.keymap.set("n", "<C-l>", function() require("harpoon.ui").nav_file(4) end)

-- oil.nvim
local oil = require("oil")
if oil then
    vim.keymap.set("n", "-", function() oil.open() end)
else
    vim.keymap.set("n", "-", function() vim.cmd "Ex" end)
end
vim.keymap.set("n", "<leader>pv", function() require("oil").open() end)

-- telescope
local builtin = require("telescope.builtin")

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

-- Formatting / Code Completion /Misc
vim.keymap.set("i", "<C-cr>", function() require("cmp").complete() end)
vim.keymap.set("n", "<M-o>", function() vim.cmd("ClangdSwitchSourceHeader") end)
vim.keymap.set("n", "<F3>", function() require("conform").format({
    lsp_fallback = true,
    async = true,
}) end)


----------------------------------------------------------------------------
-- theme
----------------------------------------------------------------------------


-- status line
--
-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require('lualine')
local overseer = require('overseer')

-- Color table for highlights
-- stylua: ignore
local colors = {
    bg       = 'none',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
}

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

-- Config
local config = {
    options = {
        globalstatus = true,
        -- Disable sections and component separators
        component_separators = '',
        section_separators = '',
        theme = {
            -- We are going to use lualine_c an lualine_x as left and
            -- right section. Both are highlighted by c theme .  So we
            -- are just setting default looks o statusline
            normal = { c = { fg = colors.fg, bg = colors.bg } },
            inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
    },
    sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
    },
    inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
end

ins_left {
    function()
        return '▊'
    end,
    color = { fg = colors.blue },      -- Sets highlighting of component
    padding = { left = 0, right = 1 }, -- We don't need space before this
}

ins_left {
    -- mode component
    function()
        return ''
    end,
    color = function()
        -- auto change color according to neovims mode
        local mode_color = {
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            [''] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [''] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ['r?'] = colors.cyan,
            ['!'] = colors.red,
            t = colors.red,
        }
        return { fg = mode_color[vim.fn.mode()] }
    end,
    padding = { right = 1 },
}

ins_left {
    -- filesize component
    'filesize',
    cond = conditions.buffer_not_empty,
}

ins_left {
    'filename',
    cond = conditions.buffer_not_empty,
    color = { fg = colors.magenta, gui = 'bold' },
}

ins_left { 'location' }

ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_left {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ' },
    diagnostics_color = {
        color_error = { fg = colors.red },
        color_warn = { fg = colors.yellow },
        color_info = { fg = colors.cyan },
    },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
    function()
        return '%='
    end,
}

ins_left {
    'lsp_progress',
    colors = {
        percentage = colors.cyan,
        title = colors.cyan,
        message = colors.cyan,
        spinner = colors.cyan,
        lsp_client_name = colors.magenta,
        use = true,
    },
    separators = {
        component = ' ',
        progress = ' | ',
        message = { pre = '(', post = ')' },
        percentage = { pre = '', post = '%% ' },
        title = { pre = '', post = ': ' },
        lsp_client_name = { pre = '[', post = ']' },
        spinner = { pre = '', post = '' },
    },
    -- never show status for this list of servers;
    -- can be useful if your LSP server does not emit
    -- status messages
    hide = { 'null-ls', 'pyright' },
    -- by default this is false. If set to true will
    -- only show the status of LSP servers attached
    -- to the currently active buffer
    only_show_attached = true,
    display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
    timer = {
        progress_enddelay = 500,
        spinner = 1000,
        lsp_client_name_enddelay = 1000,
        attached_delay = 3000,
    },
    spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
    message = { initializing = 'Initializing…', commenced = 'In Progress', completed = 'Completed' },
    max_message_length = 30,
}

-- Add components to right sections
ins_right {
    'o:encoding',       -- option component same as &encoding in viml
    fmt = string.upper, -- I'm not sure why it's upper case either ;)
    cond = conditions.hide_in_width,
    color = { fg = colors.green, gui = 'bold' },
}

ins_right {
    'branch',
    icon = '',
    color = { fg = colors.violet, gui = 'bold' },
}

ins_right {
    'diff',
    -- Is it me or the symbol for modified us really weird
    symbols = { added = ' ', modified = '柳 ', removed = ' ' },
    diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.orange },
        removed = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
}

ins_right {
    function()
        return '▊'
    end,
    color = { fg = colors.blue },
    padding = { left = 1 },
}

ins_right {
    "overseer",
    label = 'overseer',       -- Prefix for task counts
    colored = true,   -- Color the task icons and counts
    symbols = {
        [overseer.STATUS.FAILURE] = " - ",
        [overseer.STATUS.CANCELED] = " - ",
        [overseer.STATUS.SUCCESS] = " - ",
        [overseer.STATUS.RUNNING] = "󰐌 - ",
    },
    unique = true,       -- Unique-ify non-running task count by name
    name = nil,           -- List of task names to search for
    name_not = false,     -- When true, invert the name search
    status = nil,         -- List of task statuses to display
    status_not = false,   -- When true, invert the status search
}

-- Now don't forget to initialize lualine
lualine.setup(config)


----------------------------------------------------------------------------
-- lsp
----------------------------------------------------------------------------


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

require("conform").setup {
    formatters_by_ft = {
        html = { "dprint" },
        vto = { "dprint" },
        vento = { "dprint" },
        jinja = { "dprint" },
    },
}

require("mason").setup()

local lspconfig = require('lspconfig')

lspconfig.ols.setup {}

lspconfig.slangd.setup {
    filetypes = {
        "slang",
    },
}

lspconfig.ts_ls.setup {}

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {
          'vim',
          'require'
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

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


----------------------------------------------------------------------------
-- raddbg integration
----------------------------------------------------------------------------


local raddbg_breakpoint_group = "RaddbgBreakpointGroup"
local raddbg_breakpoint_ns = "RaddbgBreakpoint"

local raddbg_group = vim.api.nvim_create_augroup("raddbg-group", { clear = true })

local function starts_with(str, start)
  return string.find(str, "^" .. start) ~= nil
end

local function to_posix_path(path)
  return path:gsub("\\", "/")
end

local function read_entire_file(file)
    local attempts = 5
    local delay = 5 -- milliseconds

    for i = 1, attempts do
        local f = io.open(file, "rb")
        if f then
            local content = f:read("*all")
            f:close()
            return content
        end
        vim.loop.sleep(delay) -- Give some time before retrying
    end

    return ""
end


vim.api.nvim_set_hl(0, raddbg_breakpoint_ns, { fg="#EE6969" })
vim.fn.sign_define(raddbg_breakpoint_ns, { text="", texthl=raddbg_breakpoint_ns, linehl="", numhl="" })

local raddbg_root = to_posix_path(os.getenv("APPDATA") .. "\\raddbg\\")

---@string
---@table
local function raddbg_cmd(cmd, args)
    local input = {
        "raddbg",
        "--ipc",
        cmd,
        unpack(args or {}),
    }

    vim.system(input)
end

local raddbg_breakpoints = {}

local function sync_breakpoints(file_content)
    raddbg_breakpoints = {}

    -- Define a pattern to match each breakpoint block
    local breakpoint_pattern = 'breakpoint:%s*{.-location:%s*%("(.-)":(%d+)%)'

    -- Iterate over all breakpoints in the file content
    for location, line in string.gmatch(file_content, breakpoint_pattern) do
        local combined_path = vim.fn.fnamemodify(raddbg_root .. location, ":p")
        local absolute_path = vim.fn.resolve(combined_path)

        table.insert(raddbg_breakpoints, {
            location = absolute_path,
            line = tonumber(line)
        })
    end
end

-- local function add_breakpoint_signs(buf)
--     local signs = {}
--
--     for k, v in pairs(raddbg_breakpoints) do
--         local id = vim.tbl_count(raddbg_breakpoints)
--         print("ok")
--         table.insert(signs, {
--             buffer = buf,
--             group = raddbg_breakpoint_ns,
--             id = id,
--             lnum = v.line,
--             name = v.location,
--             priority = 21,
--         })
--     end
--
--     vim.fn.sign_placelist(signs)
-- end

local function refresh_all_breakpoint_signs()
    local signs = {}

    for _, v in pairs(raddbg_breakpoints) do
        local buffer = vim.fn.bufnr(v.location)

        if buffer ~= -1 then
            local id = vim.tbl_count(signs)
            table.insert(signs, {
                id = id,
                group = raddbg_breakpoint_group,
                name = raddbg_breakpoint_ns,
                buffer = vim.fn.bufnr(v.location),
                lnum = v.line,
                priority = 21,
            })
        end
    end

    vim.fn.sign_unplace(raddbg_breakpoint_group)
    vim.fn.sign_placelist(signs)
end

local function read_breakpoints_from_project()
    local file = read_entire_file(raddbg_root .. "default.raddbg_project")
    sync_breakpoints(file)
    refresh_all_breakpoint_signs()
end

local uv = vim.uv

local fs_watcher = uv.new_fs_event()
fs_watcher:start(
    raddbg_root .. "default.raddbg_project",
    {},
    vim.schedule_wrap(function(_, _, events)
        read_breakpoints_from_project()
    end)
)

local function raddbg_goto_current_file()
    local file_path = to_posix_path(vim.fn.expand("%:p"))
    print(file_path)
    raddbg_cmd("goto_name", { file_path });

    local line_number = vim.api.nvim_win_get_cursor(0)[1]
    raddbg_cmd("goto_line", { line_number });
end

local function raddbg_toggle_breakpoint(in_line_number)
    local file_path = to_posix_path(vim.fn.expand("%:p"))
    local line_number = in_line_number or vim.api.nvim_win_get_cursor(0)[1]

    raddbg_cmd("toggle_breakpoint", { file_path .. ":" .. line_number });

    local timer = vim.loop.new_timer()
    timer:start(20, 0, vim.schedule_wrap(function()
        raddbg_cmd("write_project_data");
    end))
end

local function raddbg_run(in_line_number)
    raddbg_cmd("run");
end


vim.keymap.set("n", "<F9>", ":RaddbgToggleBreakpoint<cr>", { silent = true })
-- vim.keymap.set("n", "<F5>", ":RaddbgRun<cr>", { silent = true })
vim.keymap.set("n", "<F5>", function()
    if pcall(function() vim.api.nvim_exec2("silent! make", { output = true }) end) then
        -- vim.cmd [[botright copen]]
        vim.cmd "RaddbgRun"
    end
end, { silent = true })

-- Commands

vim.api.nvim_create_user_command("RaddbgGotoFile", function()
    raddbg_goto_current_file()
end, {})

vim.api.nvim_create_user_command("RaddbgToggleBreakpoint", function()
    raddbg_toggle_breakpoint()
end, {})

vim.api.nvim_create_user_command("RaddbgRun", function()
    raddbg_run()
end, {})

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = read_breakpoints_from_project
})
