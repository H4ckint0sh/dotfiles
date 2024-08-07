return {
	{
		"MagicDuck/grug-far.nvim",
		config = true,
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				function()
					local grug = require("grug-far")
					grug.grug_far({
						transient = true,
						keymaps = { help = "?" },
					})
				end,
				desc = "Search and replace",
				mode = { "n", "v" },
			},
		},
	},
}
