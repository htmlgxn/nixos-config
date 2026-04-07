# modules/home/nixvim/plugins/editor.nix
#
# Editor enhancements — motion, text objects, folding, pairs, harpoon,
# sessions, todo markers, multiplexer-aware window nav.
#
{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      # ── Jump motion (s / S) ──────────────────────────────────────
      flash = {
        enable = true;
        settings = {
          modes = {
            search.enabled = true;
            char.enabled = true;
          };
          label = {
            rainbow.enabled = true;
          };
        };
      };

      # ── mini.* bundle ────────────────────────────────────────────
      # ai:        treesitter-aware text objects (va{, vif, …)
      # surround:  ysiw", ds", cs"'
      # bufremove: delete buffer without closing the window
      mini = {
        enable = true;
        modules = {
          ai = {n_lines = 500;};
          surround = {};
          bufremove = {};
        };
      };

      # ── Autopairs ────────────────────────────────────────────────
      nvim-autopairs = {
        enable = true;
        settings = {
          check_ts = true;
          fast_wrap = {};
        };
      };

      # ── Folding (UFO) ────────────────────────────────────────────
      # Pairs with options.nix fold settings (foldlevel=99 etc.)
      # NOTE: lsp.nix must grant folding capabilities on LspAttach:
      #   capabilities.textDocument.foldingRange = {
      #     dynamicRegistration = false;
      #     lineFoldingOnly = true;
      #   };
      nvim-ufo = {
        enable = true;
        settings = {
          provider_selector.__raw = ''
            function(bufnr, filetype, buftype)
              return { "treesitter", "indent" }
            end
          '';
          fold_virt_text_handler.__raw = ''
            function(virtText, lnum, endLnum, width, truncate)
              local newVirtText = {}
              local suffix = ("  %d "):format(endLnum - lnum)
              local sufWidth = vim.fn.strdisplaywidth(suffix)
              local targetWidth = width - sufWidth
              local curWidth = 0
              for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                  table.insert(newVirtText, chunk)
                else
                  chunkText = truncate(chunkText, targetWidth - curWidth)
                  local hlGroup = chunk[2]
                  table.insert(newVirtText, { chunkText, hlGroup })
                  chunkWidth = vim.fn.strdisplaywidth(chunkText)
                  if curWidth + chunkWidth < targetWidth then
                    suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                  end
                  break
                end
                curWidth = curWidth + chunkWidth
              end
              table.insert(newVirtText, { suffix, "MoreMsg" })
              return newVirtText
            end
          '';
        };
      };

      # ── Treesitter sticky context ────────────────────────────────
      treesitter-context = {
        enable = true;
        settings = {
          max_lines = 3;
          min_window_height = 20;
          mode = "cursor";
          trim_scope = "outer";
        };
      };

      # ── TODO: / FIXME: / HACK: highlighting + search ─────────────
      todo-comments = {
        enable = true;
        settings = {
          signs = true;
          highlight = {
            pattern = ''.*<(KEYWORDS)\s*:'';
          };
        };
      };

      # ── Project-wide search & replace ────────────────────────────
      spectre = {
        enable = true;
      };

      # ── Session management ───────────────────────────────────────
      persistence = {
        enable = true;
        settings = {
          options = ["buffers" "curdir" "tabpages" "winsize" "help"];
        };
      };

      # ── Multiplexer-aware window navigation ──────────────────────
      # You run both tmux and zellij — zellij is the daily driver per
      # the current setup, so that's the default. Swap to "tmux" or
      # "tmux_or_zellij" if you change shells.
      smart-splits = {
        enable = true;
        settings = {
          at_edge = "stop";
          multiplexer_integration = "zellij";
        };
      };
    };

    # ── Harpoon2 via extraPlugins ──────────────────────────────────
    # nixvim's `plugins.harpoon` module targets the legacy harpoon1
    # API. Harpoon2 has a nicer list-based API, so we drop it in
    # directly and configure in extraConfigLua.
    extraPlugins = [pkgs.vimPlugins.harpoon2];
    extraConfigLua = ''
      do
        local ok, harpoon = pcall(require, "harpoon")
        if ok then
          harpoon:setup({})
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true })
          end
          map("<leader>ha", function() harpoon:list():add() end, "Harpoon: add file")
          map("<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "Harpoon: menu")
          map("<leader>h1", function() harpoon:list():select(1) end, "Harpoon: slot 1")
          map("<leader>h2", function() harpoon:list():select(2) end, "Harpoon: slot 2")
          map("<leader>h3", function() harpoon:list():select(3) end, "Harpoon: slot 3")
          map("<leader>h4", function() harpoon:list():select(4) end, "Harpoon: slot 4")
          map("<leader>hn", function() harpoon:list():next() end, "Harpoon: next")
          map("<leader>hp", function() harpoon:list():prev() end, "Harpoon: prev")
        end
      end
    '';

    # ── Plugin-scoped keymaps ──────────────────────────────────────
    keymaps = [
      # flash (motion)
      {
        mode = ["n" "x" "o"];
        key = "s";
        action.__raw = ''function() require("flash").jump() end'';
        options.desc = "Flash jump";
      }
      {
        mode = ["n" "x" "o"];
        key = "S";
        action.__raw = ''function() require("flash").treesitter() end'';
        options.desc = "Flash treesitter";
      }
      {
        mode = "o";
        key = "r";
        action.__raw = ''function() require("flash").remote() end'';
        options.desc = "Remote flash";
      }

      # spectre (search/replace)
      {
        mode = "n";
        key = "<leader>sr";
        action.__raw = ''function() require("spectre").toggle() end'';
        options.desc = "Replace in files (spectre)";
      }
      {
        mode = "n";
        key = "<leader>sw";
        action.__raw = ''function() require("spectre").open_visual({ select_word = true }) end'';
        options.desc = "Replace word under cursor";
      }
      {
        mode = "v";
        key = "<leader>sr";
        action.__raw = ''function() require("spectre").open_visual() end'';
        options.desc = "Replace selection";
      }

      # persistence (sessions)
      {
        mode = "n";
        key = "<leader>ss";
        action.__raw = ''function() require("persistence").load() end'';
        options.desc = "Restore session (cwd)";
      }
      {
        mode = "n";
        key = "<leader>sl";
        action.__raw = ''function() require("persistence").load({ last = true }) end'';
        options.desc = "Load last session";
      }
      {
        mode = "n";
        key = "<leader>sS";
        action.__raw = ''function() require("persistence").select() end'';
        options.desc = "Select session";
      }

      # todo-comments
      {
        mode = "n";
        key = "]t";
        action.__raw = ''function() require("todo-comments").jump_next() end'';
        options.desc = "Next todo comment";
      }
      {
        mode = "n";
        key = "[t";
        action.__raw = ''function() require("todo-comments").jump_prev() end'';
        options.desc = "Previous todo comment";
      }
      {
        mode = "n";
        key = "<leader>ft";
        action = "<cmd>TodoFzfLua<cr>";
        options.desc = "Find todos";
      }

      # nvim-ufo (fold controls)
      {
        mode = "n";
        key = "zR";
        action.__raw = ''function() require("ufo").openAllFolds() end'';
        options.desc = "Open all folds";
      }
      {
        mode = "n";
        key = "zM";
        action.__raw = ''function() require("ufo").closeAllFolds() end'';
        options.desc = "Close all folds";
      }
      {
        mode = "n";
        key = "zK";
        action.__raw = ''function() require("ufo").peekFoldedLinesUnderCursor() end'';
        options.desc = "Peek fold";
      }

      # treesitter-context
      {
        mode = "n";
        key = "[[";
        action.__raw = ''function() require("treesitter-context").go_to_context(vim.v.count1) end'';
        options = {
          desc = "Jump to context";
          silent = true;
        };
      }

      # mini.bufremove
      {
        mode = "n";
        key = "<leader>bd";
        action.__raw = ''function() require("mini.bufremove").delete(0, false) end'';
        options.desc = "Delete buffer";
      }
      {
        mode = "n";
        key = "<leader>bD";
        action.__raw = ''function() require("mini.bufremove").delete(0, true) end'';
        options.desc = "Delete buffer (force)";
      }

      # smart-splits window navigation (also honored via <C-w>hjkl)
      {
        mode = "n";
        key = "<C-h>";
        action.__raw = ''function() require("smart-splits").move_cursor_left() end'';
        options.desc = "Window left";
      }
      {
        mode = "n";
        key = "<C-j>";
        action.__raw = ''function() require("smart-splits").move_cursor_down() end'';
        options.desc = "Window down";
      }
      {
        mode = "n";
        key = "<C-k>";
        action.__raw = ''function() require("smart-splits").move_cursor_up() end'';
        options.desc = "Window up";
      }
      {
        mode = "n";
        key = "<C-l>";
        action.__raw = ''function() require("smart-splits").move_cursor_right() end'';
        options.desc = "Window right";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action.__raw = ''function() require("smart-splits").resize_left() end'';
        options.desc = "Resize window left";
      }
      {
        mode = "n";
        key = "<C-Down>";
        action.__raw = ''function() require("smart-splits").resize_down() end'';
        options.desc = "Resize window down";
      }
      {
        mode = "n";
        key = "<C-Up>";
        action.__raw = ''function() require("smart-splits").resize_up() end'';
        options.desc = "Resize window up";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action.__raw = ''function() require("smart-splits").resize_right() end'';
        options.desc = "Resize window right";
      }
    ];
  };
}
