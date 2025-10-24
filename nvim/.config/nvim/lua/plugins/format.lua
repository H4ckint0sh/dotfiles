return {
	"stevearc/conform.nvim",
	lazy = true,
	-- Optimized event: Load later to speed up startup, relies on manual keymap for quick access
	event = "VeryLazy",
	opts = {
		formatters_by_ft = {
			css = { "prettier" },
			scss = { "prettier" },
			graphql = { "prettier" },
			html = { "prettier" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			json = { "prettier" },
			lua = { "stylua" },
			markdown = { "prettier" },
			-- isort before black is the common standard
			python = { "isort", "black" },
			sql = { "sql-formatter" },
			svelte = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			yaml = { "prettier" },
			astro = { "prettier" },
			handlebars = { "djlint" },
			lua = { "stylua" },
			toml = { "taplo" },
		},
		format_on_save = function(bufnr)
			-- Disable with a global or buffer-local variable
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return {
				timeout_ms = 500, -- Reduced timeout for faster save response
				lsp_format = false, -- Explicitly disable LSP formatting to prefer conform
				lsp_fallback = true,
			}
		end,
	},
	config = function(_, opts)
		local conform = require("conform")
		conform.setup(opts)

		-- Combined and optimized keymap: ASYNC = TRUE is crucial for responsiveness
		vim.keymap.set({ "n", "v" }, "<leader>F", function()
			conform.format({
				lsp_fallback = false,
				async = true, -- MUST be true to prevent UI freeze
				timeout_ms = 2000, -- Increased timeout for stability with slow formatters
			})
		end, { desc = "format file/selection" })

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

		-- Existing Format command is good, already uses async = true
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
