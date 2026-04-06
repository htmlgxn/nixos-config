local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("gars-general", { clear = true })

autocmd("TextYankPost", {
	group = general,
	desc = "Highlight yanked text",
	callback = function()
		vim.highlight.on_yank()
	end,
})

autocmd("BufReadPost", {
	group = general,
	desc = "Restore last cursor position",
	callback = function(args)
		local excluded = { gitcommit = true }
		local buf = args.buf
		local ft = vim.bo[buf].filetype

		if excluded[ft] then
			return
		end

		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local line_count = vim.api.nvim_buf_line_count(buf)

		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = general,
	desc = "Reload buffers changed outside of Neovim",
	command = "checktime",
})

autocmd("FileType", {
	group = general,
	pattern = { "help", "man", "qf", "lspinfo", "startuptime", "checkhealth" },
	desc = "Use q to close utility windows",
	callback = function(args)
		vim.bo[args.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", {
			buffer = args.buf,
			silent = true,
			desc = "Close window",
		})
	end,
})
