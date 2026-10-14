vim.cmd.compiler("odin")

vim.keymap.set("n", "<F9>", ":RaddbgToggleBreakpoint<cr>", { silent = true })
-- vim.keymap.set("n", "<F5>", ":RaddbgRun<cr>", { silent = true })
vim.keymap.set("n", "<F5>", function()
    vim.cmd "RaddbgStop"  -- blocks until the old debuggee is gone, so the link won't hit a locked binary
    vim.cmd "silent make!"

    if vim.v.shell_error == 0 then
        vim.cmd "cclose"
        vim.cmd "RaddbgRun"
    else
        vim.cmd "botright copen"
    end
end, { silent = true })
