return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				-- This will not install any breaking changes.
				-- For major updates, this must be adjusted manually.
				version = "^1.0.0",
			},
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					border = true,
					hl_result_eol = true,
					multi_icon = "",
					find_files = {
						hidden = true, -- Enable showing hidden files
					},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
					layout_config = {
						width = 0.95,
						height = 0.85,
						prompt_position = "top",
						horizontal = {
							-- width_padding = 0.1,
							-- height_padding = 0.1,
							width = 0.9,
							preview_cutoff = 60,
							preview_width = function(_, cols, _)
								if cols > 200 then
									return math.floor(cols * 0.7)
								else
									return math.floor(cols * 0.6)
								end
							end,
						},
						vertical = {
							-- width_padding = 0.05,
							-- height_padding = 1,
							width = 0.75,
							height = 0.85,
							preview_height = 0.4,
							mirror = true,
						},
						flex = {
							-- change to horizontal after 120 cols
							flip_columns = 120,
						},
					},
					file_sorter = require("telescope.sorters").get_fzy_sorter,
					prompt_prefix = "   ",
					color_devicons = true,
					sorting_strategy = "ascending",
					file_previewer = require("telescope.previewers").vim_buffer_cat.new,
					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
					qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
					mappings = {
						i = {
							["<C-x>"] = false,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
							["<C-s>"] = actions.cycle_previewers_next,
							["<C-a>"] = actions.cycle_previewers_prev,
							-- ["<C-h>"] = "which_key",
							["<ESC>"] = actions.close,
						},
						n = {
							["<C-s>"] = actions.cycle_previewers_next,
							["<C-a>"] = actions.cycle_previewers_prev,
						},
					},
				},
				extensions = {
					fzf = {
						override_generic_sorter = false,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			telescope.load_extension("fzf")

			-- set keymaps
			local keymap = vim.keymap -- for conciseness

			keymap.set(
				"n",
				"<C-p>",
				"<cmd>Telescope find_files hidden=true no_ignore=true<cr>",
				{ desc = "Fuzzy find files in cwd" }
			)
			keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
			keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
			keymap.set(
				"n",
				"<leader>fc",
				"<cmd>Telescope grep_string<cr>",
				{ desc = "Find string under cursor in cwd" }
			)
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("live_grep_args")
		end,
	},
}
