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

-- Your LSP autocommands stay the same:
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
					"svelte-language-server",
					"somesass_ls",
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
