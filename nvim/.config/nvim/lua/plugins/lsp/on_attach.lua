local au = vim.api.nvim_create_augroup("LspAttach", { clear = true })

return function(client, bufnr)
	vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })

	-- INLAY HINTS SETUP
	if client and client.supports_method("textDocument/inlayHint") then
		-- Enable inlay hints for all LSPs that support it
		vim.lsp.inlay_hint.enable()
	end

	-- Snacks
	Snacks.notify(("attached to buffer %i"):format(bufnr), {
		level = vim.log.levels.DEBUG,
		title = "LSP: " .. client.name,
	})

	-- **Svelte-specific logic **
	if client.name == "svelte" then
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			group = au,
			pattern = { "*.js", "*.ts" },
			callback = function(ctx)
				client:notify("$/onDidChangeTsOrJsFile", {
					uri = ctx.match,
				})
			end,
		})
	end
end
