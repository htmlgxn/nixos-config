return {

    -- Mason (LSP installer)
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {},
    },
  },

  -- LSP Config - MINIMAL WORKING VERSION
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Enable inlay hints (optional)
      vim.lsp.inlay_hint.enable(true)
    end,

  },
}