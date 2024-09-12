return {
	"David-Kunz/cmp-npm",
	config = function()
		require("cmp-npm").setup({
			ignore = {},
			only_semantic_versions = true,
		})
	end,
}
