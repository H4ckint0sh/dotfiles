return {
	"CopilotC-Nvim/CopilotChat.nvim",
	build = "make tiktoken",
	cmd = "CopilotChat",
	keys = {
		-- { "<>", "<cmd>Copilot enable<cr>", mode = { "n", "v" }, desc = "Enable Copilot" },
		-- { "<C-c>", "<cmd>Copilot disable<cr>", mode = { "n", "v" }, desc = "Disable Copilot" },
		{ "<leader>ae", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Explain code" },
		{ "<leader>ar", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "Review code" },
		{ "<leader>af", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Fix Code" },
		{ "<leader>ao", "<cmd>CopilotChatOptimize<cr>", mode = { "n", "v" }, desc = "Optimize Code" },
		{ "<leader>ad", "<cmd>CopilotChatDocs<cr>", mode = { "n", "v" }, desc = "Generate Docs" },
		{ "<leader>aa", "<cmd>CopilotChatToggle<cr>", mode = { "n", "v" }, desc = "Toggle CopilotChat" },
		{ "<leader>at", "<cmd>CopilotChatTests<cr>", mode = { "n", "v" }, desc = "Generate Tests" },
		{ "<leader>am", "<cmd>CopilotChatCommit<cr>", mode = { "n", "v" }, desc = "Generate Commit Message" },
	},
	opts = function()
		local user = vim.env.USER or "User"
		user = user:sub(1, 1):upper() .. user:sub(2)
		return {
			window = { width = 0.4 },
			headers = {
				user = "  " .. user .. " ",
				assistant = "  Copilot",
				tool = " Tool",
			},
			question_header = "  " .. user .. " ",
			answer_header = "  Copilot ",
		}
	end,
	config = function(_, opts)
		require("CopilotChat").setup(opts)
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "copilot-chat",
			callback = function()
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
				vim.opt_local.conceallevel = 0
			end,
		})
	end,
}
