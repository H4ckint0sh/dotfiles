return {
	"Jezda1337/nvim-html-css",
	dependencies = { "saghen/blink.cmp", "nvim-treesitter/nvim-treesitter" }, -- Use this if you're using blink.cmp
	opts = {
		enable_on = { -- Example file types
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
		},
		handlers = {
			definition = {
				bind = "gd",
			},
			hover = {
				bind = "K",
				wrap = true,
				border = "none",
				position = "cursor",
			},
		},
		documentation = {
			auto_show = true,
		},
		style_sheets = {
			"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css",
			"https://cdnjs.cloudflare.com/ajax/libs/bulma/1.0.3/css/bulma.min.css",
			"./index.css", -- `./` refers to the current working directory.
		},
	},
}
