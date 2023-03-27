local M = {}

M.settings = {
	Lua = {
		diagnostics = {
			globals = { 'vim', 'bit', 'packer_plugins' }
		}
	},
	format = {
		enable = true,
		-- Put format options here
		-- NOTE: the value should be STRING!!
		defaultConfig = {
			indent_style = "tab",
			indent_size = "1",
		}
	},
}

return M
