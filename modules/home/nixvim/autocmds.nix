# modules/home/nixvim/autocmds.nix
#
# Direct port of lua/config/autocmds.lua.
#
_: {
  programs.nixvim = {
    autoGroups.gars-general = {clear = true;};

    autoCmd = [
      # ── Highlight yanked text ─────────────────────────────────
      {
        event = "TextYankPost";
        group = "gars-general";
        desc = "Highlight yanked text";
        callback.__raw = ''
          function()
            (vim.hl or vim.highlight).on_yank()
          end
        '';
      }

      # ── Restore last cursor position ──────────────────────────
      {
        event = "BufReadPost";
        group = "gars-general";
        desc = "Restore last cursor position";
        callback.__raw = ''
          function(args)
            local excluded = { gitcommit = true }
            local buf = args.buf
            local ft = vim.bo[buf].filetype
            if excluded[ft] then return end
            local mark = vim.api.nvim_buf_get_mark(buf, '"')
            local line_count = vim.api.nvim_buf_line_count(buf)
            if mark[1] > 0 and mark[1] <= line_count then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
          end
        '';
      }

      # ── Reload buffers changed outside of Neovim ──────────────
      {
        event = ["FocusGained" "TermClose" "TermLeave"];
        group = "gars-general";
        desc = "Reload buffers changed outside of Neovim";
        command = "checktime";
      }

      # ── `q` closes utility windows ────────────────────────────
      {
        event = "FileType";
        group = "gars-general";
        pattern = ["help" "man" "qf" "lspinfo" "startuptime" "checkhealth"];
        desc = "Use q to close utility windows";
        callback.__raw = ''
          function(args)
            vim.bo[args.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", {
              buffer = args.buf,
              silent = true,
              desc = "Close window",
            })
          end
        '';
      }
    ];
  };
}
