local icons = require("util.icons").icons
local fmt = require("util.icons").fmt
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
		local colors = require("tokyonight.colors").setup({ style = "night" })

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
			fg = map[mode] or colors.magenta,
			bg = colors.bg,
		}
	end,
}

M.branch = {
	"branch",
	icon = icons.GitBranch,
	color = function()
		local colors = require("tokyonight.colors").setup({ style = "night" })
		return { bg = colors.bg }
	end,
}

M.diff = {
	"diff",
	symbols = {
		added = fmt("Add", ""),
		modified = fmt("Modified", ""),
		removed = fmt("Removed", ""),
	},
	color = function()
		local colors = require("tokyonight.colors").setup({ style = "night" })
		return { bg = colors.bg }
	end,
}

M.filetype = { "filetype" }

M.diagnostics = {
	"diagnostics",
	color = function()
		local colors = require("tokyonight.colors").setup({ style = "night" })
		return { bg = colors.bg }
	end,
}

M.encoding = {
	"encoding",
	color = function()
		local colors = require("tokyonight.colors").setup({ style = "night" })
		return { fg = colors.blue, bg = colors.bg }
	end,
}

M.fileformat = {
	"fileformat",
	color = function()
		local colors = require("tokyonight.colors").setup({ style = "night" })
		return { fg = colors.blue, bg = colors.bg }
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
		local colors = require("tokyonight.colors").setup({ style = "night" })
		return { fg = colors.blue, bg = colors.bg }
	end,
}

M.progress = {
	"progress",
	fmt = function(location)
		return vim.trim(location)
	end,
	color = function()
		local colors = require("tokyonight.colors").setup({ style = "night" })
		return { fg = colors.purple, bg = colors.bg }
	end,
}

M.location = {
	"location",
	fmt = function(location)
		return vim.trim(location)
	end,
	color = function()
		local colors = require("tokyonight.colors").setup({ style = "night" })
		return { fg = colors.purple, bg = colors.bg }
	end,
}

M.macro = {
	function()
		return vim.fn.reg_recording()
	end,
	icon = icons.Recording,
	color = function()
		local colors = require("tokyonight.colors").setup({ style = "night" })
		return { fg = colors.red }
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
	color = function()
		local colors = require("tokyonight.colors").setup({ style = "night" })
		return { fg = colors.comment, bg = colors.bg }
	end,
}

M.gap = {
	function()
		return " "
	end,
	color = function()
		local colors = require("tokyonight.colors").setup({ style = "night" })
		return { bg = colors.bg }
	end,
	padding = 0,
}

return M
