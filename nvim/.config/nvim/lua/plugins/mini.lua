return {
	{
		"echasnovski/mini.nvim",
		config = function()
			local extra = require("mini.extra")
			local ai = require("mini.ai")
			ai.setup({
				custom_textobjects = {
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
	},
	{
		"echasnovski/mini.pairs",
		enabled = true,
		event = { "VeryLazy" },
		version = "*",
		opts = {
			-- In which modes mappings from this `config` should be created
			modes = { insert = true, command = false, terminal = false },

			-- Global mappings. Each right hand side should be a pair information, a
			-- table with at least these fields (see more in |MiniPairs.map|):
			-- - <action> - one of 'open', 'close', 'closeopen'.
			-- - <pair> - two character string for pair to be used.
			-- By default pair is not inserted after `\`, quotes are not recognized by
			-- `<CR>`, `'` does not insert pair after a letter.
			-- Only parts of tables can be tweaked (others will use these defaults).
			mappings = {
				[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
				["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
				["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
				["["] = {
					action = "open",
					pair = "[]",
					neigh_pattern = ".[%s%z%)}%]]",
					register = { cr = false },
					-- foo|bar -> press "[" -> foo[bar
					-- foobar| -> press "[" -> foobar[]
					-- |foobar -> press "[" -> [foobar
					-- | foobar -> press "[" -> [] foobar
					-- foobar | -> press "[" -> foobar []
					-- {|} -> press "[" -> {[]}
					-- (|) -> press "[" -> ([])
					-- [|] -> press "[" -> [[]]
				},
				["{"] = {
					action = "open",
					pair = "{}",
					-- neigh_pattern = ".[%s%z%)}]",
					neigh_pattern = ".[%s%z%)}%]]",
					register = { cr = false },
					-- foo|bar -> press "{" -> foo{bar
					-- foobar| -> press "{" -> foobar{}
					-- |foobar -> press "{" -> {foobar
					-- | foobar -> press "{" -> {} foobar
					-- foobar | -> press "{" -> foobar {}
					-- (|) -> press "{" -> ({})
					-- {|} -> press "{" -> {{}}
				},
				["("] = {
					action = "open",
					pair = "()",
					-- neigh_pattern = ".[%s%z]",
					neigh_pattern = ".[%s%z%)]",
					register = { cr = false },
					-- foo|bar -> press "(" -> foo(bar
					-- foobar| -> press "(" -> foobar()
					-- |foobar -> press "(" -> (foobar
					-- | foobar -> press "(" -> () foobar
					-- foobar | -> press "(" -> foobar ()
				},
				-- Single quote: Prevent pairing if either side is a letter
				['"'] = {
					action = "closeopen",
					pair = '""',
					neigh_pattern = "[^%w\\][^%w]",
					register = { cr = false },
				},
				-- Single quote: Prevent pairing if either side is a letter
				["'"] = {
					action = "closeopen",
					pair = "''",
					neigh_pattern = "[^%w\\][^%w]",
					register = { cr = false },
				},
				-- Backtick: Prevent pairing if either side is a letter
				["`"] = {
					action = "closeopen",
					pair = "``",
					neigh_pattern = "[^%w\\][^%w]",
					register = { cr = false },
				},
			},
		},
	},
}
