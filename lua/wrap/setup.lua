require('telescope').setup {
  extensions = {
    file_browser = {
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = false,
    },
  },
}

require('oil').setup({
    view_options = {
        show_hidden = true,
        is_hidden = function(name, bufnr)
            return false
        end,
    },
})

require('nvim-surround').setup()

require('overseer').setup()
