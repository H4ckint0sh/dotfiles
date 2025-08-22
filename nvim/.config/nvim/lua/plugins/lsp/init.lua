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
	callback = function(attach_args)
		local bufnr = attach_args.buf
		vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = au,
	desc = "LSP inlay hints",
	callback = function(attach_args)
		local bufnr = attach_args.buf
		local client = vim.lsp.get_client_by_id(attach_args.data.client_id)
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
				callback = function(mode_args)
					local split_result = vim.split(mode_args.match, ":")
					local _, new_mode = split_result[1], split_result[2]
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
	callback = function(attach_args)
		local client = vim.lsp.get_client_by_id(attach_args.data.client_id)
		if client then
			Snacks.notify(("attached to buffer %i"):format(attach_args.buf), {
				level = vim.log.levels.DEBUG,
				title = "LSP: " .. client.name,
			})
		end
	end,
})

local function fold_virt_text(result, s, lnum, coloff, force_hl)
	coloff = coloff or 0

	if force_hl then
		-- If forced highlight group, treat the whole string as one group
		table.insert(result, { s, force_hl })
		return
	end

	local text = ""
	local hl = nil
	for i = 1, #s do
		local char = s:sub(i, i)
		-- Get Treesitter captures at position
		local captures = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
		local last_capture = captures[#captures]
		local new_hl = nil
		if last_capture then
			new_hl = "@" .. last_capture.capture
		end

		if new_hl ~= hl then
			-- Append previous text with previous hl
			if text ~= "" then
				table.insert(result, { text, hl })
			end
			text = ""
			hl = new_hl
		end
		text = text .. char
	end

	if text ~= "" then
		table.insert(result, { text, hl })
	end
end

function _G.custom_foldtext()
	-- Get raw lines (no tab substitution) for accurate col positions
	local start_line = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, false)[1]
	local end_line_raw = vim.api.nvim_buf_get_lines(0, vim.v.foldend - 1, vim.v.foldend, false)[1]
	local end_line_trimmed = vim.trim(end_line_raw)
	local folded_lines = vim.v.foldend - vim.v.foldstart + 1

	local result = {}

	-- First line: use Treesitter highlighting (no forced hl)
	fold_virt_text(result, start_line, vim.v.foldstart - 1, 0)

	-- Middle fold marker + folded line count
	table.insert(result, { " ... ", "Comment" })
	table.insert(result, { string.format("(%d lines)", folded_lines), "Comment" })
	table.insert(result, { " ... ", "Comment" })

	-- Last line: forced Comment highlight, with col offset for indentation
	local indent_len = #(end_line_raw:match("^(%s*)") or "")
	fold_virt_text(result, end_line_trimmed, vim.v.foldend - 1, indent_len, "Comment")

	return result
end

vim.opt.foldtext = "v:lua.custom_foldtext()"

-- Your LSP autocommands stay the same:
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(attach_args)
		local client = vim.lsp.get_client_by_id(attach_args.data.client_id)
		if client and client:supports_method("textDocument/foldingRange") then
			local bufnr = attach_args.buf
			for _, winid in ipairs(vim.api.nvim_list_wins()) do
				if vim.api.nvim_win_get_buf(winid) == bufnr then
					vim.api.nvim_set_option_value("foldmethod", "expr", { win = winid })
					vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.lsp.foldexpr()", { win = winid })

					vim.defer_fn(function()
						if
							vim.api.nvim_buf_is_valid(bufnr)
							and vim.lsp.buf_is_attached(bufnr, attach_args.data.client_id)
						then
							vim.lsp.foldclose("imports", winid)
							vim.lsp.foldclose("comment", winid)
						end
					end, 100)
				end
			end
		end
	end,
})

vim.api.nvim_create_autocmd("LspDetach", {
	command = "setl foldexpr<",
	-- Make sure this autocommand group exists or define it
	group = vim.api.nvim_create_augroup("MyFoldDetachGroup", { clear = true }),
})
return {
	{
		"neovim/nvim-lspconfig",
		event = "LspAttach",
		dependencies = {
			{ "mason-org/mason.nvim", cmd = "Mason" },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup({
				-- Registries that should be used.
				registries = {
					"github:mason-org/mason-registry",
					-- Adds a custom registry containing the roslyn and rzls packages.
					-- These packages are currently not included in the mason registry itself.
					-- Source: https://github.com/seblj/roslyn.nvim / https://github.com/tris203/rzls.nvim
					-- TODO: As soon as the packages beeing added to the mason registry we can remove this.
					"github:crashdummyy/mason-registry",
				},
				-- ui config
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"cssls",
					"eslint",
					"graphql",
					"html",
					"jsonls",
					"emmylua_ls",
					"zls",
					"ember",
					"prismals",
					"tailwindcss",
					"astro",
					"ts_ls",
					"jdtls",
					"emmet_language_server",
					"some-sass-language-server",
				},
				automatic_enable = {
					exclude = {
						"ts_ls",
						"emmet_language_server",
					},
				},
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"djlint", -- handlebars formatter
					"eslint", -- javascript formatter
					"rzls",
					"roslyn",
				},
			})
			-- Emmet language server requires this
			require("lspconfig").emmet_language_server.setup({})
		end,
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
