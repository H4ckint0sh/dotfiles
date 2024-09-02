return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local action_ok, actions = pcall(require, "fzf-lua.actions")
		local fzf_ok, fzf = pcall(require, "fzf-lua")

		if not fzf_ok or not action_ok then
			return
		end

		fzf.setup({
			winopts = {
				backdrop = 100,
			},
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
			actions = {
				files = {
					["default"] = actions.file_edit,
					["ctrl-h"] = actions.file_split,
					["ctrl-v"] = actions.file_vsplit,
					["alt-q"] = actions.file_sel_to_qf,
					["alt-l"] = actions.file_sel_to_ll,
				},
			},
		})
	end,
}
