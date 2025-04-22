---@diagnostic disable-next-line: missing-fields
local colors = require("nord.colors").palette

return {
	"petertriho/nvim-scrollbar",
	config = function()
		require("scrollbar").setup({
			show = true,
			show_in_active_only = false,
			set_highlights = true,
			folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
			max_lines = false, -- disables if no. of lines in buffer exceeds this
			hide_if_all_visible = false, -- Hides everything if all lines are visible
			throttle_ms = 100,
			handle = {
				text = " ",
				blend = 0,
				color = colors.bg_highlight,
				hide_if_all_visible = true, -- Hides handle if all lines are visible
			},
			marks = {
				Cursor = {
					text = "",
					priority = 0,
					color = colors.orange,
				},
				Search = {
					text = { "󰿟", "󰿟" },
					priority = 1,
					color = colors.bg_search,
				},
				Error = {
					text = { "-", "=" },
					priority = 2,
					highlight = "DiagnosticVirtualTextError",
				},
				Warn = {
					text = { "-", "=" },
					priority = 3,
					highlight = "DiagnosticVirtualTextWarn",
				},
				Info = {
					text = { "-", "=" },
					priority = 4,
					highlight = "DiagnosticVirtualTextInfo",
				},
				Hint = {
					text = { "-", "=" },
					priority = 5,
					highlight = "DiagnosticVirtualTextHint",
				},
				Misc = {
					text = { "-", "=" },
					priority = 6,
					highlight = "Normal",
				},
				GitAdd = {
					text = "┆",
					priority = 7,
					highlight = "GitSignsAdd",
				},
				GitChange = {
					text = "┆",
					priority = 7,
					highlight = "GitSignsChange",
				},
				GitDelete = {
					text = "▁",
					priority = 7,
					highlight = "GitSignsDelete",
				},
			},
			excluded_buftypes = {
				"terminal",
				"nofile",
			},
			excluded_filetypes = {
				"dropbar_menu",
				"snacks_picker_input",
				"dropbar_menu_fzf",
				"snacks_input",
				"cmp_docs",
				"cmp_menu",
				"noice",
				"prompt",
				"TelescopePrompt",
			},
			autocmd = {
				render = {
					"BufWinEnter",
					"TabEnter",
					"TermEnter",
					"WinEnter",
					"CmdwinLeave",
					"TextChanged",
					"VimResized",
					"WinScrolled",
				},
				clear = {
					"BufWinLeave",
					"TabLeave",
					"TermLeave",
					"WinLeave",
				},
			},
			handlers = {
				cursor = true,
				diagnostic = true,
				gitsigns = false, -- Requires gitsigns
				handle = true,
				search = false, -- Requires hlslens
				ale = false, -- Requires ALE
			},
		})
	end,
}
