return {
	"kevinhwang91/nvim-hlslens",
	dependencies = { "petertriho/nvim-scrollbar" },
	config = function()
		require("scrollbar.handlers.search").setup({})
	end,
}
