return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local dashboard = require("alpha.themes.dashboard")
		local section = {}
		require("alpha.term")
		require("alpha")

		-- Hide statusline in the Alpha dashboard buffer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				vim.o.laststatus = 0 -- Hide the statusline in Alpha dashboard
			end,
		})

		-- Show the statusline again when leaving the Alpha dashboard
		vim.api.nvim_create_autocmd("BufUnload", {
			buffer = 0,
			callback = function()
				vim.o.laststatus = 3 -- Show the statusline after leaving Alpha
			end,
		})

		section.padding = function(lines)
			return { type = "padding", val = lines }
		end

		-- Terminal-based header
		section.header = {
			type = "terminal",
			command = "~/.config/nvim/logo.sh -c",
			width = 70,
			height = 10,
			opts = {
				redraw = true,
				window_config = {
					zindex = 1,
				},
			},
		}

		section.buttons = {
			type = "group",
			val = {
				dashboard.button("SPC f", "  Find file", "<Cmd> FzfLua files <CR>"),
				dashboard.button("SPC t", "󰺯  Find text", "<Cmd> FzfLua live_grep <CR>"),
				dashboard.button("SPC h", "󰋚  Recent files", "<Cmd> FzfLua oldfiles <CR>"),
				dashboard.button("SPC s", "󰦛  Restore Session", "<Cmd> SessionLoad <CR>"),
				dashboard.button("SPC q q", "󰤆  Quit", "<Cmd>qa<CR>"),
			},
			opts = {
				spacing = 1,
			},
		}

		for _, button in ipairs(section.buttons.val) do
			button.opts.hl = "Normal"
			button.opts.hl_shortcut = "AlphaShortcut"
		end

		section.footer = {
			type = "text",
			val = "",
			opts = {
				hl = "Comment",
				position = "center",
			},
		}

		dashboard.config.layout = {
			section.padding(8),
			section.header,
			section.padding(2),
			section.project,
			section.padding(1),
			section.buttons,
			section.padding(1),
			section.footer,
		}

		dashboard.section = section

		require("alpha").setup(dashboard.opts)
	end,
}
