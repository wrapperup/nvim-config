vim.cmd.compiler("jai")

vim.keymap.set("n", "<F9>", ":RaddbgToggleBreakpoint<cr>", { silent = true })
-- vim.keymap.set("n", "<F5>", ":RaddbgRun<cr>", { silent = true })
vim.keymap.set("n", "<F5>", function()
    if pcall(function() vim.api.nvim_exec2("silent! make", { output = true }) end) then
        -- vim.cmd [[botright copen]]
        vim.cmd "RaddbgRun"
    end
end, { silent = true })

