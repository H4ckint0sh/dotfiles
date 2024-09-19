local sources = require("util.lualine")

return {
	"nvim-lualine/lualine.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function(_, opts)
		local colors = require("tokyonight.colors").setup({ style = "night" })
		local tokyonight = require("lualine.themes.tokyonight")

		vim.opt.laststatus = 3
		tokyonight.normal.c.bg = colors.bg
		opts.options.theme = tokyonight

		require("lualine").setup(opts)
	end,
	opts = {
		options = {
			component_separators = { left = " ", right = "" },
			section_separators = { left = " ", right = "" },
			ignore_focus = { "NvimTree" },
		},
		sections = {
			lualine_a = { sources.filetree, sources.mode },
			lualine_b = { sources.branch, sources.diff },
			lualine_c = { sources.filetype, sources.macro },
			lualine_x = { sources.lsp_formater_linter, sources.diagnostics },
			lualine_y = { sources.indentation, sources.encoding, sources.fileformat },
			lualine_z = { sources.progress, sources.location },
		},
	},
}
