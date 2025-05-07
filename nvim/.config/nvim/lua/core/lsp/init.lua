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

-- NOTE: disabled in favor of Snacks.words
--[[ vim.api.nvim_create_autocmd('LspAttach', {
    group = au,
    desc = 'LSP highlight',
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if
            client
            and client:supports_method 'textDocument/documentHighlight'
        then
            local augroup_lsp_highlight = 'lsp_highlight'
            vim.api.nvim_create_augroup(
                augroup_lsp_highlight,
                { clear = false }
            )
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                group = augroup_lsp_highlight,
                buffer = bufnr,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd('CursorMoved', {
                group = augroup_lsp_highlight,
                buffer = bufnr,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
}) ]]

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

vim.lsp.config("*", {
	root_markers = { ".git" },
	capabilities = require("core.lsp.protocol").capabilties,
})

vim.lsp.enable({
	"bash_ls",
	"css_ls",
	"docker_compose_ls",
	"docker_ls",
	"emmet_ls",
	"emmylua_ls",
	"html_ls",
	"json_ls",
	"lua_ls",
	"taplo",
	"ts_ls",
	"yaml_ls",
	"tailwindcss_ls",
	"taplo",
	"esllint-ls",
	"astro_ls",
})
