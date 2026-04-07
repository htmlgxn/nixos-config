# modules/home/nixvim/plugins/completion.nix
#
# Completion stack:
#   - nvim-cmp with nvim_lsp / luasnip / buffer / path sources
#   - LuaSnip + friendly-snippets
#   - lspkind icons
#   - cmp-autopairs bridge to nvim-autopairs (defined in editor.nix)
#
_: {
  programs.nixvim = {
    plugins = {
      luasnip = {
        enable = true;
        fromVscode = [{}]; # loads friendly-snippets
      };

      friendly-snippets.enable = true;

      lspkind = {
        enable = true;
        cmp.enable = true;
        settings = {
          mode = "symbol_text";
          maxwidth = 50;
          ellipsis_char = "…";
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet.expand = ''
            function(args) require("luasnip").lsp_expand(args.body) end
          '';

          sources = [
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {name = "buffer";}
            {name = "path";}
          ];

          mapping.__raw = ''
            cmp.mapping.preset.insert({
              ["<C-b>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.abort(),
              ["<CR>"] = cmp.mapping.confirm({ select = true }),
              ["<Tab>"] = cmp.mapping(function(fallback)
                local luasnip = require("luasnip")
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                local luasnip = require("luasnip")
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
            })
          '';
        };
      };
    };

    # ── Bridge cmp → nvim-autopairs ────────────────────────────
    extraConfigLua = ''
      do
        local ok_cmp, cmp = pcall(require, "cmp")
        local ok_ap, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
        if ok_cmp and ok_ap then
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
      end
    '';
  };
}
