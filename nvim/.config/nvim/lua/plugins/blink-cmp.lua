return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	-- optional: provides snippets for the snippet source
	dependencies = {
		-- add blink.compat to dependencies
		{ "saghen/blink.compat" },
		-- add source to dependencies
	},
	-- Use nightly build
	build = "cargo +nightly build --release",
	opts = {
		enabled = function()
			local disabled_filetypes = { "NvimTree", "snacks_input", "snacks_picker_input" } -- Add extra fileypes you do not want blink enabled.
			return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
		end,
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "normal",
		},
		completion = {
			menu = {
				min_width = 25,
				border = "rounded",
				draw = {
					columns = { { "label", "label_description", gap = 4 }, { "kind_icon", gap = 1, "kind" } },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = {
					border = "rounded",
					winhighlight = "FloatBorder:boolean",
				},
			},

			accept = {
				-- Experimental auto-brackets support
				auto_brackets = {
					-- Whether to auto-insert brackets for functions
					enabled = true,
					-- Default brackets to use for unknown languages
					default_brackets = { "(", ")" },
					-- Overrides the default blocked filetypes
					override_brackets_for_filetypes = {},
					-- Synchronously use the kind of the item to determine if brackets should be added
					kind_resolution = {
						enabled = true,
						blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
					},
					-- Asynchronously use semantic token to determine if brackets should be added
					semantic_token_resolution = {
						enabled = true,
						blocked_filetypes = {},
						-- How long to wait for semantic tokens to return before assuming no brackets should be added
						timeout_ms = 400,
					},
				},
			},
		},
		snippets = {
			preset = "luasnip",
		},
		sources = {
			default = { "lsp", "path", "buffer", "snippets", "dadbod", "lazydev", "html-css" },
			providers = {
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
				["html-css"] = {
					name = "html-css",
					module = "blink.compat.source",
				},
			},
		},
		fuzzy = {
			sorts = {
				function(a, b)
					if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then
						return
					end
					return b.client_name == "emmet_ls"
				end,
				-- default sorts
				"score",
				"sort_text",
			},
		},
		signature = {
			enabled = true,
			window = {
				border = "rounded",
			},
		},
		keymap = {
			-- set to 'none' to disable the 'default' preset
			preset = "default",

			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<CR>"] = { "accept", "fallback" },
		},
	},
}
