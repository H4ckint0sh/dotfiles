-- vim-tmux-navigator for Rex: <C-h/j/k/l> moves between nvim splits and,
-- at the edge of nvim, on to the neighbouring Rex pane.
-- Rex sends these keys to nvim (see ~/.config/rex/init.lua, action "navigate").
if not vim.env.REX_BLOCK or vim.env.TMUX then
	return
end

local rex = vim.env.REX_BIN_DIR and (vim.env.REX_BIN_DIR .. "/rex") or "rex"

local function navigate(key, direction)
	local win = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. key)
	if vim.api.nvim_get_current_win() == win then
		vim.system({ rex, "focus", direction })
	end
end

for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
	vim.keymap.set("n", "<C-" .. key .. ">", function()
		navigate(key, direction)
	end, { silent = true, desc = "Navigate window / Rex pane " .. direction })
end
