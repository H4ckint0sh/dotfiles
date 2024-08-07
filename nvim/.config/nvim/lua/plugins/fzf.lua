return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		keymap = {
			fzf = {
				["ctrl-q"] = "select-all+accept",
				["ctrl-u"] = "half-page-up",
				["ctrl-d"] = "half-page-down",
				["ctrl-x"] = "jump",
			},
			builtin = {
				["ctrl-f"] = "preview-page-down",
				["ctrl-b"] = "preview-page-up",
			},
		},
		grep = {
			rg_opts = table.concat({
				"--column",
				"--line-number",
				"--no-heading",
				"--color=always",
				"--smart-case",
				"--max-columns=4096",
				"--hidden",
				"-e",
			}, " "),
		},
	},
	config = function(_, opts)
		-- calling `setup` is optional for customization
		require("fzf-lua").setup(opts)
	end,
}
