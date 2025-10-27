local icons = require("util.icons").icons
---@diagnostic disable-next-line: missing-fields
local palette = require("nord.colors").palette

-- Helper for mode bubble colors from your theme
local function mode_bubble_colors()
	local mode = vim.api.nvim_get_mode().mode
	local map = {
		n = palette.frost.ice,
		i = palette.aurora.green,
		c = palette.aurora.yellow,
		t = palette.frost.artic_water,
		R = palette.aurora.red,
		v = palette.aurora.orange,
		V = palette.aurora.orange,
		s = palette.aurora.purple,
		S = palette.aurora.purple,
	}
	local bubble_bg = map[mode] or palette.aurora.purple
	local bubble_fg = palette.polar_night.origin
	local sep_fg = bubble_bg
	local sep_bg = palette.polar_night.origin
	return bubble_fg, bubble_bg, sep_fg, sep_bg
end

-- Setup highlights for bubbles & separators
local function setup_statusline_highlights()
	local bubble_fg, bubble_bg, sep_fg, sep_bg = mode_bubble_colors()

	-- Main statusline background - set the default StatusLine highlight
	vim.cmd(
		string.format("highlight StatusLine guibg=%s guifg=%s", palette.polar_night.origin, palette.polar_night.light)
	)

	-- Custom highlight groups that inherit from StatusLine but override specific properties
	vim.cmd(string.format("highlight StatusLineSep guifg=%s guibg=%s gui=bold", sep_fg, sep_bg))
	vim.cmd(string.format("highlight StatusLineMode guifg=%s guibg=%s gui=bold", bubble_fg, bubble_bg))

	-- Foreground for branch is green from your palette, background is NONE (inherits from StatusLine)
	vim.cmd(string.format("highlight StatusLineBranch guifg=%s guibg=NONE gui=bold", palette.snow_storm.origin))

	-- Diagnostic highlights (inherit background from StatusLine)
	vim.cmd(string.format("highlight StatusLineDiagError guifg=%s guibg=NONE gui=bold", palette.aurora.red))
	vim.cmd(string.format("highlight StatusLineDiagWarn guifg=%s guibg=NONE gui=bold", palette.aurora.yellow))
	vim.cmd(string.format("highlight StatusLineDiagInfo guifg=%s guibg=NONE gui=bold", palette.frost.ice))
	vim.cmd(string.format("highlight StatusLineDiagHint guifg=%s guibg=NONE gui=bold", palette.frost.artic_water))

	-- Git diff highlights (inherit background from StatusLine)
	vim.cmd(string.format("highlight StatusLineGitAdd guifg=%s guibg=NONE gui=bold", palette.aurora.green))
	vim.cmd(string.format("highlight StatusLineGitChange guifg=%s guibg=NONE gui=bold", palette.aurora.orange))
	vim.cmd(string.format("highlight StatusLineGitDelete guifg=%s guibg=NONE gui=bold", palette.aurora.red))

	-- Location highlight with custom background
	vim.cmd(
		string.format(
			"highlight StatusLineLoc guifg=%s guibg=%s gui=bold",
			palette.snow_storm.origin,
			palette.polar_night.lighter
		)
	)

	-- LSP clients highlight (shows the active LSPs attached to the buffer)
	vim.cmd(string.format("highlight StatusLineLSP guifg=%s guibg=NONE gui=bold", palette.aurora.green))
end

-- Mode text & icon (no highlights)
local function mode_component()
	local mode = vim.api.nvim_get_mode().mode
	local map = {
		n = { icons.Normal, "NORMAL" },
		i = { icons.Insert, "INSERT" },
		t = { icons.Terminal, "TERMINAL" },
		v = { icons.Visual, "VISUAL" },
		V = { icons.Visual, "V-LINE" },
		[""] = { icons.Visual, "V-BLOCK" },
		R = { icons.Edit, "REPLACE" },
		c = { icons.Command, "COMMAND" },
		s = { icons.Visual, "SELECT" },
		S = { icons.Visual, "S-LINE" },
		[""] = { icons.Visual, "S-BLOCK" },
	}
	local icon, name = unpack(map[mode] or { icons.Vim, "OTHER" })
	return string.format("%s %s", icon, name)
