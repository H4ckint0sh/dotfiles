-- kylechui/nvim-surround
require('nvim-surround').setup {
	keymaps = {
		normal = '<leader>sa',
		normal_cur = false,
		normal_line = false,
		normal_cur_line = false,
		visual = '<leader>s',
		visual_line = '<leader>S',
		delete = '<leader>ns',
		change = '<leader>rs',
	},
	aliases = {
		['i'] = ']', -- Index
		['r'] = ')', -- Round
		['b'] = '}', -- Brackets
	},
	move_cursor = false,
}
