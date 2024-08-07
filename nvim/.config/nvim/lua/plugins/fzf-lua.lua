return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		local config = require("fzf-lua.config")

		-- Quickfix
		config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
		config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
		config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
		config.defaults.keymap.fzf["ctrl-x"] = "jump"
		config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
		config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"
	end,
	config = function(_, opts)
		-- calling `setup` is optional for customization
		require("fzf-lua").setup(opts)
	end,
}
