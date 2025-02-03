---@diagnostic disable: missing-fields
return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {
		modes = {
			char = {
				highlight = { backdrop = false },
				config = function(opts)
					opts.autohide = vim.fn.mode(true):find("no")
					-- Show jump labels not in operator-pending mode
					opts.jump_labels = not vim.fn.mode(true):find("o")
						and vim.v.count == 0
						and vim.fn.reg_executing() == ""
						and vim.fn.reg_recording() == ""
				end,
			},
		},
	},
    -- stylua: ignore
	keys = {
		{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
		{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
		{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
		{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
		{ "<c-x>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
	},
}
