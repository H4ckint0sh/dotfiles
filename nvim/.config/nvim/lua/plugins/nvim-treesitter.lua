return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"hiphish/rainbow-delimiters.nvim",
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

				textobjects = {
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]]"] = "@jsx.element",
							["]f"] = "@function.outer",
							["]m"] = "@class.outer",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]M"] = "@class.outer",
						},
						goto_previous_start = {
							["[["] = "@jsx.element",
							["[f"] = "@function.outer",
							["[m"] = "@class.outer",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[M"] = "@class.outer",
						},
					},
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["~"] = "@parameter.inner",
						},
					},
				},

				textsubjects = {
					enable = true,
					prev_selection = "<BS>",
					keymaps = {
						["<CR>"] = "textsubjects-smart", -- works in visual mode
					},
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
