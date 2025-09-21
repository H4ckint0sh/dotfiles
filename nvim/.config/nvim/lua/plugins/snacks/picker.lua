return {
	-- or if you want to check the score of each file
	debug = {
		-- scores = true, -- show scores in the list
	},
	-- I like the "ivy" layout, so I set it as the default globaly, you can
	-- still override it in different keymaps
	layout = {
		preset = "ivy",
		-- When reaching the bottom of the results in the picker, I don't want
		-- it to cycle and go back to the top
		cycle = false,
	},
	layouts = {
		custom_sidebar = {
			layout = {
				backdrop = false,
				width = 40,
				min_width = 40,
				height = 0,
				position = "left",
				border = "none",
				box = "vertical",
				{
					win = "input",
					height = 1,
					-- border = "rounded",
					border = { " ", " ", " ", " ", " ", "", " ", " " },
					title = "{title} {live} {flags}",
					title_pos = "center",
				},
				{ win = "list", border = "none" },
				{ win = "preview", title = "{preview}", height = 0.4, border = "top" },
			},
		},
		custom = {
			layout = {
				box = "horizontal",
				backdrop = false,
				width = 0.8,
				min_width = 120,
				height = 0.8,
				{
					box = "vertical",
					border = "rounded",
					title = "{title} {live} {flags}",
					{ win = "input", height = 1, border = "bottom" },
					{ win = "list", border = "none" },
				},
				{ win = "preview", title = "{preview}", border = "rounded", width = 0.70 },
			},
		},
		ivy = {
			layout = {
				box = "vertical",
				backdrop = false,
				row = -1,
				width = 0,
				height = 0.5,
				border = "top",
				title = " {title} {live} {flags}",
				title_pos = "left",
				{ win = "input", height = 1, border = "bottom" },
				{
					box = "horizontal",
					{ win = "list", border = "none" },
					{ win = "preview", title = "{preview}", width = 0.5, border = "left" },
				},
			},
		},
		vertical = {
			layout = {
				backdrop = false,
				width = 0.8,
				min_width = 80,
				height = 0.8,
				min_height = 30,
				box = "vertical",
				border = "rounded",
				title = "{title} {live} {flags}",
				title_pos = "center",
				{ win = "input", height = 1, border = "bottom" },
				{ win = "list", border = "none" },
				{ win = "preview", title = "{preview}", height = 0.4, border = "top" },
			},
		},
	},
	matcher = {
		frecency = true,
	},
	formatters = {
		-- For fff.lua picker
		file = {
			filename_first = false,
			truncate = 40,
			filename_only = false,
			icon_width = 2,
			git_status_hl = true,
		},
	},
	actions = {
		flash = function(picker)
			require("flash").jump({
				pattern = "^",
				label = { after = { 0, 0 } },
				search = {
					mode = "search",
					exclude = {
						function(win)
							return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
						end,
					},
				},
				action = function(match)
					local idx = picker.list:row2idx(match.pos[1])
					picker.list:_move(idx, true, true)
				end,
			})
		end,
		toggle_live_case_sens = function(picker)
			picker.opts.args = picker.opts.args or {}
			picker.case_sens = picker.case_sens == nil and true or picker.case_sens
			if picker.case_sens then
				picker.opts.args = { "--case-sensetive" }
			else
				picker.opts.args = { "--ignore-case" }
			end
			picker.case_sens = not picker.case_sens
			picker:find({ refresh = true })
		end,
	},
	win = {
		input = {
			keys = {
				-- to close the picker on ESC instead of going to normal mode,
				-- add the following keymap to your config
				["<Esc>"] = { "close", mode = { "n", "i" } },
				-- I'm used to scrolling like this in LazyGit
				["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
				["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
				-- ["H"] = { "preview_scroll_left", mode = { "i", "n" } },
				-- ["L"] = { "preview_scroll_right", mode = { "i", "n" } },
				["<a-s>"] = { "flash", mode = { "n", "i" } },
				["s"] = { "flash" },
				-- toggel case sensitive
				["<F1>"] = { "toggle_live_case_sens", mode = { "i", "n" } },
			},
		},
	},
	sources = {
		explorer = {
			follow_file = true,
			tree = true,
			jump = { close = true },
			auto_close = true,
			hidden = true,
			layout = {
				preset = "custom_sidebar",
				layout = {
					width = 0.20,
					position = "right",
				},
			},
			win = {
				list = {
					keys = {
						["<ESC>"] = function()
							vim.cmd("TmuxNavigateRight")
						end,
					},
				},
			},
		},
	},
}
