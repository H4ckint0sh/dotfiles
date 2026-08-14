---@diagnostic disable: missing-fields
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")
			local parsers = {
				"tsx",
				"typescript",
				"javascript",
				"html",
				"css",
				"vue",
				"svelte",
				"gitcommit",
				"graphql",
				"json",
				"json5",
				"lua",
				"markdown",
				"markdown_inline",
				"regex",
				"bash",
				"vim",
				"astro",
				"vimdoc",
				"diff",
				"git_rebase",
				"toml",
				"gitignore",
				"yaml",
				"git_config",
			}

			treesitter.setup()

			local function enable_treesitter()
				local language = vim.treesitter.language.get_lang(vim.bo.filetype)
				if not language or not vim.list_contains(treesitter.get_installed("parsers"), language) then
					return
				end

				vim.treesitter.start()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end

			local group = vim.api.nvim_create_augroup("nvim-treesitter", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				callback = enable_treesitter,
			})
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "TSUpdate",
				callback = function()
					for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
						if vim.api.nvim_buf_is_loaded(bufnr) then
							vim.api.nvim_buf_call(bufnr, enable_treesitter)
						end
					end
				end,
			})

			treesitter.install(parsers)
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		event = "BufReadPre",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = false, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = true, -- Auto close on trailing </
				},
				-- Also override individual filetype configs, these take priority.
				-- Empty by default, useful if one of the "opts" global settings
				-- doesn't work well in a specific filetype
				--[[ per_filetype = {
            ["html"] = {
              enable_close = false
            }
          } ]]
			})
		end,
	},
}
