-- tokyonight Theme
return {
	-- https://github.com/tokyonight/nvim
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "night", -- The theme comes in three styles, `storm`, a darker variant `night` and
		transparent = true, -- Enable this to disable setting the background color.
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
			H["@tag.builtin.tsx"] = { fg = C.red }

				-- To customize lualine/bufferline
				bufferline = {
					current = {},
					modified = { italic = true },
				},
			},
			on_highlights = function(highlights, colors)
				highlights["@tag.builtin.tsx"] = {
					fg = colors.aurora.orange,
				}
				highlights["SnacksDashboardHeader"] = {
					fg = colors.aurora.green,
				}
				highlights["SnacksDashboardFooter"] = {
					fg = colors.frost.artic_water,
				}
				highlights["Special"] = {
					fg = colors.frost.ice,
				}
				highlights["Pmenu"] = {
					bg = colors.polar_night.origin,
				}
				highlights["BlinkCmpMenuBorder"] = {
					fg = colors.frost.ice,
				}
				highlights["IncSearch"] = {
					fg = colors.frost.ice,
				}
			end,
		})
		vim.cmd.colorscheme("nord")
		vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Text" })
		vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "Text" })
		vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { link = "Comment" })
		vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { link = "Special" })
	end,
}
