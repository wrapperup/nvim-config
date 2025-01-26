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
    local f = io.open(file, "rb")
    if f then
        local content = f:read("*all")
        f:close()
        return content
    end
    return ""
end


vim.api.nvim_set_hl(0, raddbg_breakpoint_ns, { fg="#EE6969" })
vim.fn.sign_define(raddbg_breakpoint_ns, { text="", texthl=raddbg_breakpoint_ns, linehl="", numhl="" })

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

local function raddbg_toggle_breakpoint(in_line_number)
    local file_path = to_posix_path(vim.fn.expand("%:p"))
    local line_number = in_line_number or vim.api.nvim_win_get_cursor(0)[1]

    raddbg_cmd("toggle_breakpoint", { file_path .. ":" .. line_number });
    raddbg_cmd("write_project_data");
end

local function raddbg_goto_current_file()
    local file_path = to_posix_path(vim.fn.expand("%:p"))
    print(file_path)
    raddbg_cmd("goto_name", { file_path });

    local line_number = vim.api.nvim_win_get_cursor(0)[1]
    raddbg_cmd("goto_line", { line_number });
end

vim.keymap.set("n", "<F9>", ":RaddbgToggleBreakpoint<cr>", { silent = true })


-- Commands

vim.api.nvim_create_user_command("RaddbgGotoFile", function()
    raddbg_goto_current_file()
end, {})

vim.api.nvim_create_user_command("RaddbgToggleBreakpoint", function()
    raddbg_toggle_breakpoint()
end, {})

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = read_breakpoints_from_project
})
