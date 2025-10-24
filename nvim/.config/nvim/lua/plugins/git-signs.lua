return {
	"lewis6991/gitsigns.nvim",
	-- Excellent for performance: load only when a buffer is read
	event = "BufRead",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local signs = require("gitsigns") -- Simplified require

		signs.setup({
			signcolumn = true,
			numhl = false,
			linehl = false,
			word_diff = false,
			watch_gitdir = {
				interval = 700,
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 700,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			max_file_length = 40000,
			preview_config = {
				border = "rounded",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			diff_opts = {
				-- internal = true is default, removed for clarity
				algorithm = "patience",
				indent_heuristic = true,
				-- Keeping the granular whitespace control, which is the most explicit
				ignore_whitespace_change = true,
				ignore_whitespace_change_at_eol = true,
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or { noremap = true, silent = true } -- Add silent/noremap defaults for keymaps
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					gitsigns.nav_hunk("next")
				end, { expr = true, desc = "Next Hunk" }) -- Use {expr = true} for conditional mapping

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					gitsigns.nav_hunk("prev")
				end, { expr = true, desc = "Prev Hunk" })

				-- Actions (Using standard <leader>hX convention)
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage Selection" })
				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset Selection" })
				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
				map("n", "<leader>hb", function()
					gitsigns.blame_line({ full = true })
				end, { desc = "Blame Line (Full)" })
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Blame" })
				map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff Index" })
				map("n", "<leader>hD", function()
					gitsigns.diffthis("~")
				end, { desc = "Diff Last Commit" })

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
			end,
		})
	end,
}
