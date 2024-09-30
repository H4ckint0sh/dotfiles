return {
	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	name = "lsp_lines",
	dependencies = { "neovim/nvim-lspconfig" },
	event = "LspAttach",
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
	config = true,
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
	end,
}
