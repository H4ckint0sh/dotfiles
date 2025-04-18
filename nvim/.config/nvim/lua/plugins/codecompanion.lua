return {
	"olimorris/codecompanion.nvim",
	event = "VeryLazy",
	cmd = {
		"CodeCompanion",
		"CodeCompanionActions",
		"CodeCompanionChat",
	},
	keys = {
		{ "<localleader>at", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Actions", mode = { "n", "v" } },
		{ "<localleader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Code Companion Chat", mode = { "n", "v" } },
		{ "ga", "<cmd>CodeCompanionChat Add<cr>", desc = "Code Companion Add", mode = { "v" } },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"folke/noice.nvim",
	},
	config = function(_, _)
		require("codecompanion").setup({
			display = {
				chat = {
					auto_scroll = false,
				},
			},
			adapters = {
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						env = {
							api_key = "cmd: echo $GEMINI_API_KEY",
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "gemini",
				},
				inline = {
					adapter = "gemini",
				},
				cmd = {
					adapter = "gemini",
				},
			},
		})

		vim.cmd([[cab cc CodeCompanion]])
	end,
	init = function()
		require("custom.noice-spinner").init()
	end,
}
