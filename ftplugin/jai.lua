vim.cmd.compiler("jai")

-- vim.keymap.set("n", "<F5>", ":RaddbgRun<cr>", { silent = true })
vim.keymap.set("n", "<F5>", function()
    vim.cmd "RaddbgKillAll"
    vim.cmd "silent make!"

    if vim.v.shell_error == 0 then
        -- vim.cmd [[botright copen]]
        vim.cmd "RaddbgRun"
    end
end, { silent = true })
