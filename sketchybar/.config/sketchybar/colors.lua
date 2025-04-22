return {
	black = 0xff2E3440, -- Background color
	white = 0xffD8DEE9, -- Foreground color
	red = 0xffBF616A,
	green = 0xffA3BE8C,
	blue = 0xff5E81AC,
	yellow = 0xffEBCB8B,
	orange = 0xffD08770,
	pink = 0xffB48EAD,
	purple = 0xffB48EAD,
	other_purple = 0xffB48EAD,
	cyan = 0xff88C0D0,
	grey = 0xff616E88,
	dirty_white = 0xffE5E9F0,
	dark_grey = 0xff282a36,
	transparent = 0x00000000,
	bar = {
		bg = 0xff2E3440,
		border = 0xff3a3c42,
	},
	popup = {
		bg = 0xcf2E3440,
		border = 0xff3a3c42,
	},
	bg1 = 0xff2E3440,
	bg2 = 0xff2E3440,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
