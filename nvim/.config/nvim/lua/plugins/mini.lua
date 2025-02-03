return {
	"echasnovski/mini.nvim",
	config = function()
		local extra = require("mini.extra")
		local ai = require("mini.ai")
		ai.setup({
			custom_textobjects = {
				b = extra.gen_ai_spec.buffer(),
				d = extra.gen_ai_spec.diagnostic(),
				i = extra.gen_ai_spec.indent(),
				n = extra.gen_ai_spec.number(),
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
				k = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
				l = ai.gen_spec.treesitter({ a = "@loop.outer", i = "@loop.inner" }),
				c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
				["="] = ai.gen_spec.treesitter({ a = "@assignment.rhs", i = "@assignment.lhs" }),
				s = ai.gen_spec.treesitter({ a = "@assignment.outer", i = "@assignment.inner" }),
			},
		})
		require("mini.surround").setup()
	end,
}
