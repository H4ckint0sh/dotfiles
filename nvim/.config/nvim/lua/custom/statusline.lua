local mocha = require("catppuccin.palettes").get_palette("mocha")

local green = mocha.green
local mauve = mocha.mauve
local crust = mocha.crust
local text = mocha.text
local base = mocha.base
local lavender = mocha.lavender

vim.api.nvim_set_hl(0, "StatusLineNormal", { bg = green, fg = crust })
vim.api.nvim_set_hl(0, "StatusLineInsert", { bg = mauve, fg = crust })
vim.api.nvim_set_hl(0, "StatusLineVisual", { bg = lavender, fg = crust })
vim.api.nvim_set_hl(0, "StatusLineLsp", { bg = base, fg = text })
vim.api.nvim_set_hl(0, "StatusLine", { bg = base, fg = text })

local modes_map = {
	["n"] = "NORMAL",
	["i"] = "INSERT",
	["V"] = "VISUAL LINE",
	[""] = "VISUAL BLOCK",
	["c"] = "COMMAND",
}

local function get_mode_color()
	local current_mode = vim.api.nvim_get_mode().mode
	local mode_color = "%#StatusLineNormal#"
	if current_mode == "i" then
		mode_color = "%#StatusLineInsert#"
	elseif current_mode == "V" or current_mode == "" then
		mode_color = "%#StatusLineVisual#"
	end
	return mode_color
end

local function get_mode()
	local current_mode = vim.api.nvim_get_mode().mode
	return table.concat({
		get_mode_color(),
		" ",
		modes_map[current_mode] or "",
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
	return table.concat({
		get_mode(),
		" ",
		"%=",
		vim.fn.fnamemodify(vim.api.nvim_eval("getcwd()"), ":~"),
		" ",
		"%#StatusLine#%{'Line: '}%l/%L, %{'Col: '}%c",
		"%=",
		has_lsp_status and lsp_status.status() or "",
		" ",
		"%#StatusLineLsp#",
		get_lsp_clients(),
		" ",
	})
end

return M
