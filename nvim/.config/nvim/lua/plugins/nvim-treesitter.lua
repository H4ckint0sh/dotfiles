-- Code Tree Support / Syntax Highlighting
return {
	{
		-- https://github.com/nvim-treesitter/nvim-treesitter
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		dependencies = {
			-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
			"hiphish/rainbow-delimiters.nvim",
			"JoosepAlviste/nvim-ts-context-commentstring",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"RRethy/nvim-treesitter-textsubjects",
		},
		build = ":TSUpdate",
		opts = {
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
				"astro",
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
				select = {
					enable = true,
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["as"] = "@assignment.outer",
						["is"] = "@assignment.inner",
						["ls"] = "@assignment.lhs",
						["rs"] = "@assignment.rhs",

						-- works for javascript/typescript files (custom capture I created in after/queries/ecma/textobjects.scm)
						["ar"] = "@property.outer",
						["ir"] = "@property.inner",
						["lr"] = "@property.lhs",
						["rr"] = "@property.rhs",

						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",

						["ai"] = "@conditional.outer",
						["ii"] = "@conditional.inner",

						["al"] = "@loop.outer",
						["il"] = "@loop.inner",

						["af"] = "@call.outer",
						["if"] = "@call.inner",

						["am"] = "@function.outer",
						["im"] = "@function.inner",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
						["<leader>n:"] = "@property.outer", -- swap object property with next
						["<leader>nm"] = "@function.outer", -- swap function with next
					},
					swap_previous = {
						["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
						["<leader>p:"] = "@property.outer", -- swap object property with prev
						["<leader>pm"] = "@function.outer", -- swap function with previous
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]f"] = "@call.outer",
						["]m"] = "@function.outer",
						["]c"] = "@class.outer",
						["]i"] = "@conditional.outer",
						["]l"] = "@loop.outer",

						-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
						-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
						["]s"] = "@scope",
						["]z"] = "@fold",
					},
					goto_next_end = {
						["]F"] = "@call.outer",
						["]M"] = "@function.outer",
						["]C"] = "@class.outer",
						["]I"] = "@conditional.outer",
						["]L"] = "@loop.outer",
					},
					goto_previous_start = {
						["[f"] = "@call.outer",
						["[m"] = "@function.outer",
						["[c"] = "@class.outer",
						["[i"] = "@conditional.outer",
						["[l"] = "@loop.outer",
					},
					goto_previous_end = {
						["[F"] = "@call.outer",
						["[M"] = "@function.outer",
						["[C"] = "@class.outer",
						["[I"] = "@conditional.outer",
						["[L"] = "@loop.outer",
					},
				},
			},
		},
		config = function(_, opts)
			local configs = require("nvim-treesitter.configs")

			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			-- vim way: ; goes to the direction you were moving.
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

			-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
			configs.setup(opts)
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
	{
		"hiphish/rainbow-delimiters.nvim",
		lazy = false,
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")

			---@type rainbow_delimiters.config
			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					commonlisp = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
					javascript = "rainbow-parens",
					typescript = "rainbow-parens",
					tsx = "rainbow-parens",
					handlebars = "rainbow_blocks",
				},
				priority = {
					[""] = 110,
					lua = 210,
				},
				-- highlight = overrides.rainbow_delimiters.highlight,
				blacklist = { "c", "cpp" },
			}
		end,
	},
}
