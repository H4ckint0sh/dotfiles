return {
	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	name = "lsp_lines.nvim",
	dependencies = { "neovim/nvim-lspconfig" },
	keys = {
		{
			"<Leader>lt",
			function()
				require("lsp_lines").toggle()
			end,
			mode = { "n", "v" },
			desc = "Toggle lsp_lines",
		},
	},
	lazy = true,
	init = function()
		vim.diagnostic.config({ virtual_text = false })
		-- disable virtual lines for the lazy.nvim window
		local LAZY_NAMESPACE = vim.api.nvim_get_namespaces().lazy
		if LAZY_NAMESPACE ~= nil then
			vim.diagnostic.config({
				virtual_text = true,
				virtual_lines = false,
			}, LAZY_NAMESPACE)
		end
		vim.api.nvim_create_autocmd("DiagnosticChanged", {
			callback = function(args)
				if #args.data.diagnostics ~= 0 then
					require("lazy.core.loader").load({ "lsp_lines.nvim" }, { event = "DiagnosticChanged" })
					return true
				end
			end,
		})
	end,
	config = function()
		require("lsp_lines").setup()

		vim.diagnostic.config({ virtual_lines = { highlight_whole_line = false } })
		vim.diagnostic.config({ virtual_lines = false }, vim.api.nvim_create_namespace("lazy"))
	end,
}
