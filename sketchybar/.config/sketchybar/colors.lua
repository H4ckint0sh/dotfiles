-- Filename: ~/github/dotfiles-latest/sketchybar/felixkratz-h4ckint0sh/colors.lua

local colors = dofile(os.getenv("HOME") .. "/.config/nvim/lua/util/colors.lua")

-- Helper function to convert hex to formatted values
local function hex_to_rgba(hex, alpha_prefix)
	-- Default alpha is "0xff" (fully opaque)
	local alpha = tonumber(alpha_prefix or "0xff", 16) or 0xff
	-- Remove any unwanted characters (such as "#" or quotes)
	hex = hex:gsub("#", ""):gsub('"', "")

	-- Convert hex to integer
	local color = tonumber(hex, 16)

	-- Combine color and alpha (alpha should be the most significant byte)
	-- Use bitwise operations to shift alpha and combine it with the color
	if color then
		return (alpha << 24) | color
	else
		return 0 -- Default if parsing failed
	end
end

-- h4ckint0sh Theme
return {
	black = hex_to_rgba(colors["h4ckint0sh_color10"]),
	white = hex_to_rgba(colors["h4ckint0sh_color14"]),
	red = hex_to_rgba(colors["h4ckint0sh_color11"]),
	green = hex_to_rgba(colors["h4ckint0sh_color02"]),
	blue = hex_to_rgba(colors["h4ckint0sh_color03"]),
	yellow = hex_to_rgba(colors["h4ckint0sh_color12"]),
	orange = hex_to_rgba(colors["h4ckint0sh_color04"]),
	pink = hex_to_rgba(colors["h4ckint0sh_color01"]),
	purple = hex_to_rgba(colors["h4ckint0sh_color01"]),
	other_purple = 0xff9d7cd8,
	cyan = 0xff7dcfff,
	grey = hex_to_rgba(colors["h4ckint0sh_color09"]),
	transparent = 0x00000000,
	bg1 = hex_to_rgba(colors["h4ckint0sh_color10"]),
	bg2 = hex_to_rgba(colors["h4ckint0sh_color10"], "0xcf"),
	bar = {
		bg = hex_to_rgba(colors["h4ckint0sh_color10"], "0xcf"),
		border = hex_to_rgba(colors["h4ckint0sh_color07"], "0x60"),
	},
	popup = {
		bg = hex_to_rgba(colors["h4ckint0sh_color10"], "0xcf"),
		border = hex_to_rgba(colors["h4ckint0sh_color14"]),
	},
	shadow = hex_to_rgba(colors["h4ckint0sh_color10"]),

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
