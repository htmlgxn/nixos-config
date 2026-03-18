local o = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true

o.termguicolors = true
o.background = "dark"

o.cursorline = true
o.signcolumn = "yes"

o.laststatus = 3
o.pumheight = 12
o.mouse = "a"
o.splitbelow = true
o.splitright = true
o.ignorecase = true
o.smartcase = true
o.updatetime = 250
o.timeoutlen = 300
o.undofile = true
o.scrolloff = 4
o.sidescrolloff = 8
o.confirm = true
o.clipboard = "unnamedplus"
o.completeopt = { "menu", "menuone", "noselect" }

o.list = true
o.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "›",
  precedes = "‹"
}

o.fillchars = {
  eob = " ",
  fold = "·",
  foldopen = "▾",
  foldclose = "▸",
  foldsep = "│",
  diff = "╱"
}

o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true
