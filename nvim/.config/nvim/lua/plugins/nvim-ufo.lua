return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	opts = {
		-- Revert to the original complex, but robust, fallback logic
		provider_selector = function(bufnr, filetype, _)
			local fmap = { lua = { "lsp", "treesitter" } } -- Keep custom maps

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
	},

	init = function()
		-- Global options are fine here
		vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,fold: ,foldclose:]]
		vim.o.foldcolumn = "1"
		vim.o.foldlevel = 99 -- Large value for providers like ufo/lsp
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		-- **Removed redundant LSP setup**
		-- If your main LSP config is set up correctly (which it should be),
		-- capabilities are already handled.
	end,

	config = function(_, opts)
		-- The custom fold handler is complex but achieves a specific visual goal (right alignment and text truncation).
		-- Keep it if you like the visual result, but be aware it's the most complex part of the config.
		local handler = function(virtText, lnum, endLnum, width, truncate)
			local alignLimitByTextWidth = true
			local alignLimiter = alignLimitByTextWidth and vim.opt.textwidth["_value"] or vim.api.nvim_win_get_width(0)
			local newVirtText = {}
			local totalLines = vim.api.nvim_buf_line_count(0)
			local foldedLines = endLnum - lnum
			-- Using better characters and formatting for the suffix
			local suffix = (" 󰁂 %d lines (%d%%)"):format(foldedLines, math.floor(foldedLines / totalLines * 100))
			local sufWidth = vim.fn.strdisplaywidth(suffix)
			local targetWidth = width - sufWidth
			local curWidth = 0

			-- Truncate and build the main text
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
					if curWidth + chunkWidth < targetWidth then
						suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
					end
					break
				end
				curWidth = curWidth + chunkWidth
			end

			-- Calculate and apply right alignment padding
			local rAlignAppndx = math.max(math.min(alignLimiter, width - 1) - curWidth - sufWidth, 0)
			suffix = (" "):rep(rAlignAppndx) .. suffix
			table.insert(newVirtText, { suffix, "MoreMsg" })
			return newVirtText
		end
		opts.fold_virt_text_handler = handler
		require("ufo").setup(opts)

		-- Keymaps are good, but consider using <leader> for less common commands
		vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "UFO: Open all folds" })
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "UFO: Close all folds" })
		vim.keymap.set("n", "zs", require("ufo").openFoldsExceptKinds, { desc = "UFO: Open folds except kinds" })

		-- Enhanced 'K' mapping for hover/peek
		vim.keymap.set("n", "K", function()
			-- First, try to peek a folded line
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			-- If no fold was peeked, fall back to LSP hover
			if not winid then
				vim.lsp.buf.hover()
			end
		end, { desc = "UFO/LSP: Peek fold/LSP Hover" })
	end,
}
