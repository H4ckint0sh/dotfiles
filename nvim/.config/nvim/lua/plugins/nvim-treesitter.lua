---@diagnostic disable: missing-fields
return {
	{
		"bezhermoso/tree-sitter-ghostty",
		build = "make nvim_install",
	},

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"RRethy/nvim-treesitter-textsubjects",
		},
		event = "BufReadPre",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"tsx",
					"typescript",
					"javascript",
					"html",
					"css",
					"vue",
					"astro",
					"svelte",
					"gitcommit",
					"graphql",
					"json",
					"json5",
					"lua",
					"markdown",
					"prisma",
					"glimmer",
					"regex",
					"bash",
					"vim",
					"astro",
					"vimdoc",
					"styled",
					"zig",
					"sql",
					"diff",
					"git_rebase",
					"toml",
					"tmux",
					"gitignore",
					"yaml",
				}, -- one of "all", or a list of languages
				sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
				ignore_install = { "haskell" }, -- list of parsers to ignore installing
				highlight = {
					enable = true,
					-- disable = { "c", "rust" },  -- list of language that will be disabled
					-- additional_vim_regex_highlighting = false,
				},

				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<S-Up>",
						node_incremental = "<S-Up>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				indent = {
					enable = true,
				},
			})
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		event = "BufReadPre",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = false, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = true, -- Auto close on trailing </
				},
				-- Also override individual filetype configs, these take priority.
				-- Empty by default, useful if one of the "opts" global settings
				-- doesn't work well in a specific filetype
				--[[ per_filetype = {
            ["html"] = {
              enable_close = false
            }
          } ]]
			})
		end,
	},
}
