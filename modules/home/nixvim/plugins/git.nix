# modules/home/nixvim/plugins/git.nix
#
# Git integration: gitsigns for inline signs + hunk actions,
# lazygit as the full TUI front-end.
#
_: {
  programs.nixvim = {
    plugins = {
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = {text = "▎";};
            change = {text = "▎";};
            delete = {text = "";};
            topdelete = {text = "";};
            changedelete = {text = "▎";};
            untracked = {text = "▎";};
          };
          current_line_blame = false;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 500;
          };
        };
      };

      lazygit.enable = true;
    };

    keymaps = [
      # ── Hunk navigation (unimpaired-style) ────────────────────
      {
        mode = "n";
        key = "]h";
        action.__raw = ''function() require("gitsigns").nav_hunk("next") end'';
        options.desc = "Next hunk";
      }
      {
        mode = "n";
        key = "[h";
        action.__raw = ''function() require("gitsigns").nav_hunk("prev") end'';
        options.desc = "Previous hunk";
      }

      # ── Git group (<leader>g) ─────────────────────────────────
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<cr>";
        options.desc = "Lazygit";
      }
      {
        mode = "n";
        key = "<leader>gs";
        action = "<cmd>FzfLua git_status<cr>";
        options.desc = "Git status";
      }
      {
        mode = "n";
        key = "<leader>gl";
        action = "<cmd>FzfLua git_commits<cr>";
        options.desc = "Git log";
      }
      {
        mode = "n";
        key = "<leader>gf";
        action = "<cmd>FzfLua git_files<cr>";
        options.desc = "Git files";
      }
      {
        mode = "n";
        key = "<leader>gb";
        action.__raw = ''function() require("gitsigns").blame_line({ full = true }) end'';
        options.desc = "Blame line";
      }
      {
        mode = "n";
        key = "<leader>gB";
        action.__raw = ''function() require("gitsigns").toggle_current_line_blame() end'';
        options.desc = "Toggle inline blame";
      }
      {
        mode = "n";
        key = "<leader>gd";
        action.__raw = ''function() require("gitsigns").diffthis() end'';
        options.desc = "Diff this";
      }
      {
        mode = "n";
        key = "<leader>gp";
        action.__raw = ''function() require("gitsigns").preview_hunk() end'';
        options.desc = "Preview hunk";
      }
      {
        mode = "n";
        key = "<leader>gS";
        action.__raw = ''function() require("gitsigns").stage_hunk() end'';
        options.desc = "Stage hunk";
      }
      {
        mode = "n";
        key = "<leader>gR";
        action.__raw = ''function() require("gitsigns").reset_hunk() end'';
        options.desc = "Reset hunk";
      }
      {
        mode = "n";
        key = "<leader>gu";
        action.__raw = ''function() require("gitsigns").undo_stage_hunk() end'';
        options.desc = "Undo stage hunk";
      }
    ];
  };
}
