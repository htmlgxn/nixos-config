# modules/home/nixvim/plugins/fzf.nix
#
# fzf-lua: in-editor fuzzy finder. Keymaps live in ../keymaps.nix
# and ../plugins/git.nix; this file just configures the plugin and
# preserves the :NixSearch custom command from the old lua config.
#
_: {
  programs.nixvim = {
    plugins.fzf-lua = {
      enable = true;
      settings = {
        winopts = {
          preview = {
            default = "bat";
          };
        };
      };
    };

    # ── :NixSearch custom command ──────────────────────────────
    # Direct port of the old lua/plugins/fzf.lua command.
    extraConfigLua = ''
      do
        local function normalize_nix_entry(entry)
          local normalized = entry:gsub("^nixpkgs/", "")
          return normalized
        end

        local function nix_search()
          local ok, fzf_lua = pcall(require, "fzf-lua")
          if not ok then return end
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
      end
    '';
  };
}
