local sources = require("util.lualine")

return {
	"nvim-lualine/lualine.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function(_, opts)
		local nord = require("lualine.themes.nord")

		vim.opt.laststatus = 3
		nord.normal.c.bg = "NONE" -- set background color to transparent
		opts.options.theme = nord

		require("lualine").setup(opts)
	end,
	opts = {
		options = {
			component_separators = { left = " ", right = "" },
			section_separators = { left = " ", right = "" },
			globalstatus = true, -- Unified statusline across splits
		},
		sections = {
			lualine_a = { sources.mode },
			lualine_b = { sources.branch, sources.diff },
			lualine_c = { sources.filetype },
			lualine_x = { sources.lsp_formater_linter, sources.diagnostics },
			lualine_y = { sources.indentation, sources.encoding, sources.fileformat },
			lualine_z = { sources.progress, sources.location },
		},
	},
}
