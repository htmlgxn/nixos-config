-- gars-yellow.lua
-- Place at: ~/.config/nvim/colors/gars-yellow.lua
-- Usage: vim.cmd("colorscheme gars-yellow")  or  :colorscheme gars-yellow

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end
vim.g.colors_name = "gars-yellow"
vim.o.termguicolors = true
vim.o.background = "dark"

-- ── Palette ────────────────────────────────────────────────────────────────────
local c = {
	-- dark base
	background = "#1E1904",
	crust = "#262418",
	mantle = "#322F1F",
	base = "#3B3724",
	metal = "#413C1E",
	-- surfaces
	surface0 = "#5B5742",
	surface1 = "#6E6951",
	surface2 = "#807B62",
	-- overlays
	overlay0 = "#8C876D",
	overlay1 = "#A29C7F",
	overlay2 = "#B7B193",
	-- text
	subtext0 = "#CBC4A3",
	subtext1 = "#DED7B4",
	text = "#F6EEC9",
	-- highlights
	light_yellow = "#EFDD84",
	beige = "#F8EBAC",
	bright = "#FCF9E8",
	-- brand
	gold = "#826F11",
	brand = "#E3C220",
	-- accents
	red = "#EF8484",
	orange = "#EF9F76",
	green = "#E4EF84",
	cyan = "#84E0EF",
	blue = "#84BAEF",
	magenta = "#F4B8E4",
	pink = "#EF84AC",
	-- special
	none = "NONE",
}

