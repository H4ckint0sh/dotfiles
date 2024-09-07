return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local dashboard = require("alpha.themes.dashboard")
		local colors = require("tokyonight.colors").setup({ style = "night" }) -- pass in any of the config options as explained above

		-- helper function for utf8 chars
		local function getCharLen(s, pos)
			local byte = string.byte(s, pos)
			if not byte then
				return nil
			end
			return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
		end

		-- Hide statusline in the Alpha dashboard buffer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				vim.o.laststatus = 0 -- Hide the statusline in Alpha dashboard
				vim.o.showtabline = 0 -- Hide tabline in Alpha dashboard
			end,
		})

		-- Show the statusline again when leaving the Alpha dashboard
		vim.api.nvim_create_autocmd("BufUnload", {
			buffer = 0,
			callback = function()
				vim.o.laststatus = 3 -- Show the statusline after leaving Alpha
				vim.o.showtabline = 2 -- Hide tabline in Alpha dashboard
			end,
		})

		local function applyColors(logo, colors, logoColors)
			dashboard.section.header.val = logo

			for key, color in pairs(colors) do
				local name = "Alpha" .. key
				vim.api.nvim_set_hl(0, name, color)
				colors[key] = name
			end

			dashboard.section.header.opts.hl = {}
			for i, line in ipairs(logoColors) do
				local highlights = {}
				local pos = 0

				for j = 1, #line do
					local opos = pos
					pos = pos + getCharLen(logo[i], opos + 1)

					local color_name = colors[line:sub(j, j)]
					if color_name then
						table.insert(highlights, { color_name, opos, pos })
					end
				end

				table.insert(dashboard.section.header.opts.hl, highlights)
			end
			return dashboard.opts
		end

		require("alpha").setup(applyColors({
			[[  ███       ███  ]],
			[[  ████      ████ ]],
			[[  ████     █████ ]],
			[[ █ ████    █████ ]],
			[[ ██ ████   █████ ]],
			[[ ███ ████  █████ ]],
			[[ ████ ████ ████ ]],
			[[ █████  ████████ ]],
			[[ █████   ███████ ]],
			[[ █████    ██████ ]],
			[[ █████     █████ ]],
			[[ ████      ████ ]],
			[[  ███       ███  ]],
			[[                    ]],
			[[  N  E  O  V  I  M  ]],
		}, {
			["b"] = { fg = "#3399ff", ctermfg = 33 },
			["a"] = { fg = "#53C670", ctermfg = 35 },
			["g"] = { fg = "#39ac56", ctermfg = 29 },
			["h"] = { fg = "#33994d", ctermfg = 23 },
			["i"] = { fg = "#33994d", bg = "#39ac56", ctermfg = 23, ctermbg = 29 },
			["j"] = { fg = "#53C670", bg = "#33994d", ctermfg = 35, ctermbg = 23 },
			["k"] = { fg = "#30A572", ctermfg = 36 },
		}, {
			[[  kkkka       gggg  ]],
			[[  kkkkaa      ggggg ]],
			[[ b kkkaaa     ggggg ]],
			[[ bb kkaaaa    ggggg ]],
			[[ bbb kaaaaa   ggggg ]],
			[[ bbbb aaaaaa  ggggg ]],
			[[ bbbbb aaaaaa igggg ]],
			[[ bbbbb  aaaaaahiggg ]],
			[[ bbbbb   aaaaajhigg ]],
			[[ bbbbb    aaaaajhig ]],
			[[ bbbbb     aaaaajhi ]],
			[[ bbbbb      aaaaajh ]],
			[[  bbbb       aaaaa  ]],
			[[                    ]],
			[[  a  a  a  b  b  b  ]],
		}))
		dashboard.section.buttons.val = {
			dashboard.button("SPC f", "  Find file", "<Cmd> FzfLua files <CR>"),
			dashboard.button("SPC t", "󰺯  Find text", "<Cmd> FzfLua live_grep <CR>"),
			dashboard.button("SPC h", "  Recent files", "<Cmd> FzfLua oldfiles <CR>"),
			dashboard.button("SPC S", "󰦛  Restore Session", [[<Cmd> lua require("persistence").select() <CR>]]),
			dashboard.button("SPC q q", "  Quit", "<Cmd>qa<CR>"),
		}
	end,
}
