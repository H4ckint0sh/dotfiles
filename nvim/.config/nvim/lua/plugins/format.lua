return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			css = { "prettied", "prettier" },
			graphql = { "prettied", "prettier" },
			html = { "prettied", "prettier" },
			javascript = { "prettied", "prettier" },
			javascriptreact = { "prettied", "prettier" },
			json = { "prettied", "prettier" },
			lua = { "stylua" },
			markdown = { "prettied", "prettier" },
			python = { "isort", "black" },
			sql = { "sql-formatter" },
			svelte = { "prettied", "prettier" },
			typescript = { "prettied", "prettier" },
			typescriptreact = { "prettied", "prettier" },
			yaml = { "prettier" },
			astro = { "prettier" },
			handlebars = { "djlint" },
		},
		format_on_save = function(bufnr)
			-- Disable with a global or buffer-local variable
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 3000, lsp_format = "fallback" }
		end,
	},
	config = function(_, opts)
		local conform = require("conform")
		conform.setup(opts)

		vim.keymap.set({ "n" }, "<leader>F", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 2500,
			})
		end, { desc = "format file" })

		vim.keymap.set({ "v" }, "<leader>F", function()
			conform.format({
				lsp_fallback = true,
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

			conform.format({ async = true, lsp_fallback = true, range = range })
		end, { range = true })
	end,
}
