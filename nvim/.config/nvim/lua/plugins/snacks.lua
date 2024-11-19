return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		quickfile = { enabled = true },
		statuscolumn = { enabled = false },
		words = { enabled = true },
		styles = {
			notification = {
				wo = {
					winblend = 0,
				},
			},
		},
		lazygit = {
			theme = {
				activeBorderColor = { fg = "MatchParen", bold = true },
			},
		},
	},
	-- stylua: ignore
    keys = {
		{ '<leader>N', function() Snacks.notifier.hide() end },
		{ '<leader>g', function() Snacks.lazygit.open() end },
		{ "<c-t>", function() Snacks.terminal.toggle() end },
		{ "<leader>x", function() Snacks.bufdelete() end },
		{ "<leader>br", function() Snacks.gitbrowse() end },
		{"<leader>fr", function() Snacks.rename.rename_file() end}
	},
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
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.inlay_hints():map("<leader>uh")
			end,
		})
	end,
}
