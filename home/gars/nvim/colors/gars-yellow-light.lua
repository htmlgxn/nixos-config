-- gars-yellow-light.lua
-- Neovim color theme: gars-yellow-light
-- Warm yellow accents on light cream background.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end
vim.g.colors_name = "gars-yellow-light"
vim.o.termguicolors = true
vim.o.background = "light"

-- ── Palette ────────────────────────────────────────────────────────────────────
local c = {
	-- light base
	background = "#e2dcb0",
	crust = "#c4be86",
	mantle = "#cec894",
	base = "#d8d2a2",
	metal = "#bab478",
	-- surfaces
	surface0 = "#c4bd87",
	surface1 = "#b4ad77",
	surface2 = "#a59e69",
	-- overlays
	overlay0 = "#9e986e",
	overlay1 = "#8a8460",
	overlay2 = "#787252",
	-- text (DARK for light background)
	subtext0 = "#48421e",
	subtext1 = "#332d10",
	text = "#1e1a06",
	-- highlights
	light_yellow = "#f5e070",
	beige = "#e3c220",
	bright = "#c9aa10",
	-- brand
	gold = "#6b5a0a",
	brand = "#c9aa10",
	-- accents
	red = "#b83030",
	orange = "#b85010",
	green = "#507800",
	cyan = "#007090",
	blue = "#1850a0",
	magenta = "#900090",
	pink = "#b0005a",
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
hi("Constant", { fg = c.blue })
hi("String", { fg = c.green })
hi("Character", { fg = c.green })
hi("Number", { fg = c.orange })
hi("Boolean", { fg = c.orange })
hi("Float", { fg = c.orange })

hi("Identifier", { fg = c.text })
hi("Function", { fg = c.blue, bold = true })

hi("Statement", { fg = c.overlay2 })
hi("Conditional", { fg = c.overlay2 })
hi("Repeat", { fg = c.overlay2 })
hi("Label", { fg = c.overlay2 })
hi("Operator", { fg = c.overlay2 })
hi("Keyword", { fg = c.overlay2, bold = true })
hi("Exception", { fg = c.red })

hi("PreProc", { fg = c.magenta })
hi("Include", { fg = c.magenta })
hi("Define", { fg = c.magenta })
hi("Macro", { fg = c.magenta })
hi("PreCondit", { fg = c.magenta })

hi("Type", { fg = c.blue })
hi("StorageClass", { fg = c.blue })
hi("Structure", { fg = c.blue })
hi("Typedef", { fg = c.blue })

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

hi("@constant", { fg = c.blue })
hi("@constant.builtin", { fg = c.blue, bold = true })
hi("@constant.macro", { fg = c.magenta })

hi("@string", { link = "String" })
hi("@string.escape", { fg = c.orange })
hi("@string.special", { fg = c.orange })
hi("@string.regexp", { fg = c.green, bold = true })

hi("@number", { link = "Number" })
hi("@number.float", { link = "Float" })
hi("@boolean", { link = "Boolean" })

hi("@function", { fg = c.blue, bold = true })
hi("@function.builtin", { fg = c.blue, italic = true })
hi("@function.call", { fg = c.overlay2 })
hi("@function.macro", { fg = c.magenta })
hi("@function.method", { fg = c.blue })
hi("@function.method.call", { fg = c.overlay2 })

hi("@constructor", { fg = c.blue })
hi("@operator", { link = "Operator" })

hi("@keyword", { link = "Keyword" })
hi("@keyword.function", { fg = c.overlay2, bold = true })
hi("@keyword.return", { fg = c.pink, bold = true })
hi("@keyword.operator", { fg = c.overlay2 })
hi("@keyword.import", { fg = c.magenta })
hi("@keyword.exception", { fg = c.red })
hi("@keyword.conditional", { fg = c.overlay2 })
hi("@keyword.repeat", { fg = c.overlay2 })

hi("@type", { link = "Type" })
hi("@type.builtin", { fg = c.blue, italic = true })
hi("@type.qualifier", { fg = c.blue, italic = true })
hi("@type.definition", { fg = c.blue, bold = true })

hi("@attribute", { fg = c.magenta })
hi("@property", { fg = c.subtext1 })

hi("@namespace", { fg = c.overlay2 })
hi("@module", { fg = c.overlay2 })

hi("@punctuation.bracket", { fg = c.overlay2 })
hi("@punctuation.delimiter", { fg = c.overlay1 })
hi("@punctuation.special", { fg = c.orange })

hi("@tag", { fg = c.blue })
hi("@tag.attribute", { fg = c.subtext1 })
hi("@tag.delimiter", { fg = c.overlay1 })

hi("@markup.heading", { fg = c.blue, bold = true })
hi("@markup.heading.1", { fg = c.blue, bold = true })
hi("@markup.heading.2", { fg = c.overlay2, bold = true })
hi("@markup.heading.3", { fg = c.overlay2, bold = true })
hi("@markup.heading.4", { fg = c.subtext1, bold = true })
hi("@markup.strong", { bold = true })
hi("@markup.italic", { italic = true })
hi("@markup.strikethrough", { strikethrough = true })
hi("@markup.underline", { underline = true })
hi("@markup.link", { fg = c.blue, underline = true })
hi("@markup.link.url", { fg = c.blue, underline = true })
hi("@markup.raw", { fg = c.green })
hi("@markup.list", { fg = c.overlay2 })
hi("@markup.quote", { fg = c.overlay1, italic = true })

-- ── LSP ────────────────────────────────────────────────────────────────────────
hi("LspReferenceText", { bg = c.base })
hi("LspReferenceRead", { bg = c.base })
hi("LspReferenceWrite", { bg = c.metal, bold = true })
hi("LspSignatureActiveParameter", { fg = c.blue, bold = true })
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
hi("GitSignsChange", { fg = c.blue })
hi("GitSignsDelete", { fg = c.red })
hi("GitSignsAddNr", { fg = c.green })
hi("GitSignsChangeNr", { fg = c.blue })
hi("GitSignsDeleteNr", { fg = c.red })
hi("GitSignsAddLn", { bg = c.mantle })
hi("GitSignsChangeLn", { bg = c.mantle })

-- ── Diff ───────────────────────────────────────────────────────────────────────
hi("DiffAdd", { bg = "#D8E0D0" })
hi("DiffChange", { bg = "#E0DCB8" })
hi("DiffDelete", { fg = c.red, bg = "#E8C8C8" })
hi("DiffText", { bg = "#D0CC98", bold = true })
hi("Added", { fg = c.green })
hi("Changed", { fg = c.blue })
hi("Removed", { fg = c.red })

-- ── Telescope ──────────────────────────────────────────────────────────────────
hi("TelescopeNormal", { fg = c.text, bg = c.crust })
hi("TelescopeBorder", { fg = c.gold, bg = c.crust })
hi("TelescopeTitle", { fg = c.blue, bg = c.crust, bold = true })
hi("TelescopePromptNormal", { fg = c.text, bg = c.mantle })
hi("TelescopePromptBorder", { fg = c.gold, bg = c.mantle })
hi("TelescopePromptTitle", { fg = c.background, bg = c.blue, bold = true })
hi("TelescopePromptPrefix", { fg = c.blue })
hi("TelescopePromptCounter", { fg = c.overlay1 })
hi("TelescopeResultsNormal", { fg = c.subtext0, bg = c.crust })
hi("TelescopeResultsBorder", { fg = c.gold, bg = c.crust })
hi("TelescopeResultsTitle", { fg = c.overlay1, bg = c.crust })
hi("TelescopePreviewNormal", { fg = c.text, bg = c.background })
hi("TelescopePreviewBorder", { fg = c.gold, bg = c.background })
hi("TelescopePreviewTitle", { fg = c.blue, bg = c.background })
hi("TelescopeSelection", { fg = c.text, bg = c.base })
hi("TelescopeSelectionCaret", { fg = c.blue, bg = c.base })
hi("TelescopeMatching", { fg = c.blue, bold = true })

-- ── nvim-tree ──────────────────────────────────────────────────────────────────
hi("NvimTreeNormal", { fg = c.subtext0, bg = c.crust })
hi("NvimTreeNormalFloat", { fg = c.subtext0, bg = c.crust })
hi("NvimTreeRootFolder", { fg = c.blue, bold = true })
hi("NvimTreeFolderName", { fg = c.text })
hi("NvimTreeFolderIcon", { fg = c.gold })
hi("NvimTreeEmptyFolderName", { fg = c.overlay1 })
hi("NvimTreeOpenedFolderName", { fg = c.overlay2 })
hi("NvimTreeFileName", { fg = c.subtext0 })
hi("NvimTreeOpenedFile", { fg = c.text, bold = true })
hi("NvimTreeModifiedFile", { fg = c.orange })
hi("NvimTreeGitDirty", { fg = c.orange })
hi("NvimTreeGitNew", { fg = c.green })
hi("NvimTreeGitDeleted", { fg = c.red })
hi("NvimTreeGitStaged", { fg = c.blue })
hi("NvimTreeIndentMarker", { fg = c.surface0 })
hi("NvimTreeWinSeparator", { fg = c.gold })
hi("NvimTreeCursorLine", { bg = c.base })
hi("NvimTreeSymlink", { fg = c.blue })

-- ── Which-key ──────────────────────────────────────────────────────────────────
hi("WhichKey", { fg = c.blue })
hi("WhichKeyGroup", { fg = c.overlay2 })
hi("WhichKeyDesc", { fg = c.subtext1 })
hi("WhichKeySeparator", { fg = c.surface1 })
hi("WhichKeyFloat", { bg = c.crust })
hi("WhichKeyBorder", { fg = c.gold, bg = c.crust })
hi("WhichKeyTitle", { fg = c.blue, bold = true })
hi("WhichKeyValue", { fg = c.overlay1 })

-- ── nvim-cmp ───────────────────────────────────────────────────────────────────
hi("CmpNormal", { bg = c.mantle })
hi("CmpBorder", { fg = c.gold, bg = c.mantle })
hi("CmpItemAbbr", { fg = c.subtext0 })
hi("CmpItemAbbrMatch", { fg = c.blue, bold = true })
hi("CmpItemAbbrMatchFuzzy", { fg = c.overlay2, bold = true })
hi("CmpItemAbbrDeprecated", { fg = c.surface2, strikethrough = true })
hi("CmpItemMenu", { fg = c.overlay0, italic = true })
hi("CmpItemKindDefault", { fg = c.overlay1 })
hi("CmpItemKindText", { fg = c.text })
hi("CmpItemKindMethod", { fg = c.blue })
hi("CmpItemKindFunction", { fg = c.blue })
hi("CmpItemKindConstructor", { fg = c.blue })
hi("CmpItemKindField", { fg = c.subtext1 })
hi("CmpItemKindVariable", { fg = c.text })
hi("CmpItemKindClass", { fg = c.blue })
hi("CmpItemKindInterface", { fg = c.cyan })
hi("CmpItemKindModule", { fg = c.overlay2 })
hi("CmpItemKindProperty", { fg = c.subtext1 })
hi("CmpItemKindUnit", { fg = c.orange })
hi("CmpItemKindValue", { fg = c.orange })
hi("CmpItemKindEnum", { fg = c.blue })
hi("CmpItemKindKeyword", { fg = c.overlay2 })
hi("CmpItemKindSnippet", { fg = c.green })
hi("CmpItemKindColor", { fg = c.pink })
hi("CmpItemKindFile", { fg = c.subtext0 })
hi("CmpItemKindReference", { fg = c.cyan })
hi("CmpItemKindFolder", { fg = c.gold })
hi("CmpItemKindEnumMember", { fg = c.cyan })
hi("CmpItemKindConstant", { fg = c.cyan })
hi("CmpItemKindStruct", { fg = c.blue })
hi("CmpItemKindEvent", { fg = c.orange })
hi("CmpItemKindOperator", { fg = c.overlay2 })
hi("CmpItemKindTypeParameter", { fg = c.blue })

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
vim.g.gars_yellow_light = c
