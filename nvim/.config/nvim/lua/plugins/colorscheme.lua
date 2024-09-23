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
			sidebars = "normal", -- style for sidebars, see below
			floats = "normal", -- style for floating windows
		},
		on_highlights = function(H, C)
			-- Native
			H["@keyword.import"] = { fg = C.purple, italic = true }
			H["@tag.tsx"] = { fg = C.blue2 }
			H["@tag.builtin.tsx"] = { fg = C.red }

			H.CursorLine = { bg = C.bg_highlight }
			H.CursorLineNr = { fg = C.fg }
			H.LspInlayHint = { bg = "NONE", fg = C.comment }
			H.GitSignsCurrentLineBlame = { fg = C.comment }
			H.DiagnosticVirtualTextError = { bg = "NONE", fg = C.red }
			H.DiagnosticVirtualTextHint = { bg = "NONE", fg = C.teal }
			H.DiagnosticVirtualTextInfo = { bg = "NONE", fg = C.green }
			H.DiagnosticVirtualTextWarn = { bg = "NONE", fg = C.yellow }
			H.WinSeparator = { fg = C.fg, bg = "NONE" }
			H.TroubleNormal = { bg = "NONE", fg = C.fg }

			-- Neogit
			H.NeogitSectionHeader = { fg = C.magenta }

			-- NvimTree
			H.NvimTreeWinSeparator = { fg = C.fg, bg = C.bg_dark }
			H.NvimTreeFolderIcon = { fg = C.yellow }

			-- Fzf
			H.FzfLuaBorder = { fg = C.comment }
			H.FzfLuaCursorLine = { bg = C.bg_dark }
			H.FzfLuaScrollFloatEmpty = { bg = C.fg }
			H.FzfLuaScrollFloatEmpty = { bg = C.fg }
			H.FzfLuaScrollFloatFull = { bg = C.fg }
			H.FzfLuaFzfScrollbar = { fg = C.comment }
			H.FzfLuaFzfBorder = { fg = C.comment }
			H.FzfLuaPreviewTitle = { fg = C.fg }
			H.FzfLuaCursorLine = { bg = C.bg_highlight }

			-- Neocodeium
			H.NeoCodeiumSuggestion = { bg = "NONE", fg = C.comment }
			H.NeoCodeiumLabel = { bg = "NONE", fg = C.comment }
		end,
	},
	config = function(_, opts)
		require("tokyonight").setup(opts) -- Replace this with your favorite colorscheme
		vim.cmd("colorscheme tokyonight") -- Replace this with your favorite colorscheme
	end,
}
