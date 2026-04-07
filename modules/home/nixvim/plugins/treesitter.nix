# modules/home/nixvim/plugins/treesitter.nix
#
# Treesitter (highlighting + indent) plus textobjects for
# treesitter-aware selection and motion (va f, vi c, ]f, [c, …).
#
{pkgs, ...}: {
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      settings = {
        nixvimInjections = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };

        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          # Existing set
          bash
          json
          lua
          markdown
          markdown-inline
          nix
          query
          regex
          toml
          vim
          vimdoc
          yaml

          # Additions for broader coverage
          rust
          python
          javascript
          typescript
          tsx
          html
          css
          dockerfile
          diff
          gitcommit
          gitignore
        ];
      };

      treesitter-textobjects = {
        enable = true;
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
          };
        };
        move = {
          enable = true;
          set_jumps = true;
          goto_next_start = {
            "]f" = "@function.outer";
            "]c" = "@class.outer";
          };
          goto_previous_start = {
            "[f" = "@function.outer";
            "[c" = "@class.outer";
          };
        };
      };
    };
  };
}
