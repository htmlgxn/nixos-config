return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      default_file_explorer = true,  -- replaces netrw
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },
      view_options = {
        show_hidden = true,  -- show dotfiles
      },
      keymaps = {
        ["<C-h>"] = false,  -- free up C-h if you use it for pane navigation
        ["<C-l>"] = false,  -- same for C-l
        ["q"] = "actions.close",
      },
    })

    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}