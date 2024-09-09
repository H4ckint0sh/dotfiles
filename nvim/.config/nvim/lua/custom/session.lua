local function are_buffers_listed()
	return #vim.fn.getbufinfo({ buflisted = 1 }) > 0
end

local keep = {
	"buffers", -- hidden and unloaded buffers, not just those in windows
	"curdir", -- the current directory
	"globals", -- global variables that start with an uppercase letter and contain at least one lowercase letter.
	"tabpages", -- all tab pages
	-- "blank", -- empty windows
	-- "folds", -- manually created folds, opened/closed folds and local fold options
	-- "help", -- 	the help window
	-- "localoptions", -- options and mappings local to a window or buffer (not global values for local options)
	-- "options", -- all options and mappings (also global values for local options)
	-- "sesdir", -- the directory in which the session file is located will become the current directory
	-- "skiprtp", -- exclude 'runtimepath' and 'packpath' from the options
	-- "terminal", -- include terminal windows where the command can be restored
	-- "winpos", -- position of the whole Vim window
	-- "winsize", -- window sizes
}

vim.opt.sessionoptions = table.concat(keep, ",")

local sessions_dir = vim.fn.expand(("%s/sessions/"):format(vim.fn.stdpath("state")))

vim.fn.mkdir(sessions_dir, "p")

-- Get the session name based on the current working directory
local function get_current_session()
	local name = vim.fn.getcwd():gsub("/", "%%")
	return ("%s%s.vim"):format(sessions_dir, name)
end

-- List all session files in the sessions directory
local function list_sessions()
	return vim.fn.glob(("%s*.vim"):format(sessions_dir), true, true)
end

-- Escape file name to be safely used in command
local fnameescape = vim.fn.fnameescape

-- Save the current session if there are listed buffers
local function session_save()
	if are_buffers_listed() then
		vim.cmd.mksession({ args = { fnameescape(get_current_session()) }, bang = true })
	end
end

-- Check if the current session matches any session file
local function session_exists()
	local current_session = get_current_session() -- Get the current session file name
	local sessions = list_sessions() -- Get all session files

	-- Check if any session file matches the current session
	for _, session in ipairs(sessions) do
		if session == current_session then
			return true -- Matching session found
		end
	end

	return false -- No matching session found
end

-- Load the session if the current session file is readable
local function session_load()
	local sfile = get_current_session()

	if sfile and vim.fn.filereadable(sfile) ~= 0 then
		vim.cmd.source({
			args = { fnameescape(sfile) },
			mods = { silent = false, emsg_silent = true },
		})

		require("notify")("Session loaded")
	end
end

-- Create autocommand group for sessions
local group = vim.api.nvim_create_augroup(("User%s"):format("Sessions"), { clear = true })

-- Auto-save session on Vim leave
vim.api.nvim_create_autocmd({
	"VimLeavePre",
}, {
	group = group,
	callback = session_save,
})

-- Auto-load session or notify if session exists on UIEnter
vim.api.nvim_create_autocmd({
	"UIEnter",
}, {
	group = group,
	callback = function()
		local path = vim.fn.expand("%") --[[@as string]]

		-- Do not load session if Neovim is opened with arguments or a man page
		if vim.fn.argc(-1) > 0 or string.match(path, "man://*") then
			return
		end

		-- Notify if a matching session is found
		if session_exists() then
			require("notify")("Matching session found")
		else
			require("notify")("No matching session found", "warn")
		end
	end,
})

-- Create a user command to manually load a session
vim.api.nvim_create_user_command("SessionLoad", session_load, {
	desc = "Load a session",
})

return {}
