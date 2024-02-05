local wezterm = require("wezterm")
local wt_action = require("wezterm").action
local k = require("utils/keys")

local config = {
	color_scheme = 'Tokyo Night Storm',
	window_background_opacity = 0.95,
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = true,
	-- Disable deafault keybindings
	disable_default_key_bindings = true,
	window_close_confirmation = 'NeverPrompt',
	enable_tab_bar = false,
	window_decorations = "RESIZE",
	font = wezterm.font("DankMono Nerd Font", { weight = "Regular" }),
	front_end = "WebGpu",
	font_size = 12.0,
	line_height = 1.15,
	native_macos_fullscreen_mode = false,
	keys = {
		k.key_table("CMD", "0", wt_action.ResetFontSize),
		k.key_table("CMD", "-", wt_action.DecreaseFontSize),
		k.key_table("CMD", "+", wt_action.IncreaseFontSize),
		k.key_table("CMD", "q", wt_action.QuitApplication),
		k.key_table("CMD", "v", wt_action.PasteFrom 'Clipboard'),
		k.key_table("CMD", "LeftArrow", wt_action.SendString "\x02\x08"),
		k.key_table("CMD", "RightArrow", wt_action.SendString "\x02\x0c"),
		k.key_table("CMD", "UpArrow", wt_action.SendString "x02\x0b"),
		k.key_table("CMD", "DownArrow", wt_action.SendString "x02\x0a"),
		k.key_table("CMD|SHIFT", "LeftArrow", wt_action.SendString "\x02p"),
		k.key_table("CMD|SHIFT", "RightArrow", wt_action.SendString "\x02n"),


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
		k.cmd_to_tmux_prefix("s", "S"),
		k.cmd_to_tmux_prefix("l", "L"),
		k.cmd_to_tmux_prefix("n", '"'),
		k.cmd_to_tmux_prefix("N", "%"),
		k.cmd_to_tmux_prefix("o", "u"),
		k.cmd_to_tmux_prefix("T", "!"),
		k.cmd_to_tmux_prefix("t", "c"),
		k.cmd_to_tmux_prefix("w", "x"),
		k.cmd_to_tmux_prefix("z", "z"),
		-- k.cmd_to_tmux_prefix("Z", "Z"),
	},
}

return config
