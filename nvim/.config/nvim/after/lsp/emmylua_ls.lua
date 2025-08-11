return {
	cmd = { "emmylua_ls" },
	filetypes = { "lua" },
	root_markers = { ".emmyrc.json", ".luarc.json", ".luarc.jsonc" },
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }, -- tell the LS about the vim global
			},
		},
	},
}
