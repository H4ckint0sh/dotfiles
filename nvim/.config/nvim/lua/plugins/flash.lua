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
}
