return {
	"Jezda1337/nvim-html-css",
	dependencies = { "saghen/blink.cmp", "nvim-treesitter/nvim-treesitter" }, -- Use this if you're using blink.cmp
	opts = {
		enable_on = {
			"txt",
			"html",
			"htmldjango",
			"tsx",
			"jsx",
			"erb",
			"svelte",
			"vue",
			"blade",
			"php",
			"templ",
			"astro",
			"tmpl",
		},
		documentation = {
			auto_show = true,
		},
		style_sheets = {},
	},
}
