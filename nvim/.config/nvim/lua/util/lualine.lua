local icons = require("util.icons").icons
local fmt = require("util.icons").fmt
---@diagnostic disable-next-line: missing-fields
local colors = require("tokyonight.colors").setup({ style = "night" })
local M = {}

M.mode = {
	"mode",
	fmt = function(name)
		local map = {
			NORMAL = icons.Normal,
			INSERT = icons.Insert,
			TERMINAL = icons.Terminal,
			VISUAL = icons.Visual,
			["V-LINE"] = icons.Visual,
			["V-BLOCK"] = icons.Visual,
			["O-PENDING"] = icons.Ellipsis,
			COMMAND = icons.Command,
			REPLACE = icons.Edit,
			SELECT = icons.Visual,
		}
		local icon = map[name] and map[name] or icons.Vim
		return icon .. " " .. name
	end,
	color = function()
		local mode = vim.fn.mode()
		local map = {
			n = colors.blue,
			i = colors.green,
			c = colors.yellow,
			t = colors.cyan,
			R = colors.red,
			v = colors.magenta,
			V = colors.magenta,
			s = colors.magenta,
			S = colors.magenta,
		}
		return {
			bg = map[mode] or colors.magenta,
			fg = colors.bg_dark,
		}
	end,
	separator = { right = "", left = "░▒▓" },
}

M.filetype = {
	"filetype",
	color = function()
		return { fg = colors.blue, bg = colors.bg_highlight }
	end,
	separator = { right = "", left = "" },
}

M.diagnostics = {
	"diagnostics",
	color = function()
		return { bg = colors.bg_highlight }
	end,
	separator = { right = "", left = "" },
}

M.encoding = {
	"encoding",
	color = function()
		return { fg = colors.blue, bg = colors.bg_highlight }
	end,
}

M.fileformat = {
	"fileformat",
	color = function()
		return { fg = colors.blue, bg = colors.bg_highlight }
	end,
}

M.indentation = {
	"indentation",
	fmt = function()
		local type = vim.bo[0].expandtab and "spaces" or "tabs"
		local value = vim.bo[0].shiftwidth
		return type .. ": " .. value
	end,
	color = function()
		return { fg = colors.blue, bg = colors.bg_highlight }
	end,
}

M.progress = {
	"progress",
	fmt = function(location)
		return vim.trim(location)
	end,
	color = function()
		return { fg = colors.black, bg = colors.fg }
	end,
}

M.location = {
	"location",
	fmt = function(location)
		return vim.trim(location)
	end,
	color = function()
		return { fg = colors.black, bg = colors.fg }
	end,
}

M.macro = {
	function()
		return vim.fn.reg_recording()
	end,
	icon = icons.Recording,
	separator = { left = "", right = "" },
	color = function()
		return { fg = colors.magenta, bg = colors.bg_dark }
	end,
}

M.lsp = {
	function()
		local bufnr = vim.api.nvim_get_current_buf()
		local clients = vim.lsp.get_clients({ bufnr = bufnr })
		if next(clients) == nil then
			return ""
		end
		local attached_clients = vim.tbl_map(function(client)
			return client.name
		end, clients)
		return table.concat(attached_clients, ", ")
	end,
	icon = icons.Braces,
	separator = { right = "", left = "" },
	color = function()
		return { fg = colors.fg_dark, bg = colors.bg_dark }
	end,
}

M.gap = {
	function()
		return " "
	end,
	color = function()
		return { bg = colors.bg_highlight }
	end,
	padding = 0,
}

M.neocodeium_status = {
	function()
		local status, serverstatus = require("neocodeium").get_status()

		-- Tables to map serverstatus and status to corresponding symbols
		local server_status_symbols = {
			[0] = "󰣺 ", -- Connected
			[1] = "󱤚 ", -- Connecting
			[2] = "󰣽 ", -- Disconnected
		}

		local status_symbols = {
			[0] = "󰚩 ", -- Enabled
			[1] = "󱚧 ", -- Disabled Globally
			[3] = "󱚢 ", -- Disabled for Buffer filetype
			[5] = "󱚠 ", -- Disabled for Buffer encoding
			[2] = "󱙻 ", -- Disabled for Buffer (catch-all)
		}

		-- Handle serverstatus and status fallback (safeguard against any unexpected value)
		local luacodeium = server_status_symbols[serverstatus] or "󰣼 "
		luacodeium = luacodeium .. (status_symbols[status] or "󱙻 ")

		return luacodeium
	end,
	-- cond = require("neocodeium").is_enabled,
	padding = { left = 0, right = 0 },
	separator = { right = "", left = "" },
	color = function()
		return { fg = colors.green, bg = colors.bg_dark }
	end,
}

return M
