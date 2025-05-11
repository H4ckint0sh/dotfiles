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

-- Auto-close imports on open
vim.api.nvim_create_autocmd("LspNotify", {
	callback = function(args)
		if args.data.method == "textDocument/didOpen" then
			vim.lsp.foldclose("imports", vim.fn.bufwinid(args.buf))
			vim.lsp.foldclose("comment", vim.fn.bufwinid(args.buf))
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldmethod = "expr"
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
			vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
			vim.o.foldcolumn = "1" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
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
			local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")

			vim.lsp.config("*", {
				vim.tbl_deep_extend(
					"force",
					vim.lsp.protocol.make_client_capabilities(),
					blink_cmp.get_lsp_capabilities()
				),
			})

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"cssls",
					"eslint",
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
				"eslint", -- javascript formatter
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
