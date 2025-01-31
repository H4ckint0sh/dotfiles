local icons = require("util.icons").icons
---@diagnostic disable-next-line: missing-fields
local palette = require("nord.colors").palette
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
			n = palette.frost.artic_water,
			i = palette.aurora.green,
			c = palette.aurora.yellow,
			t = palette.frost.ice,
			R = palette.aurora.red,
			v = palette.aurora.purple,
			V = palette.aurora.purple,
			s = palette.aurora.purple,
			S = palette.aurora.purple,
		}
		return {
			bg = map[mode] or palette.aurora.purple,
			fg = palette.polar_night.origin,
		}
	end,
	separator = { right = "", left = "░▒▓" },
}

M.filetype = {
	"filetype",
	color = function()
		return { fg = palette.frost.artic_water, bg = palette.polar_night.bright }
	end,
	separator = { right = "", left = "" },
}

M.diagnostics = {
	"diagnostics",
	color = function()
		return { bg = palette.polar_night.bright }
	end,
	separator = { right = "", left = "" },
}

M.encoding = {
	"encoding",
	color = function()
		return { fg = palette.frost.artic_water, bg = palette.polar_night.bright }
	end,
}

M.fileformat = {
	"fileformat",
	symbols = { unix = "􀣺 " },
	color = function()
		return { fg = palette.frost.artic_water, bg = palette.polar_night.bright }
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
		return { fg = palette.frost.artic_water, bg = palette.polar_night.bright }
	end,
}

M.progress = {
	"progress",
	fmt = function(location)
		return vim.trim(location)
	end,
	color = function()
		return { fg = palette.polar_night.origin, bg = palette.snow_storm.origin }
	end,
}

M.location = {
	"location",
	fmt = function(location)
		return vim.trim(location)
	end,
	color = function()
		return { fg = palette.polar_night.origin, bg = palette.snow_storm.origin }
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

		-- Add linters for the current filetype (nvim-lint)
		-- local lint_success, lint = pcall(require, "lint")
		-- if lint_success then
		-- 	for ft, ft_linters in pairs(lint.linters_by_ft) do
		-- 		if ft == buf_ft then
		-- 			if type(ft_linters) == "table" then
		-- 				for _, linter in pairs(ft_linters) do
		-- 					num_client_names = num_client_names + 1
		-- 					buf_client_names[num_client_names] = linter
		-- 				end
		-- 			else
		-- 				num_client_names = num_client_names + 1
		-- 				buf_client_names[num_client_names] = ft_linters
		-- 			end
		-- 		end
		-- 	end
		-- end
		--
		-- -- Add formatters (conform.nvim)
		-- local conform_success, conform = pcall(require, "conform")
		-- if conform_success then
		-- 	for _, formatter in pairs(conform.list_formatters_for_buffer(0)) do
		-- 		if formatter then
		-- 			num_client_names = num_client_names + 1
		-- 			buf_client_names[num_client_names] = formatter
		-- 		end
		-- 	end
		-- end

		local client_names_str = table.concat(buf_client_names, ", ")
		local language_servers = string.format("[%s]", client_names_str)

		return language_servers
	end,
	icon = icons.Braces,
	separator = { right = "", left = "" },
	color = function()
		return { fg = palette.snow_storm.origin, bg = palette.polar_night.origin }
	end,
}

M.gap = {
	function()
		return " "
	end,
	color = function()
		return { bg = palette.polar_night.bright }
	end,
	padding = 0,
}

-- Function to get the width of the NvimTree window
M.nvim_tree_width = function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local filetype = vim.bo[buf].filetype
		if filetype == "NvimTree" then
			return vim.api.nvim_win_get_width(win)
		end
	end
	return 0
end

-- Custom lualine component to display NvimTree text with icon centered
M.custom_nvimtree_component = function()
	local tree_open = false
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local filetype = vim.bo[buf].filetype
		if filetype == "NvimTree" then
			tree_open = true
			break
		end
	end

	if tree_open then
		local width = M.nvim_tree_width() -- Get the width of NvimTree

		-- Center the content
		return string.rep(" ", width - 1)
	end
	return ""
end

M.macro = {
	function()
		return vim.fn.reg_recording()
	end,
	icon = icons.Recording,
	separator = { left = "", right = "" },
	color = function()
		return { fg = palette.aurora.purple, bg = palette.polar_night.origin }
	end,
}

M.filetree = {
	function()
		return M.custom_nvimtree_component()
	end,
	separator = { left = "", right = "" },
	color = function()
		return { fg = palette.snow_storm.origin, bg = palette.polar_night.origin }
	end,
}

return M
