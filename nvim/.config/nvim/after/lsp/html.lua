return {
	init_options = {
		provideFormatter = false,
		embeddedLanguages = { css = true, javascript = true },
		configurationSection = { "html", "css", "javascript" },
	},
	settings = {
		html = {
			hover = {
				documentation = true,
				references = true,
			},
		},
	},
}
