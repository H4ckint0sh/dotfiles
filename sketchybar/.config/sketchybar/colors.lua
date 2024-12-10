-- Dracula Colors

return {
	black = 0xff414868,
	white = 0xffc0caf5,
	red = 0xfff7768e,
	green = 0xff9ece6a,
	blue = 0xff5199ba,
	yellow = 0xffe0af68,
	orange = 0xffff9e64,
	pink = 0xffFF80BF,
	purple = 0xffbb9af7,
	other_purple = 0xff9d7cd8,
	cyan = 0xff7dcfff,
	grey = 0xff7f8490,
	dirty_white = 0xc8cad3f5,
	dark_grey = 0xff2b2736,
	transparent = 0x00000000,
	bar = {
		bg = 0xf822212C,
		border = 0xff2c2e34,
	},
	popup = {
		bg = 0xd322212c,
		border = 0xd322212c,
	},
	bg1 = 0x331e1d27,
	bg2 = 0xff302c45,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
