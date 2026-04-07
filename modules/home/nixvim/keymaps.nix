# modules/home/nixvim/keymaps.nix
#
# Top-level keybindings. Plugin-specific mappings (flash, harpoon, trouble,
# spectre, etc.) live alongside their plugin in modules/home/nixvim/plugins/.
#
# Leader       = <space>
# Local leader = \
#
_: {
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    keymaps = let
      # tiny helpers so the list below stays readable
      nmap = key: action: desc: {
        mode = "n";
        inherit key action;
        options = {
          inherit desc;
          silent = true;
        };
      };
      nmapLua = key: lua: desc: {
        mode = "n";
        inherit key;
        action.__raw = lua;
        options = {
          inherit desc;
          silent = true;
        };
      };
      vmap = key: action: desc: {
        mode = "v";
        inherit key action;
        options = {
          inherit desc;
          silent = true;
        };
      };
    in [
      # ── Core: save, quit, new ──────────────────────────────────────
      (nmap "<leader>w" "<cmd>w<cr>" "Write buffer")
      (nmap "<leader>q" "<cmd>confirm q<cr>" "Quit window")
      (nmap "<leader>Q" "<cmd>confirm qa<cr>" "Quit all")
      (nmap "ZS" "<cmd>w<cr>" "Save without quitting")
      (nmap "<leader>n" "<cmd>enew<cr>" "New file")

      # ── Fast-path: fzf-lua directly on leader ─────────────────────
      (nmap "<leader><space>" "<cmd>FzfLua files<cr>" "Find files")
      (nmap "<leader>/" "<cmd>FzfLua live_grep<cr>" "Live grep")
      (nmap "<leader>," "<cmd>FzfLua buffers<cr>" "Switch buffer")
      (nmap "<leader>:" "<cmd>FzfLua command_history<cr>" "Command history")

      # ── Find group (<leader>f) ────────────────────────────────────
      (nmap "<leader>ff" "<cmd>FzfLua files<cr>" "Find files")
      (nmap "<leader>fg" "<cmd>FzfLua live_grep<cr>" "Live grep")
      (nmap "<leader>fb" "<cmd>FzfLua buffers<cr>" "Buffers")
      (nmap "<leader>fh" "<cmd>FzfLua help_tags<cr>" "Help tags")
      (nmap "<leader>fr" "<cmd>FzfLua oldfiles<cr>" "Recent files")
      (nmap "<leader>fk" "<cmd>FzfLua keymaps<cr>" "Keymaps")
      (nmap "<leader>fc" "<cmd>FzfLua commands<cr>" "Commands")
      (nmap "<leader>fw" "<cmd>FzfLua grep_cword<cr>" "Word under cursor")
      (nmap "<leader>fW" "<cmd>FzfLua grep_cWORD<cr>" "WORD under cursor")
      (nmap "<leader>fs" "<cmd>FzfLua lsp_document_symbols<cr>" "Document symbols")
      (nmap "<leader>fS" "<cmd>FzfLua lsp_live_workspace_symbols<cr>" "Workspace symbols")
      (nmap "<leader>fn" "<cmd>NixSearch<cr>" "Search Nix packages")
      (nmap "<leader>f;" "<cmd>FzfLua resume<cr>" "Resume last picker")

      # localleader mirrors for the things you use most
      (nmap "<localleader>ff" "<cmd>FzfLua files<cr>" "Find files")
      (nmap "<localleader>fg" "<cmd>FzfLua live_grep<cr>" "Live grep")
      (nmap "<localleader>fb" "<cmd>FzfLua buffers<cr>" "Buffers")
      (nmap "<localleader>fh" "<cmd>FzfLua help_tags<cr>" "Help tags")
      (nmap "<localleader>fn" "<cmd>NixSearch<cr>" "Search Nix packages")

      # ── Buffer group (<leader>b) ───────────────────────────────────
      # bd / bD (delete) are defined in plugins/editor.nix via mini.bufremove
      (nmap "<leader>bn" "<cmd>bnext<cr>" "Next buffer")
      (nmap "<leader>bp" "<cmd>bprevious<cr>" "Previous buffer")
      (nmap "<leader>bb" "<cmd>FzfLua buffers<cr>" "Switch buffer")
      (nmap "<leader>bo" "<cmd>%bdelete|edit #|bdelete #<cr>" "Close other buffers")
      (nmap "[b" "<cmd>bprevious<cr>" "Previous buffer")
      (nmap "]b" "<cmd>bnext<cr>" "Next buffer")

      # ── Code/LSP group (<leader>c) ────────────────────────────────
      # Most LSP actions (K, gd, gr, etc.) attach in plugins/lsp.nix via
      # LspAttach; these are the leader-prefixed aliases for discoverability.
      (nmapLua "<leader>cf"
        ''function() require("conform").format({ async = true, lsp_format = "fallback" }) end''
        "Format buffer")
      (nmap "<leader>ca" "<cmd>lua vim.lsp.buf.code_action()<cr>" "Code action")
      (nmap "<leader>cr" "<cmd>lua vim.lsp.buf.rename()<cr>" "Rename symbol")
      (nmap "<leader>cd" "<cmd>lua vim.diagnostic.open_float()<cr>" "Line diagnostic")
      (nmapLua "<leader>ci"
        ''function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end''
        "Toggle inlay hints")

      # ── Diagnostic navigation (unimpaired-style) ──────────────────
      (nmapLua "]d" ''function() vim.diagnostic.jump({ count = 1 }) end'' "Next diagnostic")
      (nmapLua "[d" ''function() vim.diagnostic.jump({ count = -1 }) end'' "Previous diagnostic")
      (nmapLua "]e"
        ''function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end''
        "Next error")
      (nmapLua "[e"
        ''function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end''
        "Previous error")
      (nmapLua "]w"
        ''function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN }) end''
        "Next warning")
      (nmapLua "[w"
        ''function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN }) end''
        "Previous warning")

      # ── Window group (<leader>W, capital — leader w = save) ──────
      (nmap "<leader>Ws" "<cmd>split<cr>" "Horizontal split")
      (nmap "<leader>Wv" "<cmd>vsplit<cr>" "Vertical split")
      (nmap "<leader>Wc" "<cmd>close<cr>" "Close window")
      (nmap "<leader>Wo" "<cmd>only<cr>" "Only this window")
      (nmap "<leader>W=" "<C-w>=" "Equalize windows")

      # ── Oil ────────────────────────────────────────────────────────
      (nmap "-" "<cmd>Oil<cr>" "Open parent directory")
      (nmap "<leader>e" "<cmd>Oil<cr>" "File explorer (Oil)")

      # ── Better defaults ───────────────────────────────────────────
      (nmap "<Esc>" "<cmd>nohlsearch<cr>" "Clear search highlight")
      (nmap "n" "nzzzv" "Next match (centered)")
      (nmap "N" "Nzzzv" "Previous match (centered)")
      (nmap "<C-d>" "<C-d>zz" "Half page down (centered)")
      (nmap "<C-u>" "<C-u>zz" "Half page up (centered)")
      (nmap "J" "mzJ`z" "Join line (preserve cursor)")

      # Visual mode QoL
      (vmap "<" "<gv" "Unindent (keep selection)")
      (vmap ">" ">gv" "Indent (keep selection)")
      (vmap "J" ":m '>+1<cr>gv=gv" "Move selection down")
      (vmap "K" ":m '<-2<cr>gv=gv" "Move selection up")
      (vmap "p" "\"_dP" "Paste without yanking selection")
    ];
  };
}
