# modules/home/nixvim/plugins/ui.nix
#
# UI layer: statusline, which-key, trouble, noice + notifications,
# indent guides, colorizer, markdown rendering, snacks.
#
# Alpha lives in ./alpha.nix so the header stays byte-identical and
# is easy to find/edit. Snacks.dashboard is explicitly disabled for
# the same reason.
#
_: {
  programs.nixvim = {
    plugins = {
      web-devicons.enable = true;
      # ── Statusline ───────────────────────────────────────────────
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "auto";
            globalstatus = true;
            section_separators = {
              left = "";
              right = "";
            };
            component_separators = {
              left = "│";
              right = "│";
            };
          };
          sections = {
            lualine_a = ["mode"];
            lualine_b = ["branch" "diff"];
            lualine_c = [
              {
                __unkeyed-1 = "filename";
                path = 1;
              }
            ];
            lualine_x = [
              "diagnostics"
              {
                __unkeyed-1.__raw = ''
                  function()
                    local clients = vim.lsp.get_clients({ bufnr = 0 })
                    if #clients == 0 then return "no lsp" end
                    return clients[1].name
                  end
                '';
              }
              "filetype"
            ];
            lualine_y = ["progress"];
            lualine_z = ["location"];
          };
        };
      };

      # ── Which-key (groups match the new leader scheme) ──────────
      which-key = {
        enable = true;
        settings = {
          preset = "modern";
          spec = [
            {
              __unkeyed-1 = "<leader>b";
              group = "buffer";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "code/lsp";
            }
            {
              __unkeyed-1 = "<leader>d";
              group = "debug";
            }
            {
              __unkeyed-1 = "<leader>f";
              group = "find";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "git";
            }
            {
              __unkeyed-1 = "<leader>h";
              group = "harpoon";
            }
            {
              __unkeyed-1 = "<leader>l";
              group = "nix/lazy";
            }
            {
              __unkeyed-1 = "<leader>s";
              group = "search/session";
            }
            {
              __unkeyed-1 = "<leader>t";
              group = "toggle";
            }
            {
              __unkeyed-1 = "<leader>u";
              group = "ui";
            }
            {
              __unkeyed-1 = "<leader>W";
              group = "window";
            }
            {
              __unkeyed-1 = "<leader>x";
              group = "diagnostics";
            }
            {
              __unkeyed-1 = "[";
              group = "prev";
            }
            {
              __unkeyed-1 = "]";
              group = "next";
            }
          ];
        };
      };

      # ── Trouble (diagnostics / refs / symbols panel) ─────────────
      trouble = {
        enable = true;
      };

      # ── Notifications ────────────────────────────────────────────
      notify = {
        enable = true;
        settings = {
          timeout = 3000;
          render = "compact";
          stages = "fade";
          top_down = false;
        };
      };

      # ── Noice (cmdline / messages / popupmenu UI) ────────────────
      noice = {
        enable = true;
        settings = {
          lsp = {
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = true;
            lsp_doc_border = true;
          };
          routes = [
            {
              filter = {
                event = "msg_show";
                kind = "";
                find = "written";
              };
              opts.skip = true;
            }
          ];
        };
      };

      # ── Dressing (better vim.ui.select / vim.ui.input) ───────────
      dressing = {
        enable = true;
      };

      # ── Indent guides ────────────────────────────────────────────
      indent-blankline = {
        enable = true;
        settings = {
          indent.char = "│";
          scope = {
            enabled = true;
            show_start = false;
            show_end = false;
          };
          exclude.filetypes = [
            "alpha"
            "help"
            "lazy"
            "mason"
            "notify"
            "toggleterm"
            "trouble"
            "TelescopePrompt"
            "oil"
          ];
        };
      };

      # ── Inline color previews (great for editing your themes) ────
      nvim-colorizer = {
        enable = true;
        settings = {
          filetypes = ["*"];
          user_default_options = {
            names = false;
            RGB = true;
            RRGGBB = true;
            RRGGBBAA = true;
            css = true;
            tailwind = true;
            mode = "background";
          };
        };
      };

      # ── In-buffer markdown rendering ─────────────────────────────
      render-markdown = {
        enable = true;
        settings = {
          file_types = ["markdown" "quarto"];
        };
      };

      # ── Snacks (omnibus) ─────────────────────────────────────────
      # Dashboard disabled so alpha remains untouched.
      # Notifier disabled so nvim-notify + noice handle notifications.
      # Indent disabled so indent-blankline doesn't double up.
      snacks = {
        enable = true;
        settings = {
          bigfile.enabled = true;
          dashboard.enabled = false;
          indent.enabled = false;
          notifier.enabled = false;
          input.enabled = true;
          quickfile.enabled = true;
          scroll.enabled = true;
          statuscolumn.enabled = true; # pairs with ufo fold column
          words.enabled = true; # highlights word under cursor
          scratch = {};
          zen = {};
        };
      };
    };
    #extraPlugins = [ pkgs.vimPlugins.nvim-web-devicons ];
  };
  # ── UI-layer keymaps ──────────────────────────────────────────
  programs.nixvim.keymaps = [
    # trouble
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (trouble)";
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options.desc = "Buffer diagnostics";
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<cmd>Trouble qflist toggle<cr>";
      options.desc = "Quickfix list";
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>Trouble loclist toggle<cr>";
      options.desc = "Location list";
    }
    {
      mode = "n";
      key = "<leader>xs";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      options.desc = "Symbols (trouble)";
    }
    {
      mode = "n";
      key = "<leader>xr";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
      options.desc = "LSP references";
    }
    {
      mode = "n";
      key = "<leader>xt";
      action = "<cmd>Trouble todo toggle<cr>";
      options.desc = "Todos (trouble)";
    }

    # notifications
    {
      mode = "n";
      key = "<leader>un";
      action = "<cmd>NoiceDismiss<cr>";
      options.desc = "Dismiss notifications";
    }
    {
      mode = "n";
      key = "<leader>uN";
      action = "<cmd>Noice history<cr>";
      options.desc = "Notification history";
    }

    # snacks — scratch, zen, zoom
    {
      mode = "n";
      key = "<leader>.";
      action.__raw = ''function() Snacks.scratch() end'';
      options.desc = "Scratch buffer";
    }
    {
      mode = "n";
      key = "<leader>S";
      action.__raw = ''function() Snacks.scratch.select() end'';
      options.desc = "Select scratch buffer";
    }
    {
      mode = "n";
      key = "<leader>tz";
      action.__raw = ''function() Snacks.zen() end'';
      options.desc = "Zen mode";
    }
    {
      mode = "n";
      key = "<leader>tZ";
      action.__raw = ''function() Snacks.zen.zoom() end'';
      options.desc = "Zoom mode";
    }

    # UI toggles
    {
      mode = "n";
      key = "<leader>tc";
      action = "<cmd>ColorizerToggle<cr>";
      options.desc = "Toggle colorizer";
    }
    {
      mode = "n";
      key = "<leader>tw";
      action.__raw = ''function() vim.wo.wrap = not vim.wo.wrap end'';
      options.desc = "Toggle wrap";
    }
    {
      mode = "n";
      key = "<leader>tl";
      action.__raw = ''function() vim.wo.list = not vim.wo.list end'';
      options.desc = "Toggle listchars";
    }
    {
      mode = "n";
      key = "<leader>tr";
      action.__raw = ''function() vim.wo.relativenumber = not vim.wo.relativenumber end'';
      options.desc = "Toggle relative numbers";
    }
    {
      mode = "n";
      key = "<leader>ti";
      action = "<cmd>IBLToggle<cr>";
      options.desc = "Toggle indent guides";
    }
    {
      mode = "n";
      key = "<leader>tm";
      action = "<cmd>RenderMarkdown toggle<cr>";
      options.desc = "Toggle markdown rendering";
    }
  ];
}
