-- tokyonight Theme
return {
	-- https://github.com/tokyonight/nvim
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "storm", -- The theme comes in three styles, `storm`, a darker variant `night` and
		transparent = false, -- Enable this to disable setting the background color.
		terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim.
		dim_inactive = false, -- dim inactive windows
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
			H["@tag.builtin.tsx"] = { fg = C.cyan }
			--
			-- H.CursorLine = { bg = C.bg_highlight }
			-- H.CursorLineNr = { fg = C.orange }
			-- H.LspInlayHint = { bg = "NONE", fg = C.comment }
			-- H.GitSignsCurrentLineBlame = { fg = C.comment }
			-- H.DiagnosticVirtualTextError = { bg = "NONE", fg = C.red }
			-- H.DiagnosticVirtualTextHint = { bg = "NONE", fg = C.teal }
			-- H.DiagnosticVirtualTextInfo = { bg = "NONE", fg = C.green }
			-- H.DiagnosticVirtualTextWarn = { bg = "NONE", fg = C.yellow }
			-- H.WinSeparator = { fg = C.comment, bg = "NONE" }
			-- H.TroubleNormal = { bg = "NONE", fg = C.fg }

			-- Neogit
			H.NeogitSectionHeader = { fg = C.magenta }

			-- Float
			H.FloatBorder = { fg = C.comment, bg = "NONE" }

			-- Snacks
			H.SnacksDashboardHeader = { fg = C.green }

			-- Barbecue
			H.WinBar = { fg = C.fg, bg = C.bg }
		end,
	},
	config = function(_, opts)
		require("tokyonight").setup(opts) -- Replace this with your favorite colorscheme
		vim.cmd("colorscheme tokyonight") -- Replace this with your favorite colorscheme
		vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Text" })
		vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "Text" })
		vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { link = "Comment" })
		vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { link = "Special" })
	end,
}
