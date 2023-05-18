local M = {}
local fn = vim.fn

local modes = require 'internal.statusline.colors'.modes
local icon = '  '
local devicons_present, devicons = pcall(require, 'nvim-web-devicons')

M.Mode = function()
	local m = vim.api.nvim_get_mode().mode
	local current_mode = '%#' .. modes[m][2] .. '#' .. '  ' .. modes[m][1]

	return table.concat { current_mode }
end

M.Spacer = function()
	return table.concat { '%#Spacer# ' }
end

M.FileInfo = function()
	local filename = (fn.expand '%' == '' and 'Empty ') or fn.expand '%:t'

	if filename ~= 'Empty ' then
		if devicons_present then
			icon = M.GetFileIcon(filename)
		end
	end

	return table.concat { '%#St_CurrentFile#', icon, ' ', filename, ' ' }
end

M.AlternateFile = function()
	local filename = (fn.expand '#' == '' and 'Empty') or fn.expand '#:t'

	if (fn.bufnr '#' ~= fn.bufnr '%') and (filename ~= 'Empty') then
		if devicons_present then
			icon = M.GetFileIcon(filename)
		end

		return table.concat { '%#St_AlternateFile#', '#', icon, ' ', filename, ' ' }
	end

	return ' '
end

M.GetFileIcon = function(filename)
	local ft_icon = devicons.get_icon(filename)

	return (ft_icon ~= nil and ' ' .. ft_icon) or ''
end

M.Git = function()
	if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
		return ''
	end

	local git_status = vim.b.gitsigns_status_dict

	local branch_name = '%#Normal#' .. '   ' .. git_status.head .. ' '
	local added = (git_status.added and git_status.added ~= 0) and ('%#St_git_add#' .. '  ' .. git_status.added) or ''
	local changed = (git_status.changed and git_status.changed ~= 0) and
		('%#St_git_change#' .. '  ' .. git_status.changed
		) or ''
	local removed = (git_status.removed and git_status.removed ~= 0) and
		('%#St_git_delete#' .. '  ' .. git_status.removed
		) or ''

	return table.concat { branch_name, added, changed, removed }
end

M.LSP_Diagnostics = function()
	if not rawget(vim, 'lsp') then
		return ''
	end

	local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
	local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
	local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

	errors = (errors and errors > 0) and ('%#DiagnosticError#' .. ' ' .. errors .. ' ') or ''
	warnings = (warnings and warnings > 0) and ('%#DiagnosticWarn#' .. ' ' .. warnings .. ' ') or ''
	hints = (hints and hints > 0) and ('%#DiagnosticHint#' .. ' ' .. hints .. ' ') or ''
	info = (info and info > 0) and ('%#DiagnosticInfo#' .. ' ' .. info .. ' ') or ''

	return errors .. warnings .. hints .. info
end

M.LSP_status = function()
	if rawget(vim, 'lsp') then
		local client_names = {}
		for _, client in ipairs(vim.lsp.get_active_clients()) do
			table.insert(client_names, client.name)
		end

		if next(client_names) then
			return (vim.o.columns > 100 and '%#LspClient#' .. '   ' .. table.concat(client_names, ', ') .. ' ')
		end
	end
	return ''
end

M.Treesitter = function()
	if next(vim.treesitter.highlighter.active) then
		return '%#Treesitter#' .. ' '
	end
	return ''
end

return M
