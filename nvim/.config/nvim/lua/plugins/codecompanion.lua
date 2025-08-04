return {
	"olimorris/codecompanion.nvim",
	event = "VeryLazy",
	cmd = {
		"CodeCompanion",
		"CodeCompanionActions",
		"CodeCompanionChat",
	},
	keys = {
		{ "<leader>at", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Actions", mode = { "n", "v" } },
		{ "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Code Companion Chat", mode = { "n", "v" } },
		{ "ga", "<cmd>CodeCompanionChat Add<cr>", desc = "Code Companion Add", mode = { "v" } },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"folke/snacks.nvim",
	},
	config = function(_, _)
		require("codecompanion").setup({
			adapters = {
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						env = {
							api_key = "cmd: echo $GEMINI_API_KEY",
						},
					})
				end,
			},
			display = {
				action_palette = { provider = "snacks" },
			},
			strategies = {
				diff = {
					provider = "mini_diff",
				},
				chat = {
					adapter = "gemini",
					slash_commands = {
						["file"] = {
							opts = {
								provider = "snacks", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
								contains_code = true,
							},
						},
						["symbols"] = {
							opts = {
								contains_code = true,
								provider = "snacks", -- default|telescope|mini_pick|fzf_lua
							},
						},
						["help"] = {
							opts = {
								contains_code = true,
								provider = "snacks", -- default|telescope|mini_pick|fzf_lua
							},
						},
						["buffer"] = {
							opts = {
								contains_code = true,
								provider = "snacks", -- default|telescope|mini_pick|fzf_lua
							},
						},
						["workspace"] = {
							opts = {
								contains_code = true,
								provider = "snacks", -- default|telescope|mini_pick|fzf_lua
							},
						},
						["terminal"] = {
							opts = {
								contains_code = true,
								provider = "snacks", -- default|telescope|mini_pick|fzf_lua
							},
						},
					},
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
}
