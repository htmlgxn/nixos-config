return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf_lua = require("fzf-lua")

    fzf_lua.setup({
      winopts = {
        preview = {
          default = "bat",
        },
      },
    })

    local function normalize_nix_entry(entry)
      local normalized = entry:gsub("^nixpkgs/", "")
      return normalized
    end

    local function nix_search()
      fzf_lua.fzf_exec("nix-search-tv print", {
        prompt = "nix> ",
        fzf_opts = {
          ["--preview"] = "nix-search-tv preview {}",
          ["--preview-window"] = "right:60%:wrap",
          ["--scheme"] = "history",
        },
        actions = {
          ["default"] = function(selected)
            if not selected or selected[1] == nil then
              return
            end

            vim.api.nvim_put({ normalize_nix_entry(selected[1]) }, "c", true, true)
          end,
        },
      })
    end

    vim.api.nvim_create_user_command("NixSearch", nix_search, {
      desc = "Search Nix packages and insert the selected entry",
    })

    vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
    vim.keymap.set("n", "<localleader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep" })
    vim.keymap.set("n", "<localleader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
    vim.keymap.set("n", "<localleader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>", { desc = "Help tags" })
    vim.keymap.set("n", "<localleader>fh", "<cmd>FzfLua help_tags<cr>", { desc = "Help tags" })
    vim.keymap.set("n", "<leader>fn", nix_search, { desc = "Search Nix packages" })
    vim.keymap.set("n", "<localleader>fn", nix_search, { desc = "Search Nix packages" })
  end,
}
