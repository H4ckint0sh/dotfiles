local colors = require("tokyonight.colors").setup({ style = "night" }) -- pass in any of the config options as explained above

local check_recording = require("custom.macro").check_recording

local green = colors.green
local purple = colors.purple
local dark_bg = colors.bg_dark
local text = colors.fg
local bg = colors.bg
local lavender = colors.blue2

vim.api.nvim_set_hl(0, "StatusLineNormal", { bg = green, fg = dark_bg })
vim.api.nvim_set_hl(0, "StatusLineInsert", { bg = purple, fg = dark_bg })
vim.api.nvim_set_hl(0, "StatusLineVisual", { bg = lavender, fg = dark_bg })
vim.api.nvim_set_hl(0, "StatusLineLsp", { bg = bg, fg = text })
vim.api.nvim_set_hl(0, "StatusLine", { bg = bg, fg = text })

local modes_map = {
	["n"] = { "NORMAL", colors.blue2 },
	["no"] = { "N-PENDING", colors.blue2 },
	["i"] = { "INSERT", colors.green },
	["ic"] = { "INSERT", colors.green },
	["t"] = { "TERMINAL", colors.green },
	["v"] = { "VISUAL", colors.magenta },
	["V"] = { "V-LINE", colors.magenta },
	[""] = { "V-BLOCK", colors.magenta },
	["R"] = { "REPLACE", colors.red1 },
	["Rv"] = { "V-REPLACE", colors.red1 },
	["s"] = { "SELECT", colors.red1 },
	["S"] = { "S-LINE", colors.red1 },
	[""] = { "S-BLOCK", colors.red1 },
	["c"] = { "COMMAND", colors.orange },
	["cv"] = { "COMMAND", colors.orange },
	["ce"] = { "COMMAND", colors.orange },
	["r"] = { "PROMPT", colors.teal },
	["rm"] = { "MORE", colors.teal },
	["r?"] = { "CONFIRM", colors.purple },
	["!"] = { "SHELL", colors.green },
}

-- Function to capitalize the first character of a string
local function capitalizeFirstChar(str)
	if str == nil or str == "" then
		return str
	end
	local firstChar = string.sub(str, 1, 1)
	local restOfString = string.sub(str, 2)
	firstChar = string.upper(firstChar)
	restOfString = string.lower(restOfString)
	return firstChar .. restOfString
end

-- Iterate over the modes_map and set highlights
for _, info in pairs(modes_map) do
	local highlight_group = "StatusLine" .. capitalizeFirstChar(info[1])
	local color = info[2]
	vim.api.nvim_set_hl(0, highlight_group, { bg = color, fg = colors.bg_dark, bold = true })
end

local function get_mode_color()
	local current_mode = vim.api.nvim_get_mode().mode

	local mode_color = "%#" .. "StatusLine" .. capitalizeFirstChar(modes_map[current_mode][1]) .. "#"
	return mode_color
end

local function get_mode()
	local current_mode = vim.api.nvim_get_mode().mode
	return table.concat({
		get_mode_color(),
		" ",
		modes_map[current_mode][1] or "",
		" ",
		"%#StatusLine#",
	})
end

local function get_lsp_clients()
	local clients = vim.lsp.get_active_clients()
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, vim.bo.filetype) ~= -1 then
			return "[" .. client.name .. "]"
		end
	end
	return ""
end

local M = {}

M.global = function()
	local has_lsp_status, lsp_status = pcall(require, "lsp-status")
	local recording_msg = check_recording()
	return table.concat({
		get_mode(),
		" ",
		vim.fn.fnamemodify(vim.api.nvim_eval("getcwd()"), ":~"),
		"%#StatusLine#%{'Line: '}%l/%L, %{'Col: '}%c",
		"%=",
		" ",
		recording_msg,
		"%=",
		has_lsp_status and lsp_status.status() or "",
		" ",
		"%#StatusLineLsp#",
		get_lsp_clients(),
		" ",
	})
end

return M
