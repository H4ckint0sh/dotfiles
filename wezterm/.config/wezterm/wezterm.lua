local wezterm = require("wezterm")

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
	font_size = 18.0,
	line_height = 1.1,
	freetype_load_flags = 'NO_HINTING',
	native_macos_fullscreen_mode = true,
	keys = {
		{ key = "0", mods = "CMD", action = wezterm.action.ResetFontSize },
		{ key = "-", mods = "CMD", action = wezterm.action.DecreaseFontSize },
		{ key = "+", mods = "CMD", action = wezterm.action.IncreaseFontSize },
		{ key = "q", mods = "CMD", action = wezterm.action.QuitApplication },
		{ key = "v", mods = "CMD", action = wezterm.action.PasteFrom 'Clipboard' },
		{
			key = "P",
			mods = "CTRL|SHIFT",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = "k",
			mods = "CMD",
			action = wezterm.action.SendString "\x02s",
		},
		{
			key = "Numpad1",
			mods = "CMD",
			action = wezterm.action.SendString "\x021",
		},
		{
			key = "Numpad2",
			mods = "CMD",
			action = wezterm.action.SendString "\x022",
		},
		{
			key = "Numpad3",
			mods = "CMD",
			action = wezterm.action.SendString "\x023",
		},
		{
			key = "Numpad4",
			mods = "CMD",
			action = wezterm.action.SendString "\x024",
		},
		{
			key = "Numpad5",
			mods = "CMD",
			action = wezterm.action.SendString "\x025",
		},
		{
			key = "Numpad6",
			mods = "CMD",
			action = wezterm.action.SendString "\x026",
		},
		{
			key = "Numpad7",
			mods = "CMD",
			action = wezterm.action.SendString "\x027",
		},
		{
			key = "Numpad8",
			mods = "CMD",
			action = wezterm.action.SendString "\x028",
		},
		{
			key = "Numpad9",
			mods = "CMD",
			action = wezterm.action.SendString "\x029",
		},
		{
			key = "g",
			mods = "CMD",
			action = wezterm.action.SendString "\x02g",
		},
		{
			key = ":",
			mods = "CMD",
			action = wezterm.action.SendString "\x02:",
		},
		{
			key = "c",
			mods = "CMD|SHIFT",
			action = wezterm.action.SendString "\x02\x5b",
		},
		{
			key = "r",
			mods = "CMD",
			action = wezterm.action.SendString "\x02,",
		},
		{
			key = "l",
			mods = "CMD",
			action = wezterm.action.SendString "\x02L",
		},
		{
			key = "LeftArrow",
			mods = "CMD|SHIFT",
			action = wezterm.action.SendString "\x02p",
		},
		{
			key = "RightArrow",
			mods = "CMD|SHIFT",
			action = wezterm.action.SendString "\x02n",
		},
		{
			key = "LeftArrow",
			mods = "CMD",
			action = wezterm.action.SendString "\x02\x08",
		},
		{
			key = "RightArrow",
			mods = "CMD",
			action = wezterm.action.SendString "\x02\x0c",
		},
		{
			key = "DownArrow",
			mods = "CMD",
			action = wezterm.action.SendString "\x02\x0a",
		},
		{
			key = "UpArrow",
			mods = "CMD",
			action = wezterm.action.SendString "\x02\x0b",
		},
		{
			key = "d",
			mods = "CMD",
			action = wezterm.action.SendString "\x02%",
		},
		{
			key = "d",
			mods = "CMD|SHIFT",
			action = wezterm.action.SendString "\x02\"",
		},
		{
			key = "t",
			mods = "CMD",
			action = wezterm.action.SendString "\x02c",
		},
		{
			key = "w",
			mods = "CMD",
			action = wezterm.action.SendString "\x02x",
		},
		{
			key = "e",
			mods = "CMD",
			action = wezterm.action.SendString "\x02\x65",
		},
		{
			key = "i",
			mods = "CMD",
			action = wezterm.action.SendString "\x02\x69",
		},
		{
			key = "j",
			mods = "CMD",
			action = wezterm.action.SendString "\x02\x54",
		},
		{
			key = "z",
			mods = "CMD",
			action = wezterm.action.SendString "\x02z",
		},
		-- Cycle trough panes
		{
			key = "Tab",
			mods = "CTRL",
			action = wezterm.action.SendString "\x02\x6f",
		},
		-- Cycle trugh layouts
		{
			key = "Tab",
			mods = "CTRL|SHIFT",
			action = wezterm.action.SendString "\x02\x20",
		},
		{
			key = "a",
			mods = "CMD",
			action = wezterm.action.SendString "\x02\x61",
		},
		{
			key = "o",
			mods = "CMD",
			action = wezterm.action.SendString "\x02u",
		},
		-- Break pane out of window
		{
			key = "b",
			mods = "CMD",
			action = wezterm.action.SendString "\x02\x21",
		},
		-- Swap with previuos pane
		{
			key = "p",
			mods = "CMD",
			action = wezterm.action.SendString "\x02\x7b",
		},
		-- Swap with next pane
		{
			key = "n",
			mods = "CMD",
			action = wezterm.action.SendString "\x02\x7d",
		},
		{
			key = "f",
			mods = "CMD",
			action = wezterm.action.SendString '\x02\x06'
		},
	},
}

return config
