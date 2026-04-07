# modules/home/nixvim/plugins/alpha.nix
#
# Dashboard. Header art and existing five buttons are preserved
# byte-identically from the old lua config. Two new buttons added:
#   r → Recent files
#   s → Restore session (requires persistence.nvim from editor.nix)
#
_: {
  programs.nixvim.plugins.alpha = {
    enable = true;
    settings = {
      layout = [
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = [
            "                                        "
            "                  ██                    "
            " ▄████▄  ██    ██ ▄▄   ▄███▄▄███▄       "
            "██▀  ▀██  ██  ██  ██  ██▀ ▀██▀ ▀██      "
            "██    ██   ████   ██  ██   ██   ██      "
            "██    ██    ██    ▀██ ██   ██   ██      "
            "                                        "
          ];
          opts = {
            position = "center";
            hl = "AlphaHeader";
          };
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "group";
          val = [
            {
              type = "button";
              val = "📄 New file";
              on_press.__raw = ''function() vim.cmd("ene | startinsert") end'';
              opts = {
                shortcut = "n";
                position = "center";
                width = 40;
                cursor = 3;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
                keymap = [
                  "n"
                  "n"
                  "<cmd>ene | startinsert<cr>"
                  {
                    noremap = true;
                    silent = true;
                    nowait = true;
                  }
                ];
              };
            }
            {
              type = "button";
              val = "🔎 Find file";
              on_press.__raw = ''function() require("fzf-lua").files() end'';
              opts = {
                shortcut = "f";
                position = "center";
                width = 40;
                cursor = 3;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
                keymap = [
                  "n"
                  "f"
                  "<cmd>FzfLua files<cr>"
                  {
                    noremap = true;
                    silent = true;
                    nowait = true;
                  }
                ];
              };
            }
            {
              type = "button";
              val = "🔠 Find text";
              on_press.__raw = ''function() require("fzf-lua").live_grep() end'';
              opts = {
                shortcut = "g";
                position = "center";
                width = 40;
                cursor = 3;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
                keymap = [
                  "n"
                  "g"
                  "<cmd>FzfLua live_grep<cr>"
                  {
                    noremap = true;
                    silent = true;
                    nowait = true;
                  }
                ];
              };
            }
            {
              type = "button";
              val = "🕐 Recent files";
              on_press.__raw = ''function() require("fzf-lua").oldfiles() end'';
              opts = {
                shortcut = "r";
                position = "center";
                width = 40;
                cursor = 3;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
                keymap = [
                  "n"
                  "r"
                  "<cmd>FzfLua oldfiles<cr>"
                  {
                    noremap = true;
                    silent = true;
                    nowait = true;
                  }
                ];
              };
            }
            {
              type = "button";
              val = "💾 Restore session";
              on_press.__raw = ''function() require("persistence").load() end'';
              opts = {
                shortcut = "s";
                position = "center";
                width = 40;
                cursor = 3;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
                keymap = [
                  "n"
                  "s"
                  "<cmd>lua require('persistence').load()<cr>"
                  {
                    noremap = true;
                    silent = true;
                    nowait = true;
                  }
                ];
              };
            }
            {
              type = "button";
              val = "🎯 Edit this page";
              on_press.__raw = ''
                function()
                  vim.cmd("e ~/nixos-config/modules/home/nixvim/plugins/alpha.nix")
                end
              '';
              opts = {
                shortcut = "a";
                position = "center";
                width = 40;
                cursor = 3;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
                keymap = [
                  "n"
                  "a"
                  "<cmd>e ~/nixos-config/modules/home/nixvim/plugins/alpha.nix<cr>"
                  {
                    noremap = true;
                    silent = true;
                    nowait = true;
                  }
                ];
              };
            }
            {
              type = "button";
              val = "👋 Quit";
              on_press.__raw = ''function() vim.cmd("qa") end'';
              opts = {
                shortcut = "q";
                position = "center";
                width = 40;
                cursor = 3;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
                keymap = [
                  "n"
                  "q"
                  "<cmd>qa<cr>"
                  {
                    noremap = true;
                    silent = true;
                    nowait = true;
                  }
                ];
              };
            }
          ];
        }
      ];
    };
  };
}