end
_G.mode_component = mode_component

-- Branch (no bubble, just icon and text, green fg)
local function git_branch()
	local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
	if branch ~= "" then
		return " %#StatusLineBranch# " .. branch .. "%*"
	else
		return ""
	end
end

-- Diagnostics summary (LSP)
local function diagnostics_summary()
	local bufnr = vim.api.nvim_get_current_buf()
	local errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
	local warnings = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
	local hints = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT })
	local info = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO })
	local msg = ""
	if errors > 0 then
		msg = msg .. " %#StatusLineDiagError# " .. errors .. "%*"
	end
	if warnings > 0 then
		msg = msg .. " %#StatusLineDiagWarn# " .. warnings .. "%*"
	end
	if info > 0 then
		msg = msg .. " %#StatusLineDiagInfo# " .. info .. "%*"
	end
	if hints > 0 then
		msg = msg .. " %#StatusLineDiagHint# " .. hints .. "%*"
	end
	return msg
end

-- Git changes (requires gitsigns.nvim)
local function git_changes()
	local signs = vim.b.gitsigns_status_dict
	if not signs then
		return ""
	end
	local added = signs.added or 0
	local changed = signs.changed or 0
	local removed = signs.removed or 0
	local msg = ""
	if added > 0 then
		msg = msg .. " %#StatusLineGitAdd#+ " .. added .. "%*"
	end
	if changed > 0 then
		msg = msg .. " %#StatusLineGitChange#~ " .. changed .. "%*"
	end
	if removed > 0 then
		msg = msg .. " %#StatusLineGitDelete#- " .. removed .. "%*"
	end
	return msg
end

-- Active LSP clients for the current buffer
local function lsp_clients()
	-- Prefer the buffer-local API to get clients attached to this buffer
	local bufnr = vim.api.nvim_get_current_buf()
	-- Uses older but compatible API: vim.lsp.buf_get_clients(bufnr)
	local clients = vim.lsp.buf_get_clients(bufnr) or {}
	if next(clients) == nil then
		return ""
	end

	-- Collect unique names
	local seen = {}
	local names = {}
	for _, client in pairs(clients) do
		local name = client.name or "unknown"
		if not seen[name] then
			seen[name] = true
			table.insert(names, name)
		end
	end

	-- Shorten common names (optional): show "ts", "pyright" -> leave as-is for clarity
	local text = table.concat(names, ", ")
	-- Prepend an icon (gear) and use LSP highlight group
	return " %#StatusLineLSP# " .. text .. "%*"
end

local function statusline()
	setup_statusline_highlights()

	-- The default StatusLine highlight is automatically applied to the entire line
	local mode_bubble = " %#StatusLineSep#%#StatusLineMode# %{v:lua.mode_component()} %#StatusLineSep#%*"
	local branch_part = git_branch()
	local diagnostics_part = diagnostics_summary()
	local git_changes_part = git_changes()
	local lsp_part = lsp_clients()
	local file_name = " %<%f"
	local modified = "%m"
	local align_right = "%="
	local filetype = " %y"
	local fileencoding = " %{&fileencoding?&fileencoding:&encoding}"
	local fileformat = " [%{&fileformat}]"
	local loc = " %#StatusLineLoc#%l/%L %P%*"

	return mode_bubble
		.. branch_part
		.. git_changes_part
		.. diagnostics_part
		.. file_name
		.. modified
		.. align_right
		.. filetype
		.. fileencoding
		.. fileformat
		.. lsp_part
		.. loc
end

vim.opt.statusline = "%{%v:lua.statusline()%}"

_G.statusline = statusline
