# modules/home/nixvim/plugins/lsp.nix
#
# LSP stack:
#   - nvim-lspconfig via `plugins.lsp` (servers + on-attach keymaps)
#   - conform-nvim for formatting (format-on-save)
#   - nvim-lint for linting (statix, deadnix, shellcheck, markdownlint)
#   - fidget.nvim for LSP progress in the corner
#   - lazydev.nvim for Lua dev experience (vim.* types etc.)
#
_: {
  programs.nixvim = {
    plugins = {
      # ── LSP servers ──────────────────────────────────────────
      lsp = {
        enable = true;
        inlayHints = true;

        servers = {
          bashls.enable = true;
          jsonls.enable = true;
          marksman.enable = true;
          nixd.enable = true;
          yamlls.enable = true;

          lua_ls = {
            enable = true;
            settings.Lua = {
              completion.callSnippet = "Replace";
              diagnostics.globals = ["vim"];
            };
          };
        };

        # Buffer-local keymaps applied on LspAttach.
        # These complement the global <leader>c* bindings in keymaps.nix.
        keymaps.lspBuf = {
          K = "hover";
          gd = "definition";
          gD = "declaration";
          gi = "implementation";
          gr = "references";
          gt = "type_definition";
        };
      };

      # ── Lua development helper ───────────────────────────────
      lazydev = {
        enable = true;
      };

      # ── LSP progress indicator ───────────────────────────────
      fidget = {
        enable = true;
        settings = {
          notification.window.winblend = 0;
          progress.display.progress_icon.pattern = "dots";
        };
      };

      # ── Formatters ───────────────────────────────────────────
      conform-nvim = {
        enable = true;
        settings = {
          notify_on_error = false;
          format_on_save.__raw = ''
            function(bufnr)
              local disabled = { c = true, cpp = true }
              return {
                timeout_ms = 1000,
                lsp_format = disabled[vim.bo[bufnr].filetype] and "never" or "fallback",
              }
            end
          '';
          formatters_by_ft = {
            bash = ["shfmt"];
            json = ["jq"];
            lua = ["stylua"];
            markdown = ["prettier"];
            nix = ["alejandra"];
            sh = ["shfmt"];
            yaml = ["prettier"];
          };
        };
      };

      # ── Linters ──────────────────────────────────────────────
      lint = {
        enable = true;
        lintersByFt = {
          nix = ["statix" "deadnix"];
          bash = ["shellcheck"];
          sh = ["shellcheck"];
          markdown = ["markdownlint"];
        };
        autoCmd = {
          event = ["BufWritePost" "BufReadPost" "InsertLeave"];
        };
      };
    };

    # ── Advertise fold capability for nvim-ufo ────────────────
    # Applied globally via vim.lsp.config("*", ...) so every server
    # picks it up without per-server duplication.
    extraConfigLua = ''
      do
        local caps = vim.lsp.protocol.make_client_capabilities()
        caps.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }
        vim.lsp.config("*", { capabilities = caps })

        -- Diagnostic display tweaks (matches old vim.diagnostic.config)
        vim.diagnostic.config({
          severity_sort = true,
          float = { border = "single" },
          signs = true,
          virtual_text = {
            spacing = 2,
            source = "if_many",
          },
        })
      end
    '';
  };
}
