return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({
			{ "telescope" },
			oldfiles = {
				include_current_session = true,
			},
			winopts = {
				preview = {
					horizontal = "right:60%",
				},
			},
			fzf_colors = true,
			fzf_opts = { ["--layout"] = "reverse", ["--marker"] = "+" },
			files = {
				fzf_opts = {
					["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history",
				},
			},
			grep = {
				fzf_opts = {
					["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
				},
				rg_opts = table.concat({
					"--column",
					"--line-number",
					"--no-heading",
					"--color=always",
					"--colors=line:fg:magenta",
					"--colors=column:fg:magenta",
					"--colors=path:fg:white",
					"--colors=match:fg:blue",
					"--smart-case",
					"--max-columns=4096",
					"--hidden",
					"-e",
				}, " "),
				rg_glob = true, -- enable glob parsing
				glob_flag = "--iglob", -- case insensitive globs
				glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
			},
		})
	end,
}
