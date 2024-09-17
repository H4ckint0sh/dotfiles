local colorscheme = require("colorscheme")
M = {}

M.merge = function(left, right)
	for k, v in pairs(right) do
		left[k] = v
	end
	return left
end

M.color = colorscheme.current
M.font_face = "JetBrainsMono Nerd Font"

M.font = {
	bold_24 = {
		family = M.font_face,
		style = "Bold",
		size = 18.0,
	},
	medium_20 = {
		family = M.font_face,
		style = "Medium",
		size = 16.0,
	},
	separator = {
		family = M.font_face,
		style = "Regular",
		size = 24.0,
	},
}

M.get_left_separator = function(color, override)
	override = override or {}
	return M.merge({
		icon = {
			string = "",
			color = M.color[color],
			font = M.font.separator,
			padding_right = -16,
		},
		label = { drawing = false },
		background = { drawing = false },
	}, override)
end

M.get_right_separator = function(color, override)
	override = override or {}
	return M.merge({
		icon = {
			string = "",
			color = M.color[color],
			font = M.font.separator,
			padding_left = -16,
			padding_right = 0,
		},
		label = { drawing = false },
		background = { drawing = false },
	}, override)
end

M.get_spacer = function(size, override)
	override = override or {}
	return M.merge({
		icon = { drawing = false },
		label = { drawing = false },
		background = {
			color = M.color.transparent,
			padding_left = size,
		},
	}, override)
end

return M
