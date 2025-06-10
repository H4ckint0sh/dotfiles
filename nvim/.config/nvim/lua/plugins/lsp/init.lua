---@diagnostic disable: missing-fields
local au = vim.api.nvim_create_augroup("LspAttach", { clear = true })

-- client log level
vim.lsp.set_log_level(vim.log.levels.WARN)

vim.api.nvim_create_user_command("LspFormat", function()
	vim.lsp.buf.format({ async = false })
end, {})

vim.api.nvim_create_autocmd("LspAttach", {
	group = au,
	desc = "LSP tagfunc",
	callback = function(args)
		local bufnr = args.buf
		vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = au,
	desc = "LSP inlay hints",
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/inlayHint") then
			Snacks.notify("registered inlay hints", {
				level = vim.log.levels.DEBUG,
				title = "LSP: " .. client.name,
			})
			vim.api.nvim_create_autocmd({
				"BufWritePost",
				"BufEnter",
				"FocusGained",
				"CursorHold",
			}, {
				buffer = bufnr,
				callback = function()
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end,
			})
			vim.api.nvim_create_autocmd("ModeChanged", {
				buffer = bufnr,
				callback = function(args)
					local _, new_mode = unpack(vim.split(args.match, ":"))
					if

						vim.tbl_contains({ "i", "v", "V", "\22", "R" }, new_mode)
						and vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
					then
						vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
					elseif new_mode == "n" and not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				end,
				desc = "LSP inlay hints: disable for insert & visual mode",
			})
			-- initial request
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = au,
	desc = "LSP notify",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			Snacks.notify(("attached to buffer %i"):format(args.buf), {
				level = vim.log.levels.DEBUG,
				title = "LSP: " .. client.name,
			})
		end
	end,
})

local function fold_virt_text(result, s, lnum, coloff)
	if not coloff then
		coloff = 0
	end
	local text = ""
	local hl
	for i = 1, #s do
		local char = s:sub(i, i)
		local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
		local _hl = hls[#hls]
		if _hl then
			local new_hl = "@" .. _hl.capture
			if new_hl ~= hl then
				table.insert(result, { text, hl })
				text = ""
				hl = nil
			end
			text = text .. char
			hl = new_hl
		else
			text = text .. char
		end
	end
	table.insert(result, { text, hl })
end

function _G.custom_foldtext()
	local start_line = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
	local end_line_raw = vim.fn.getline(vim.v.foldend)
	local end_line_trimmed = vim.trim(end_line_raw)
	local folded_lines = vim.v.foldend - vim.v.foldstart + 1

	local result = {}
	fold_virt_text(result, start_line, vim.v.foldstart - 1)

	-- Insert middle marker and folded line count
	table.insert(result, { " ... ", "comment" })
	table.insert(result, { string.format("%d lines)", folded_lines), "comment" })
	table.insert(result, { " ... ", "comment" })

	fold_virt_text(result, end_line_trimmed, vim.v.foldend, #(end_line_raw:match("^(%s*)") or ""))

	return result
end

vim.opt.foldtext = "v:lua.custom_foldtext()"

-- Auto-close imports on open
vim.api.nvim_create_autocmd("LspNotify", {
	callback = function(args)
		if args.data.method == "textDocument/didOpen" then
			vim.lsp.foldclose("imports", vim.fn.bufwinid(args.buf))
			vim.lsp.foldclose("comment", vim.fn.bufwinid(args.buf))
		end
	end,
})

-- local function filter_diagnostics(diagnostic)
-- 	if diagnostic.source == "tsserver" then
-- 		return false
-- 	end
-- 	return true
-- end
--
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(function(_, result, ctx, config)
-- 	result.diagnostics = vim.tbl_filter(filter_diagnostics, result.diagnostics)
-- 	vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
-- end, {})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldmethod = "expr"
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"cssls",
					"graphql",
					"html",
					"jsonls",
					"lua_ls",
					"zls",
					"ember",
					"prismals",
					"tailwindcss",
					"astro",
					"ts_ls",
					"jdtls",
					"emmet_language_server",
				},
				automatic_enable = {
					exclude = {
						"ts_ls",
					},
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = true,
		opts = {
			ensure_installed = {
				"prettier", -- prettier formatter
				"djlint", -- handlebars formatter
			},
		},
	},
	{
		"folke/neoconf.nvim",
		cmd = "Neoconf",
		opts = {},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
			},
		},
	},
	{
		"antosha417/nvim-lsp-file-operations",
		name = "nvim-lsp-file-operations",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = true,
		opts = {},
	},
	{
		"joechrisellis/lsp-format-modifications.nvim",
		lazy = true,
		dependencies = { "nvim-lua/plenary.nvim" },
		init = function()
			vim.api.nvim_create_user_command("FormatModified", function()
				local bufnr = vim.api.nvim_get_current_buf()
				local clients = vim.lsp.get_clients({
					bufnr = bufnr,
					method = "textDocument/rangeFormatting",
				})

				if #clients == 0 then
					Snacks.notify.error("Format request failed, no matching language servers", { title = "LSP" })
				end

				for _, client in pairs(clients) do
					require("lsp-format-modifications").format_modifications(client, bufnr)
				end
			end, {})
		end,
	},
}
