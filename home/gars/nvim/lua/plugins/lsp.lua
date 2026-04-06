return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = "ConformInfo",
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disabled = { c = true, cpp = true }
				return {
					timeout_ms = 1000,
					lsp_format = disabled[vim.bo[bufnr].filetype] and "never" or "fallback",
				}
			end,
			formatters_by_ft = {
				bash = { "shfmt" },
				json = { "jq" },
				lua = { "stylua" },
				markdown = { "prettier" },
				nix = { "alejandra" },
				sh = { "shfmt" },
				yaml = { "prettier" },
			},
		},
		keys = {
			{
				"<leader>lf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				desc = "Format buffer",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "folke/lazydev.nvim", ft = "lua", opts = {} },
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(_, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("n", "K", vim.lsp.buf.hover, "Hover")
				map("n", "gd", vim.lsp.buf.definition, "Definition")
				map("n", "gD", vim.lsp.buf.declaration, "Declaration")
				map("n", "gi", vim.lsp.buf.implementation, "Implementation")
				map("n", "gr", vim.lsp.buf.references, "References")
				map("n", "<leader>la", vim.lsp.buf.code_action, "Code action")
				map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")
				map("n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
				map("n", "<leader>lj", vim.diagnostic.goto_next, "Next diagnostic")
				map("n", "<leader>lk", vim.diagnostic.goto_prev, "Previous diagnostic")
			end

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "single" },
				signs = true,
				virtual_text = {
					spacing = 2,
					source = "if_many",
				},
			})

			if vim.lsp.inlay_hint then
				vim.lsp.inlay_hint.enable(true)
			end

			local servers = {
				bashls = {},
				jsonls = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
				marksman = {},
				nixd = {},
				yamlls = {},
			}

			for server, server_opts in pairs(servers) do
				server_opts.capabilities = capabilities
				server_opts.on_attach = on_attach
				vim.lsp.config(server, server_opts)
				vim.lsp.enable(server)
			end
		end,
	},
}
