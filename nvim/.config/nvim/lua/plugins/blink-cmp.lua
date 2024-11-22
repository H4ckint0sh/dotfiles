return {
	"saghen/blink.cmp",
	lazy = false, -- lazy loading handled internally
	-- optional: provides snippets for the snippet source
	dependencies = {
		{ "rafamadriz/friendly-snippets" },
		-- add blink.compat to dependencies
		{ "saghen/blink.compat" },
		-- add source to dependencies
	},
	-- Use nightly build
	build = "cargo +nightly build --release",
	opts = {
		sources = {
			completion = {
				enabled_providers = { "lsp", "path", "snippets", "buffer", "dadbod" },
			},
			providers = {
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
			},
		},
		keymap = {
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},

		highlight = {
			use_nvim_cmp_as_default = true,
		},
		nerd_font_variant = "normal",

		windows = {
			autocomplete = {
				min_width = 25,
				border = "rounded",
				draw = {
					columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
				},
			},
			documentation = {
				border = "rounded",
				auto_show = true,
			},
			signature_help = {
				border = "rounded",
			},
		},

		-- experimental auto-brackets support
		accept = { auto_brackets = { enabled = true } },
	},
}
