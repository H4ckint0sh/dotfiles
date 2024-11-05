return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			css = { "prettied" },
			scss = { "prettied" },
			graphql = { "prettied" },
			html = { "prettied" },
			javascript = { "prettied" },
			javascriptreact = { "prettied" },
			json = { "prettied" },
			lua = { "stylua" },
			markdown = { "prettied" },
			python = { "isort", "black" },
			sql = { "sql-formatter" },
			svelte = { "prettied" },
			typescript = { "prettied" },
			typescriptreact = { "prettied" },
			yaml = { "prettier" },
			astro = { "prettied" },
			handlebars = { "djlint" },
			toml = { "taplo" },
		},
		format_on_save = function(bufnr)
			-- Disable with a global or buffer-local variable
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 500, lsp_format = "never" }
		end,
	},
	config = function(_, opts)
		local conform = require("conform")
		conform.setup(opts)

		vim.keymap.set({ "n" }, "<leader>F", function()
			conform.format({
				lsp_fallback = false,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "format file" })

		vim.keymap.set({ "v" }, "<leader>F", function()
			conform.format({
				lsp_fallback = false,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "format selection" })

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})

		vim.api.nvim_create_user_command("Format", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end

			conform.format({ async = true, lsp_fallback = false, range = range })
		end, { range = true })
	end,
}
