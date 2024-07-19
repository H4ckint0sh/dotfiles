-- tokyonight Theme
return {
	-- https://github.com/tokyonight/nvim
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "night", -- The theme comes in three styles, `storm`, a darker variant `night` and
		styles = {
			-- Style to be applied to different syntax groups
			-- Value is any valid attr-list value for `:help nvim_set_hl`
			comments = { italic = true },
			keywords = { italic = true },
			conditionals = { italic = true },
			functions = {},
			variables = {},
			-- Background styles. Can be "dark", "transparent" or "normal"
			sidebars = "dark", -- style for sidebars, see below
			floats = "transparent", -- style for floating windows
		},
		on_highlights = function(H, C)
			-- Native
			H["@keyword.import"] = { fg = C.purple, italic = true }
			H["@tag.tsx"] = { fg = C.blue2 }
			H["@tag.builtin.tsx"] = { fg = C.red }

			-- Tokyonight
			H.CursorLine = { bg = C.bg_highlight }
			H.LspInlayHint = { bg = "NONE", fg = C.comment }
			H.TelescopeResultsComment = { fg = C.comment }
			H.GitSignsCurrentLineBlame = { fg = C.comment }
			H.DiagnosticVirtualTextError = { bg = "NONE", fg = C.red }
			H.DiagnosticVirtualTextHint = { bg = "NONE", fg = C.teal }
			H.DiagnosticVirtualTextInfo = { bg = "NONE", fg = C.green }
			H.DiagnosticVirtualTextWarn = { bg = "NONE", fg = C.yellow }
			H.WinSeparator = { fg = C.fg, bg = "NONE" }
			H.TroubleNormal = { bg = "NONE", fg = C.fg }
		end,
	},
	config = function(_, opts)
		require("tokyonight").setup(opts) -- Replace this with your favorite colorscheme
		vim.cmd("colorscheme tokyonight") -- Replace this with your favorite colorscheme
	end,
}
