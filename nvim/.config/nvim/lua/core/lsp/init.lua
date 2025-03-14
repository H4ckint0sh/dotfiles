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

-- TODO: still needed? without it Pylance was messing up buffer highlights at some point
--[[ local function periodic_refresh_semantic_tokens()
    Snacks.notify('periodic refresh semantic tokens', {
        level = vim.log.levels.DEBUG,
        title = 'LSP',
    })
    if not vim.api.nvim_buf_is_loaded(0) then
        return
    end
    vim.lsp.semantic_tokens.force_refresh(0)
    vim.defer_fn(periodic_refresh_semantic_tokens, 30000)
end

vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
    callback = Snacks.util.throttle(function()
        Snacks.notify('refresh semantic tokens', {
            level = vim.log.levels.DEBUG,
            title = 'LSP',
        })
        vim.lsp.semantic_tokens.force_refresh(0)
    end, { ms = 1000 }),
}) ]]

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
	"html_ls",
	"json_ls",
	"lua_ls",
	"taplo",
	"ts_ls",
	"yaml_ls",
	"tailwindcss_ls",
	"taplo",
	"eslint-ls",
	"astro_ls",
})
