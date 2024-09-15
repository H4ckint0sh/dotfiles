-- add this to the file where you setup your other plugins:
return {
	"monkoose/neocodeium",
	event = "VeryLazy",
	config = function()
		local neocodeium = require("neocodeium")
		local cmp = require("cmp")
		neocodeium.setup({
			filter = function()
				return not cmp.visible()
			end,
			filetypes = { DressingInput = false },
		})

		vim.keymap.set("i", "<C-f>", neocodeium.accept)
	end,
}
