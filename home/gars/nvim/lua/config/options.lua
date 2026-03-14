local o = vim.opt

vim.opt.number = true
vim.opt.relativenumber = true

o.termguicolors = true
o.background = "dark"

o.cursorline = true
o.signcolumn = "yes"

o.laststatus = 3
o.pumheight = 12

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
