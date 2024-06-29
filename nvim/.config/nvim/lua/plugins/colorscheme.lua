-- Catppuccin Theme
return {
	-- https://github.com/catppuccin/nvim
	"catppuccin/nvim",
	name = "catppuccin", -- name is needed otherwise plugin shows up as "nvim" due to github URI
	lazy = false, -- We want the colorscheme to load immediately when starting Neovim
	priority = 1000, -- Load the colorscheme before other non-lazy-loaded plugins
	opts = {
		--   -- Replace this with your scheme-specific settings or remove to use the defaults
		-- transparent = true,
		flavour = "mocha", -- "latte, frappe, macchiato, mocha"
		no_bold = true, --No Bold
		styles = { -- Haes the styles of general hi groups (see `:h highlight-args`):
			comments = { "italic" }, -- Change the style of comments
			conditionals = { "italic" },
			loops = {},
			functions = {},
			keywords = { "italic" },
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
			operators = {},
			-- miscs = {}, -- Uncomment to turn off hard-coded styles
		},
		custom_highlights = function(colors)
			return {
				TelescopeResultsComment = { fg = colors.overlay0 },
				GitSignsCurrentLineBlame = { fg = colors.overlay0 },
				DiagnosticVirtualTextError = { bg = colors.none },
				DiagnosticVirtualTextHint = { bg = colors.none },
				DiagnosticVirtualTextInfo = { bg = colors.none },
				DiagnosticVirtualTextWarn = { bg = colors.none },
				TelescopePromptBorder = { fg = colors.text, bg = colors.none },
				TelescopeResultsBorder = { fg = colors.text, bg = colors.none },
				TelescopePreviewBorder = { fg = colors.text, bg = colors.none },
				NormalFloat = { bg = colors.none },
				FloatBorder = { fg = colors.text, bg = colors.none },
				Pmenu = { bg = colors.none },
				WinSeparator = { fg = colors.text, bg = colors.none },
				TroubleNormal = { bg = colors.none, fg = colors.text },
				NoiceCmdlinePopupBorder = { bg = colors.none, fg = colors.text },
				NoiceCmdlinePopupBorderCmdline = { bg = colors.none, fg = colors.text },
				NoiceCmdlinePopupBorderCalculator = { bg = colors.none, fg = colors.text },
				NoiceCmdlinePopupBorderFilter = { bg = colors.none, fg = colors.text },
				NoiceCmdlinePopupBorderHelp = { bg = colors.none, fg = colors.text },
				NoiceCmdlinePopupBorderIncRename = { bg = colors.none, fg = colors.text },
				NoiceCmdlinePopupBorderInput = { bg = colors.none, fg = colors.text },
				NoiceCmdlinePopupBorderLua = { bg = colors.none, fg = colors.text },
				NoiceCmdlinePopupBorderSearch = { bg = colors.none, fg = colors.text },
				NoiceCmdlineIconSearch = { bg = colors.none, fg = colors.mauve },
			}
		end,
		highlight_overrides = {
			all = function(colors)
				return {
					Tag = { fg = colors.red },
				}
			end,
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts) -- Replace this with your favorite colorscheme
		vim.cmd("colorscheme catppuccin") -- Replace this with your favorite colorscheme
	end,
}
