return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			"                                        ",
			"                  ██                    ",
			" ▄████▄  ██    ██ ▄▄   ▄███▄▄███▄       ",
			"██▀  ▀██  ██  ██  ██  ██▀ ▀██▀ ▀██      ",
			"██    ██   ████   ██  ██   ██   ██      ",
			"██    ██    ██    ▀██ ██   ██   ██      ",
			"                                        ",
		}

		dashboard.section.buttons.val = {
			dashboard.button("n", "📄 New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "🔎 Find file", "<cmd>FzfLua files<cr>"),
			dashboard.button("g", "🔠 Find text", "<cmd>FzfLua live_grep<cr>"),
			dashboard.button("a", "🎯 Edit this page", "<cmd>e ~/nixos-config/home/gars/nvim/lua/plugins/alpha.lua<cr>"),
			dashboard.button("q", "👋 Quit", "<cmd>qa<cr>"),
		}

		dashboard.config.opts.noautocmd = true

		alpha.setup(dashboard.config)
	end,
}
