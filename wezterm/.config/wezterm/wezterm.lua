-- local b = require("utils/background")
local wezterm = require("wezterm")
local wt_action = require("wezterm").action
local k = require("utils/keys")
-- Load the colors from my existing neobean colors.lua file
local colors = dofile(os.getenv("HOME") .. "/.config/nvim/lua/util/colors.lua")

-- Restart wezterm when the active colorscheme changes
wezterm.add_to_config_reload_watch_list(os.getenv("HOME") .. "/colorscheme/active/active-colorscheme.sh")

local config = {

	colors = {
		-- The default text color
		foreground = colors["h4ckint0sh_color07"],
		-- The default background color
		background = colors["h4ckint0sh_color10"],

		-- Overrides the cell background color when the current cell is occupied by the cursor
		cursor_bg = colors["h4ckint0sh_color14"],
		-- Overrides the text color when the current cell is occupied by the cursor
		cursor_fg = colors["h4ckint0sh_color10"],
		-- Specifies the border color of the cursor when the cursor style is set to Block
		cursor_border = colors["h4ckint0sh_color02"],

		-- The foreground color of selected text
		selection_fg = colors["h4ckint0sh_color14"],
		-- The background color of selected text
		selection_bg = colors["h4ckint0sh_color16"],

		-- The color of the scrollbar "thumb"; the portion that represents the current viewport
		scrollbar_thumb = colors["h4ckint0sh_color10"],

		-- The color of the split lines between panes
		split = colors["h4ckint0sh_color14"],

		-- ANSI color palette
		ansi = {
			colors["h4ckint0sh_color10"], -- black
			colors["h4ckint0sh_color11"], -- red
			colors["h4ckint0sh_color03"], -- green
			colors["h4ckint0sh_color12"], -- yellow
			colors["h4ckint0sh_color02"], -- blue
			colors["h4ckint0sh_color04"], -- magenta
			colors["h4ckint0sh_color08"], -- cyan
			colors["h4ckint0sh_color14"], -- white
		},

		-- Bright ANSI color palette
		brights = {
			colors["h4ckint0sh_color15"], -- bright black
			colors["h4ckint0sh_color11"], -- bright red
			colors["h4ckint0sh_color03"], -- bright green
			colors["h4ckint0sh_color12"], -- bright yellow
			colors["h4ckint0sh_color02"], -- bright blue
			colors["h4ckint0sh_color04"], -- bright magenta
			colors["h4ckint0sh_color08"], -- bright cyan
			colors["h4ckint0sh_color14"], -- bright white
		},
	},
	window_background_opacity = 1,
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = false,
	allow_win32_input_mode = false,
	-- Disable deafault keybindings
	disable_default_key_bindings = true,
	window_close_confirmation = "NeverPrompt",
	enable_tab_bar = false,
	term = "tmux-256color",
	front_end = "WebGpu",
	window_decorations = "RESIZE",
	font = wezterm.font_with_fallback({
		{ family = "Maple Mono", weight = "Regular" },
		{ family = "Symbols Nerd Font" },
	}),
	font_size = 14.0,
	line_height = 1.2,
	underline_position = -6, -- Adjust this value as needed
	native_macos_fullscreen_mode = false,
	keys = {
		k.key_table("CMD", "0", wt_action.ResetFontSize),
		k.key_table("CMD", "-", wt_action.DecreaseFontSize),
		k.key_table("CMD", "+", wt_action.IncreaseFontSize),
		k.key_table("CMD", "q", wt_action.QuitApplication),
		k.key_table("CMD", "v", wt_action.PasteFrom("Clipboard")),
		k.key_table("CMD", "LeftArrow", wt_action.SendString("\x02\x08")),
		k.key_table("CMD", "RightArrow", wt_action.SendString("\x02\x0c")),
		k.key_table("CMD", "UpArrow", wt_action.SendString("x02\x0b")),
		k.key_table("CMD", "DownArrow", wt_action.SendString("x02\x0a")),
		k.key_table("CMD|ALT", "LeftArrow", wt_action.SendString("\x02p")),
		k.key_table("CMD|ALT", "RightArrow", wt_action.SendString("\x02n")),

		k.cmd_to_tmux_prefix("1", "1"),
		k.cmd_to_tmux_prefix("2", "2"),
		k.cmd_to_tmux_prefix("3", "3"),
		k.cmd_to_tmux_prefix("4", "4"),
		k.cmd_to_tmux_prefix("5", "5"),
		k.cmd_to_tmux_prefix("6", "6"),
		k.cmd_to_tmux_prefix("7", "7"),
		k.cmd_to_tmux_prefix("8", "8"),
		k.cmd_to_tmux_prefix("9", "9"),
		k.cmd_to_tmux_prefix("b", "B"),
		k.cmd_to_tmux_prefix("C", "C"),
		k.cmd_to_tmux_prefix("d", "D"),
		k.cmd_to_tmux_prefix("G", "G"),
		k.cmd_to_tmux_prefix("g", "g"),
		k.cmd_to_tmux_prefix("K", "T"),
		k.cmd_to_tmux_prefix("k", "K"),
		k.cmd_to_tmux_prefix("l", "L"),
		k.cmd_to_tmux_prefix("n", '"'),
		k.cmd_to_tmux_prefix("N", "%"),
		k.cmd_to_tmux_prefix("o", "u"),
		k.cmd_to_tmux_prefix("T", "!"),
		k.cmd_to_tmux_prefix("s", "s"),
		k.cmd_to_tmux_prefix("r", "R"),
		k.cmd_to_tmux_prefix("t", "c"),
		k.cmd_to_tmux_prefix("w", "x"),
		k.cmd_to_tmux_prefix("z", "z"),
		k.cmd_to_tmux_prefix("i", "i"),
		k.cmd_to_tmux_prefix("[", "["),
		-- k.cmd_to_tmux_prefix("Z", "Z"),
	},
}

return config