-- ── Helper ─────────────────────────────────────────────────────────────────────
local function hi(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor chrome ──────────────────────────────────────────────────────────────
hi("Normal", { fg = c.text, bg = c.background })
hi("NormalFloat", { fg = c.text, bg = c.crust })
hi("NormalNC", { fg = c.subtext0, bg = c.background })
hi("FloatBorder", { fg = c.gold, bg = c.crust })
hi("FloatTitle", { fg = c.brand, bg = c.crust, bold = true })

hi("LineNr", { fg = c.surface1 })
hi("LineNrAbove", { fg = c.surface0 })
hi("LineNrBelow", { fg = c.surface0 })
hi("CursorLine", { bg = c.crust })
hi("CursorLineNr", { fg = c.brand, bg = c.crust, bold = true })
hi("CursorColumn", { bg = c.crust })
hi("ColorColumn", { bg = c.mantle })

hi("SignColumn", { fg = c.surface1, bg = c.background })
hi("FoldColumn", { fg = c.surface1, bg = c.background })
hi("Folded", { fg = c.overlay1, bg = c.mantle })

hi("StatusLine", { fg = c.text, bg = c.crust })
hi("StatusLineNC", { fg = c.overlay1, bg = c.crust })
hi("WinSeparator", { fg = c.gold })
hi("VertSplit", { fg = c.gold })

hi("TabLine", { fg = c.overlay1, bg = c.crust })
hi("TabLineSel", { fg = c.text, bg = c.base, bold = true })
hi("TabLineFill", { bg = c.crust })

hi("Pmenu", { fg = c.subtext1, bg = c.mantle })
hi("PmenuSel", { fg = c.text, bg = c.base, bold = true })
hi("PmenuSbar", { bg = c.surface0 })
hi("PmenuThumb", { bg = c.overlay1 })
hi("PmenuKind", { fg = c.brand, bg = c.mantle })
hi("PmenuKindSel", { fg = c.brand, bg = c.base })
hi("PmenuExtra", { fg = c.overlay1, bg = c.mantle })
hi("PmenuExtraSel", { fg = c.overlay2, bg = c.base })

hi("WildMenu", { fg = c.background, bg = c.brand })

hi("Visual", { bg = c.base })
hi("VisualNOS", { bg = c.base })
hi("Search", { fg = c.background, bg = c.brand })
hi("CurSearch", { fg = c.background, bg = c.light_yellow, bold = true })
hi("IncSearch", { fg = c.background, bg = c.light_yellow, bold = true })
hi("Substitute", { fg = c.background, bg = c.orange })

hi("MatchParen", { fg = c.brand, bg = c.base, bold = true })

hi("NonText", { fg = c.surface1 })
hi("Whitespace", { fg = c.surface0 })
hi("SpecialKey", { fg = c.surface1 })
hi("EndOfBuffer", { fg = c.surface0 })
hi("Conceal", { fg = c.overlay0 })

hi("Directory", { fg = c.brand, bold = true })
hi("Title", { fg = c.brand, bold = true })
hi("Question", { fg = c.green })
hi("MoreMsg", { fg = c.green })
hi("ModeMsg", { fg = c.text, bold = true })
hi("MsgArea", { fg = c.subtext1 })
hi("MsgSeparator", { fg = c.gold, bg = c.crust })
hi("ErrorMsg", { fg = c.red, bold = true })
hi("WarningMsg", { fg = c.orange })

hi("SpellBad", { sp = c.red, undercurl = true })
hi("SpellCap", { sp = c.blue, undercurl = true })
hi("SpellLocal", { sp = c.cyan, undercurl = true })
hi("SpellRare", { sp = c.magenta, undercurl = true })

-- ── Syntax ─────────────────────────────────────────────────────────────────────
hi("Comment", { fg = c.surface2, italic = true })
hi("Constant", { fg = c.cyan })
hi("String", { fg = c.green })
hi("Character", { fg = c.green })
hi("Number", { fg = c.orange })
hi("Boolean", { fg = c.orange })
hi("Float", { fg = c.orange })

hi("Identifier", { fg = c.text })
hi("Function", { fg = c.brand, bold = true })

hi("Statement", { fg = c.light_yellow })
hi("Conditional", { fg = c.light_yellow })
hi("Repeat", { fg = c.light_yellow })
hi("Label", { fg = c.light_yellow })
hi("Operator", { fg = c.overlay2 })
hi("Keyword", { fg = c.light_yellow, bold = true })
hi("Exception", { fg = c.red })

hi("PreProc", { fg = c.pink })
hi("Include", { fg = c.pink })
hi("Define", { fg = c.pink })
hi("Macro", { fg = c.pink })
hi("PreCondit", { fg = c.pink })

hi("Type", { fg = c.beige })
hi("StorageClass", { fg = c.beige })
hi("Structure", { fg = c.beige })
hi("Typedef", { fg = c.beige })

hi("Special", { fg = c.orange })
hi("SpecialChar", { fg = c.orange })
hi("Tag", { fg = c.brand })
hi("Delimiter", { fg = c.overlay2 })
hi("SpecialComment", { fg = c.overlay1, italic = true })
hi("Debug", { fg = c.red })

hi("Underlined", { underline = true })
hi("Ignore", { fg = c.surface0 })
hi("Error", { fg = c.red, bold = true })
hi("Todo", { fg = c.background, bg = c.brand, bold = true })

-- ── Treesitter ─────────────────────────────────────────────────────────────────
hi("@comment", { link = "Comment" })
hi("@comment.documentation", { fg = c.overlay1, italic = true })
hi("@error", { link = "Error" })

hi("@variable", { fg = c.text })
hi("@variable.builtin", { fg = c.orange, italic = true })
hi("@variable.parameter", { fg = c.subtext1 })
hi("@variable.member", { fg = c.subtext0 })

hi("@constant", { fg = c.cyan })
hi("@constant.builtin", { fg = c.cyan, bold = true })
hi("@constant.macro", { fg = c.pink })

hi("@string", { link = "String" })
hi("@string.escape", { fg = c.orange })
hi("@string.special", { fg = c.orange })
hi("@string.regexp", { fg = c.green, bold = true })

hi("@number", { link = "Number" })
hi("@number.float", { link = "Float" })
hi("@boolean", { link = "Boolean" })

hi("@function", { fg = c.brand, bold = true })
hi("@function.builtin", { fg = c.brand, italic = true })
hi("@function.call", { fg = c.light_yellow })
hi("@function.macro", { fg = c.pink })
hi("@function.method", { fg = c.brand })
hi("@function.method.call", { fg = c.light_yellow })

hi("@constructor", { fg = c.beige })
hi("@operator", { link = "Operator" })

hi("@keyword", { link = "Keyword" })
hi("@keyword.function", { fg = c.light_yellow, bold = true })
hi("@keyword.return", { fg = c.pink, bold = true })
hi("@keyword.operator", { fg = c.overlay2 })
hi("@keyword.import", { fg = c.pink })
hi("@keyword.exception", { fg = c.red })
hi("@keyword.conditional", { fg = c.light_yellow })
hi("@keyword.repeat", { fg = c.light_yellow })

hi("@type", { link = "Type" })
hi("@type.builtin", { fg = c.beige, italic = true })
hi("@type.qualifier", { fg = c.beige, italic = true })
hi("@type.definition", { fg = c.beige, bold = true })

hi("@attribute", { fg = c.magenta })
hi("@property", { fg = c.subtext1 })

hi("@namespace", { fg = c.overlay2 })
hi("@module", { fg = c.overlay2 })

hi("@punctuation.bracket", { fg = c.overlay2 })
hi("@punctuation.delimiter", { fg = c.overlay1 })
hi("@punctuation.special", { fg = c.orange })

hi("@tag", { fg = c.brand })
hi("@tag.attribute", { fg = c.subtext1 })
hi("@tag.delimiter", { fg = c.overlay1 })

hi("@markup.heading", { fg = c.brand, bold = true })
hi("@markup.heading.1", { fg = c.brand, bold = true })
hi("@markup.heading.2", { fg = c.light_yellow, bold = true })
hi("@markup.heading.3", { fg = c.beige, bold = true })
hi("@markup.heading.4", { fg = c.subtext1, bold = true })
hi("@markup.strong", { bold = true })
hi("@markup.italic", { italic = true })
hi("@markup.strikethrough", { strikethrough = true })
hi("@markup.underline", { underline = true })
hi("@markup.link", { fg = c.cyan, underline = true })
hi("@markup.link.url", { fg = c.blue, underline = true })
hi("@markup.raw", { fg = c.green })
hi("@markup.list", { fg = c.overlay2 })
hi("@markup.quote", { fg = c.overlay1, italic = true })

-- ── LSP ────────────────────────────────────────────────────────────────────────
hi("LspReferenceText", { bg = c.base })
hi("LspReferenceRead", { bg = c.base })
hi("LspReferenceWrite", { bg = c.metal, bold = true })
hi("LspSignatureActiveParameter", { fg = c.brand, bold = true })
hi("LspInlayHint", { fg = c.surface2, bg = c.crust, italic = true })
hi("LspCodeLens", { fg = c.surface2, italic = true })

-- Diagnostics
hi("DiagnosticError", { fg = c.red })
hi("DiagnosticWarn", { fg = c.orange })
hi("DiagnosticInfo", { fg = c.blue })
hi("DiagnosticHint", { fg = c.cyan })
hi("DiagnosticOk", { fg = c.green })

hi("DiagnosticVirtualTextError", { fg = c.red, bg = c.crust, italic = true })
hi("DiagnosticVirtualTextWarn", { fg = c.orange, bg = c.crust, italic = true })
hi("DiagnosticVirtualTextInfo", { fg = c.blue, bg = c.crust, italic = true })
hi("DiagnosticVirtualTextHint", { fg = c.cyan, bg = c.crust, italic = true })

hi("DiagnosticUnderlineError", { sp = c.red, undercurl = true })
hi("DiagnosticUnderlineWarn", { sp = c.orange, undercurl = true })
hi("DiagnosticUnderlineInfo", { sp = c.blue, undercurl = true })
hi("DiagnosticUnderlineHint", { sp = c.cyan, undercurl = true })

hi("DiagnosticSignError", { fg = c.red })
hi("DiagnosticSignWarn", { fg = c.orange })
hi("DiagnosticSignInfo", { fg = c.blue })
hi("DiagnosticSignHint", { fg = c.cyan })

-- ── Git signs (gitsigns.nvim) ──────────────────────────────────────────────────
hi("GitSignsAdd", { fg = c.green })
hi("GitSignsChange", { fg = c.brand })
hi("GitSignsDelete", { fg = c.red })
hi("GitSignsAddNr", { fg = c.green })
hi("GitSignsChangeNr", { fg = c.brand })
hi("GitSignsDeleteNr", { fg = c.red })
hi("GitSignsAddLn", { bg = c.mantle })
hi("GitSignsChangeLn", { bg = c.mantle })

-- ── Diff ───────────────────────────────────────────────────────────────────────
hi("DiffAdd", { bg = "#2B3320" })
hi("DiffChange", { bg = "#2E2B10" })
hi("DiffDelete", { fg = c.red, bg = "#3A1A1A" })
hi("DiffText", { bg = "#3D3910", bold = true })
hi("Added", { fg = c.green })
hi("Changed", { fg = c.brand })
hi("Removed", { fg = c.red })

-- ── Telescope ──────────────────────────────────────────────────────────────────
hi("TelescopeNormal", { fg = c.text, bg = c.crust })
hi("TelescopeBorder", { fg = c.gold, bg = c.crust })
hi("TelescopeTitle", { fg = c.brand, bg = c.crust, bold = true })
hi("TelescopePromptNormal", { fg = c.text, bg = c.mantle })
hi("TelescopePromptBorder", { fg = c.gold, bg = c.mantle })
hi("TelescopePromptTitle", { fg = c.background, bg = c.brand, bold = true })
hi("TelescopePromptPrefix", { fg = c.brand })
hi("TelescopePromptCounter", { fg = c.overlay1 })
hi("TelescopeResultsNormal", { fg = c.subtext0, bg = c.crust })
hi("TelescopeResultsBorder", { fg = c.gold, bg = c.crust })
hi("TelescopeResultsTitle", { fg = c.overlay1, bg = c.crust })
hi("TelescopePreviewNormal", { fg = c.text, bg = c.background })
hi("TelescopePreviewBorder", { fg = c.gold, bg = c.background })
hi("TelescopePreviewTitle", { fg = c.brand, bg = c.background })
hi("TelescopeSelection", { fg = c.text, bg = c.base })
hi("TelescopeSelectionCaret", { fg = c.brand, bg = c.base })
hi("TelescopeMatching", { fg = c.brand, bold = true })

-- ── nvim-tree ──────────────────────────────────────────────────────────────────
hi("NvimTreeNormal", { fg = c.subtext0, bg = c.crust })
hi("NvimTreeNormalFloat", { fg = c.subtext0, bg = c.crust })
hi("NvimTreeRootFolder", { fg = c.brand, bold = true })
hi("NvimTreeFolderName", { fg = c.text })
hi("NvimTreeFolderIcon", { fg = c.gold })
hi("NvimTreeEmptyFolderName", { fg = c.overlay1 })
hi("NvimTreeOpenedFolderName", { fg = c.light_yellow })
hi("NvimTreeFileName", { fg = c.subtext0 })
hi("NvimTreeOpenedFile", { fg = c.text, bold = true })
hi("NvimTreeModifiedFile", { fg = c.orange })
hi("NvimTreeGitDirty", { fg = c.orange })
hi("NvimTreeGitNew", { fg = c.green })
hi("NvimTreeGitDeleted", { fg = c.red })
hi("NvimTreeGitStaged", { fg = c.brand })
hi("NvimTreeIndentMarker", { fg = c.surface0 })
hi("NvimTreeWinSeparator", { fg = c.gold })
hi("NvimTreeCursorLine", { bg = c.base })
hi("NvimTreeSymlink", { fg = c.cyan })

-- ── Which-key ──────────────────────────────────────────────────────────────────
hi("WhichKey", { fg = c.brand })
hi("WhichKeyGroup", { fg = c.light_yellow })
hi("WhichKeyDesc", { fg = c.subtext1 })
hi("WhichKeySeparator", { fg = c.surface1 })
hi("WhichKeyFloat", { bg = c.crust })
hi("WhichKeyBorder", { fg = c.gold, bg = c.crust })
hi("WhichKeyTitle", { fg = c.brand, bold = true })
hi("WhichKeyValue", { fg = c.overlay1 })

-- ── nvim-cmp ───────────────────────────────────────────────────────────────────
hi("CmpNormal", { bg = c.mantle })
hi("CmpBorder", { fg = c.gold, bg = c.mantle })
hi("CmpItemAbbr", { fg = c.subtext0 })
hi("CmpItemAbbrMatch", { fg = c.brand, bold = true })
hi("CmpItemAbbrMatchFuzzy", { fg = c.light_yellow, bold = true })
hi("CmpItemAbbrDeprecated", { fg = c.surface2, strikethrough = true })
hi("CmpItemMenu", { fg = c.overlay0, italic = true })
hi("CmpItemKindDefault", { fg = c.overlay1 })
hi("CmpItemKindText", { fg = c.text })
hi("CmpItemKindMethod", { fg = c.brand })
hi("CmpItemKindFunction", { fg = c.brand })
hi("CmpItemKindConstructor", { fg = c.beige })
hi("CmpItemKindField", { fg = c.subtext1 })
hi("CmpItemKindVariable", { fg = c.text })
hi("CmpItemKindClass", { fg = c.beige })
hi("CmpItemKindInterface", { fg = c.cyan })
hi("CmpItemKindModule", { fg = c.overlay2 })
hi("CmpItemKindProperty", { fg = c.subtext1 })
hi("CmpItemKindUnit", { fg = c.orange })
hi("CmpItemKindValue", { fg = c.orange })
hi("CmpItemKindEnum", { fg = c.beige })
hi("CmpItemKindKeyword", { fg = c.light_yellow })
hi("CmpItemKindSnippet", { fg = c.green })
hi("CmpItemKindColor", { fg = c.pink })
hi("CmpItemKindFile", { fg = c.subtext0 })
hi("CmpItemKindReference", { fg = c.cyan })
hi("CmpItemKindFolder", { fg = c.gold })
hi("CmpItemKindEnumMember", { fg = c.cyan })
hi("CmpItemKindConstant", { fg = c.cyan })
hi("CmpItemKindStruct", { fg = c.beige })
hi("CmpItemKindEvent", { fg = c.orange })
hi("CmpItemKindOperator", { fg = c.overlay2 })
hi("CmpItemKindTypeParameter", { fg = c.beige })

-- ── indent-blankline ───────────────────────────────────────────────────────────
hi("IblIndent", { fg = c.surface0 })
hi("IblScope", { fg = c.gold })
hi("IblWhitespace", { fg = c.surface0 })

-- ── Notify ─────────────────────────────────────────────────────────────────────
hi("NotifyERRORBorder", { fg = c.red })
hi("NotifyWARNBorder", { fg = c.orange })
hi("NotifyINFOBorder", { fg = c.blue })
hi("NotifyDEBUGBorder", { fg = c.surface2 })
hi("NotifyTRACEBorder", { fg = c.magenta })
hi("NotifyERRORIcon", { fg = c.red })
hi("NotifyWARNIcon", { fg = c.orange })
hi("NotifyINFOIcon", { fg = c.blue })
hi("NotifyDEBUGIcon", { fg = c.surface2 })
hi("NotifyTRACEIcon", { fg = c.magenta })
hi("NotifyERRORTitle", { fg = c.red, bold = true })
hi("NotifyWARNTitle", { fg = c.orange, bold = true })
hi("NotifyINFOTitle", { fg = c.blue, bold = true })
hi("NotifyDEBUGTitle", { fg = c.surface2 })
hi("NotifyTRACETitle", { fg = c.magenta })
hi("NotifyERRORBody", { fg = c.text })
hi("NotifyWARNBody", { fg = c.text })
hi("NotifyINFOBody", { fg = c.text })
hi("NotifyDEBUGBody", { fg = c.text })
hi("NotifyTRACEBody", { fg = c.text })

-- ── lualine helper colors (exposed as global for init.lua) ─────────────────────
vim.g.gars_yellow = c
