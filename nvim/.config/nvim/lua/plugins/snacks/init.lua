return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = {
			enabled = true,
			notify = true,
			size = 100 * 1024, -- 100 KB
		},
		picker = require("plugins.snacks.picker"),
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		quickfile = { enabled = true },
		statuscolumn = {
			left = { "mark", "sign", "git" },
			right = { "fold" },
			folds = {
				open = true,
				git_hl = true,
			},
			git = {
				patterns = { "GitSigns" },
			},
			refresh = 50,
		},
		words = { enabled = true },
		lazygit = {
			win = { backdrop = false },
		},

		image = { enabled = true },
		input = {
			enabled = true,
			icon = "",
		},
		styles = {
			notification = {
				wo = {
					winblend = 0,
				},
			},
			lazygit = {
				width = 0,
				height = 0,
			},
			input = {
				relative = "cursor",
				col = 0,
				row = -3,
				height = 1,
			},
		},
		indent = {
			char = "│",
			scope = { hl = "Normal" },
			chunk = {
				enabled = true,
				hl = "Normal",
			},
		},
		scope = {},
		scroll = {
			enabled = false,
			animate = {
				duration = { step = 15, total = 150 },
				easing = "linear",
			},
		},
		dashboard = require("plugins.snacks.dashboard"),
	},
	keys = require("plugins.snacks.keys"),
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd -- Override print to use snacks for `:=` command

				-- Create some toggle mappings
				Snacks.toggle.diagnostics():map("<leader>sd")
				Snacks.toggle.inlay_hints():map("<leader>sh")
			end,
		})
	end,
}
