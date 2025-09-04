local state = {
	floating = {
		buf = -1, -- invalid buffer
		win = -1, -- invalid window
	},
}

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	-- Calculate the position to center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Always create a new buffer for command execution
	local buf = vim.api.nvim_create_buf(false, true)

	-- Define window configuration
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal", -- Minimal UI
		border = "rounded", -- Rounded borders
	}

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

local toggle_terminal = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = create_floating_window({ buf = state.floating.buf })
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
		end

		-- Enter insert mode
		vim.cmd("startinsert")
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

-- NEW: Function to run a command and auto-close
local function run_command_and_quit(command)
	-- Always create a new window and buffer for commands
	local floating_win = create_floating_window({})

	-- Set up terminal with the command
	vim.fn.termopen(command, {
		on_exit = function()
			-- Close the window when command finishes
			vim.defer_fn(function()
				if vim.api.nvim_win_is_valid(floating_win.win) then
					vim.api.nvim_win_close(floating_win.win, true)
				end
				-- Clean up the buffer
				if vim.api.nvim_buf_is_valid(floating_win.buf) then
					vim.api.nvim_buf_delete(floating_win.buf, { force = true })
				end
			end, 100) -- Small delay to see the output
		end,
	})

	-- Set some buffer options for better display
	vim.api.nvim_buf_set_option(floating_win.buf, "filetype", "terminal")
	vim.api.nvim_buf_set_option(floating_win.buf, "buftype", "terminal")

	-- CRITICAL: Enter insert mode automatically for interactive applications
	vim.cmd("startinsert")
end

-- NEW: Custom command that handles arguments better
vim.api.nvim_create_user_command("RunCommandInFloatingTerminal", function(opts)
	local command = opts.args
	if command == "" then
		vim.notify("No command provided", vim.log.levels.ERROR)
		return
	end

	run_command_and_quit(command)
end, { nargs = "*", desc = "Run command in floating terminal and auto-close" })

-- Keep the original toggle functionality
vim.api.nvim_create_user_command("ToggleFloatingTerminal", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "<F12>", toggle_terminal, { silent = true })

-- Optional: Add a specific command for lazygit since it's commonly used
vim.api.nvim_create_user_command("LazyGit", function()
	run_command_and_quit("lazygit")
end, { desc = "Open lazygit in floating terminal" })
