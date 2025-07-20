local icons = require("util.icons").icons
---@diagnostic disable-next-line: missing-fields
local colors = require("tokyonight.colors").setup({ style = "storm" })
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

M.lsp_formater_linter = {
	function()
		-- Get active clients for current buffer
		local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
		if #buf_clients == 0 then
			return "No client active"
		end
		local buf_ft = vim.bo.filetype
		local buf_client_names = {}
		local num_client_names = #buf_client_names

		-- Add lsp-clients active in the current buffer
		for _, client in pairs(buf_clients) do
			num_client_names = num_client_names + 1
			buf_client_names[num_client_names] = client.name
		end

		local client_names_str = table.concat(buf_client_names, ", ")
		local language_servers = string.format("[%s]", client_names_str)

		return language_servers
	end,
	icon = icons.Braces,
	separator = { right = "", left = "" },
	color = function()
		return { fg = colors.fg, bg = colors.bg_highlight }
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

M.macro = {
	function()
		return vim.fn.reg_recording()
	end,
	icon = icons.Recording,
	separator = { left = "", right = "" },
	color = function()
		return { fg = colors.magenta, bg = colors.bg }
	end,
}

M.fullpath = {
	function()
		-- Configuration
		local max_length = 40 -- Maximum length before truncation
		local truncation_marker = " 󰇘  " -- Character to show truncation

		-- Get full file path
		local path = vim.fn.expand("%:p")

		-- Shorten home directory path if on Unix-like system
		if vim.fn.has("unix") == 1 then
			local shortened = vim.fn.fnamemodify(path, ":~")
			if shortened ~= path then -- Only if modification happened
				path = shortened
			end
		end

		-- Truncate path if too long (keeping beginning and end)
		if #path > max_length then
			local keep_start = math.floor(max_length * 0.6) -- 60% of space for start
			local keep_end = max_length - keep_start - 1 -- Remaining for end (minus 1 for trunc marker)

			local start_part = path:sub(1, keep_start)
			local end_part = path:sub(-keep_end)

			path = start_part .. truncation_marker .. end_part
		end

		return path
	end,
	color = function()
		return { fg = colors.blue, bg = colors.bg_highlight }
	end,
	separator = { right = "", left = "" },
}

return M
