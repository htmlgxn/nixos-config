# modules/home/nixvim/plugins/treesitter.nix
#
# Treesitter (highlighting + indent) plus textobjects for
# treesitter-aware selection and motion (va f, vi c, ]f, [c, …).
#
# nvim-treesitter's `main` branch dropped the module/setup config system:
# highlight/indent are enabled through nixvim's native top-level options,
# and textobjects keymaps are wired through the Neovim keymap API rather
# than a `keymaps` table in plugin settings.
#
{pkgs, ...}: {
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      nixvimInjections = true;
      highlight.enable = true;
      indent.enable = true;

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
      settings = {
        select = {
          lookahead = true;
        };
        move = {
          set_jumps = true;
        };
      };
    };
  };

  # ── `is-not?` predicate shim ──────────────────────────────────
  # Several grammars (nix, javascript) ship highlight queries written
  # for nvim-treesitter's master branch, which used `(#is-not? local)`
  # to skip highlighting nodes shadowed by a local binding. The main
  # branch dropped the locals machinery and now registers only
  # `kind-eq?`/`any-kind-eq?`, so those queries raise "No handler for
  # is-not?" on every redraw of a .nix or .js buffer.
  #
  # Returning true keeps the capture — i.e. the pre-locals behaviour,
  # which is what upstream settled on when it rewrote these queries.
  programs.nixvim.extraConfigLua = ''
    vim.treesitter.query.add_predicate("is-not?", function()
      return true
    end, {force = true, all = false})
  '';

  # ── Textobjects keymaps (new keymap-API style) ────────────────
  # select_textobject derives the mode (visual/operator-pending) at call
  # time, so a single mapping in modes "x" + "o" covers va/vi and da/di.
  programs.nixvim.keymaps = let
    select = query: ''
      function()
        require('nvim-treesitter-textobjects.select').select_textobject('${query}', 'textobjects')
      end
    '';
    move = fn: query: ''
      function()
        require('nvim-treesitter-textobjects.move').${fn}('${query}', 'textobjects')
      end
    '';
    sel = key: query: desc: {
      mode = ["x" "o"];
      inherit key;
      action.__raw = select query;
      options.desc = desc;
    };
    mov = key: fn: query: desc: {
      mode = ["n" "x" "o"];
      inherit key;
      action.__raw = move fn query;
      options.desc = desc;
    };
  in [
    (sel "af" "@function.outer" "Function (outer)")
    (sel "if" "@function.inner" "Function (inner)")
    (sel "ac" "@class.outer" "Class (outer)")
    (sel "ic" "@class.inner" "Class (inner)")
    (sel "aa" "@parameter.outer" "Parameter (outer)")
    (sel "ia" "@parameter.inner" "Parameter (inner)")

    (mov "]f" "goto_next_start" "@function.outer" "Next function start")
    (mov "]c" "goto_next_start" "@class.outer" "Next class start")
    (mov "[f" "goto_previous_start" "@function.outer" "Prev function start")
    (mov "[c" "goto_previous_start" "@class.outer" "Prev class start")
  ];
}
