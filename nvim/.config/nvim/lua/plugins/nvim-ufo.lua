return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
		{
			"luukvbaal/statuscol.nvim",
			config = function()
				local builtin = require("statuscol.builtin")
				require("statuscol").setup({
					relculright = true,
					segments = {
						{
							sign = { namespace = { "gitsigns" }, colwidth = 1, maxwidth = 1 },
							click = "v:lua.ScSa",
						},
						{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
						{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
					},
				})
			end,
		},
	},
	opts = {
		-- INFO: Uncomment to use treesitter as fold provider, otherwise nvim lsp is used
		provider_selector = function(bufnr, filetype, _)
			local fmap = { lua = { "lsp", "treesitter" } }

			return fmap[filetype]
				or function()
					local function handle_fallback_exception(err, providerName)
						if type(err) == "string" and err:match("UfoFallbackException") then
							return require("ufo").getFolds(bufnr, providerName)
						else
							return require("promise").reject(err)
						end
					end

					return require("ufo")
						.getFolds(bufnr, "lsp")
						:catch(function(err)
							return handle_fallback_exception(err, "treesitter")
						end)
						:catch(function(err)
							return handle_fallback_exception(err, "indent")
						end)
				end
		end,

		open_fold_hl_timeout = 400,
		close_fold_kinds_for_ft = { default = { "imports", "comment" } },
		preview = {
			win_config = {
				border = { "", "─", "", "", "", "─", "", "" },
				-- winhighlight = "Normal:Folded",
				winblend = 0,
			},
			mappings = {
				scrollU = "<C-u>",
				scrollD = "<C-d>",
				jumpTop = "[",
				jumpBot = "]",
			},
		},
	},
	init = function()
		vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
		vim.o.foldcolumn = "1" -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		-- Tell the server the capability of foldingRange,
		-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}
		local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
		for _, ls in ipairs(language_servers) do
			require("lspconfig")[ls].setup({
				capabilities = capabilities,
				-- you can add other fields for setting up lsp server in this table
			})
		end
	end,
	config = function(_, opts)
		local handler = function(virtText, lnum, endLnum, width, truncate)
			local alignLimitByTextWidth = true -- limit the alignment of the fold text by:
			-- true: the textwidth value, false: the width of the current window
			local alignLimiter = alignLimitByTextWidth and vim.opt.textwidth["_value"] or vim.api.nvim_win_get_width(0)
			local newVirtText = {}
			local totalLines = vim.api.nvim_buf_line_count(0)
			local foldedLines = endLnum - lnum
			local suffix = (" 󰁂 %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
			local sufWidth = vim.fn.strdisplaywidth(suffix)
			local targetWidth = width - sufWidth
			local curWidth = 0
			for _, chunk in ipairs(virtText) do
				local chunkText = chunk[1]
				local chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if targetWidth > curWidth + chunkWidth then
					table.insert(newVirtText, chunk)
				else
					chunkText = truncate(chunkText, targetWidth - curWidth)
					local hlGroup = chunk[2]
					table.insert(newVirtText, { chunkText, hlGroup })
					chunkWidth = vim.fn.strdisplaywidth(chunkText)
					-- str width returned from truncate() may less than 2nd argument, need padding
					if curWidth + chunkWidth < targetWidth then
						suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
					end
					break
				end
				curWidth = curWidth + chunkWidth
			end
			local rAlignAppndx = math.max(math.min(alignLimiter, width - 1) - curWidth - sufWidth, 0)
			suffix = (" "):rep(rAlignAppndx) .. suffix
			table.insert(newVirtText, { suffix, "MoreMsg" })
			return newVirtText
		end
		opts["fold_virt_text_handler"] = handler
		require("ufo").setup(opts)
		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		vim.keymap.set("n", "zs", require("ufo").openFoldsExceptKinds)
		vim.keymap.set("n", "K", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover()
			end
		end)
	end,
}
