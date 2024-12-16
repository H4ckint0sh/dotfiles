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
				auto_show = false,
			},
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "dadbod" },
			providers = {
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
			},
			cmdline = function()
				local type = vim.fn.getcmdtype()
				-- Search forward and backward
				if type == "/" or type == "?" then
					return { "buffer" }
				end
				-- Commands
				if type == ":" then
					return { "cmdline" }
				end
				return {}
			end,
		},
		signature = {
			enabled = true,
			window = {
				border = "rounded",
			},
		},
		enabled = function()
			return not vim.tbl_contains({ "NvimTree" }, vim.bo.filetype) and vim.bo.buftype ~= "prompt"
		end,
		keymap = {
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "select_and_accept" },
			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			cmdline = {
				preset = "super-tab",
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
			},
		},
	},
}
