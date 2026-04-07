# modules/home/nixvim/options.nix
#
# Direct port of lua/config/options.lua.
# Leader globals are set in ./keymaps.nix.
#
_: {
  programs.nixvim.opts = {
    # ── Line numbers ─────────────────────────────────────────────
    number = true;
    relativenumber = true;

    # ── Colors ───────────────────────────────────────────────────
    termguicolors = true;
    background = "dark";

    # ── UI ───────────────────────────────────────────────────────
    cursorline = true;
    signcolumn = "yes";
    laststatus = 3;
    pumheight = 12;
    mouse = "a";

    # ── Splits ───────────────────────────────────────────────────
    splitbelow = true;
    splitright = true;

    # ── Search ───────────────────────────────────────────────────
    ignorecase = true;
    smartcase = true;

    # ── Editing ──────────────────────────────────────────────────
    updatetime = 250;
    timeoutlen = 300;
    undofile = true;
    scrolloff = 4;
    sidescrolloff = 8;
    confirm = true;
    clipboard = "unnamedplus";
    completeopt = ["menu" "menuone" "noselect"];

    # ── Whitespace visualization ─────────────────────────────────
    list = true;
    listchars = {
      tab = "→ ";
      trail = "·";
      nbsp = "␣";
      extends = "›";
      precedes = "‹";
    };

    # ── Fill characters ──────────────────────────────────────────
    fillchars = {
      eob = " ";
      fold = "·";
      foldopen = "▾";
      foldclose = "▸";
      foldsep = "│";
      diff = "╱";
    };

    # ── Folding (paired with nvim-ufo) ───────────────────────────
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
    foldcolumn = "1"; # ufo needs a visible fold column
  };
}
