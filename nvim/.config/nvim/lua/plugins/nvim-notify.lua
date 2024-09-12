return {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	keys = {
		{
			"<leader>nd",
			function()
				require("notify").dismiss({ silent = true, pending = true })
			end,
			desc = "[N]otify [D]ismiss All",
		},
	},
	opts = function()
		return {
			fps = 60,
			render = "default",
			timeout = 800,
			topDown = true,
		}
	end,
	config = function(_, opts)
		require("notify").setup(opts)
		vim.notify = require("notify")
		-- Update colors to use tokyonight colors
		vim.cmd([[
		   highlight NotifyERRORBorder guifg=#db4b4b
		   highlight NotifyERRORIcon guifg=#db4b4b
		   highlight NotifyERRORTitle  guifg=#db4b4b
		   highlight NotifyINFOBorder guifg=#0db9d7
		   highlight NotifyINFOIcon guifg=#0db9d7
		   highlight NotifyINFOTitle guifg=#0db9d7
		   highlight NotifyWARNBorder guifg=#e0af68
		   highlight NotifyWARNIcon guifg=#e0af68
		   highlight NotifyWARNTitle guifg=#e0af68
      ]])
	end,
}
