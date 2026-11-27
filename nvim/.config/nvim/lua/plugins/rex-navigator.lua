-- ctrl+h/j/k/l moves between nvim splits and Rex panes.
-- Rex binds ctrl+h/j/k/l itself and, when nvim runs in the pane, passes the key on to
-- nvim (rex/.config/rex/init.lua); this plugin maps <C-h/j/k/l> in nvim and calls
-- `rex focus <dir>` at the edge of the editor.
return {
	"baggiponte/rex-navigator.nvim",
	main = "rex-navigator",
	lazy = false,
	opts = { mappings = true },
}
