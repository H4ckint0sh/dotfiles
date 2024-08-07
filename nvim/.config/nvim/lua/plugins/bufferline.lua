return {
	-- buffer line
	{
		"akinsho/bufferline.nvim",
		event = "BufReadPre",
		keys = {
			{ "bp", ":BufferLinePick <CR>", silent = true },
			{ "bd", ":BufferLinePickClose <CR>", silent = true },
			{ "<tab>", ":BufferLineCycleNext<CR>", silent = true },
			{ "<s-tab>", ":BufferLineCyclePrev<CR>", silent = true },
			{ "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", silent = true },
			{ "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", silent = true },
			{ "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", silent = true },
			{ "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", silent = true },
			{ "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", silent = true },
			{ "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", silent = true },
			{ "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", silent = true },
			{ "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", silent = true },
			{ "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", silent = true },
		},
		config = function()
			local bufferline = require("bufferline")
			bufferline.setup({
				options = {
					mode = "buffers",
					numbers = "ordinal",
					max_name_length = 10,
					max_prefix_length = 8, -- prefix used when a buffer is de-duplicated
					truncate_names = true, -- whether or not tab names should be truncated
					tab_size = 10,
					separator_style = "thin",
					always_show_bufferline = true,
					offsets = { { filetype = "NvimTree", text = "File Manager", separator = false } },
					style_preset = {
						bufferline.style_preset.no_italic,
						bufferline.style_preset.no_bold,
						bufferline.style_preset.minimal,
					},
					diagnostics = false,
					show_buffer_icons = false,
					show_buffer_close_icons = false,
					show_close_icon = false,
					show_tab_indicators = false,
					indicator_icon = nil,
					indicator = { style = "", icon = "" },
					buffer_close_icon = "",
					modified_icon = "●",
					close_icon = "",
				},
			})
		end,
	},
}
