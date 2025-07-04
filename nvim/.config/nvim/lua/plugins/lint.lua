return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			html = { "eslint" },
			svelte = { "eslint" },
			css = { "eslint" },
			scss = { "eslint" },
			handlebars = { "djlint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint(nil, { ignore_errors = true })
			end,
		})

		vim.keymap.set("n", "<leader>ln", function()
			lint.try_lint(niil, { ignore_errors = true })
		end, { desc = "lint file" })
	end,
}
