local M = {}

M.commands = {
	{
		name = "Change File Type",
		action = function()
			local filetypes = {}
			for _, ft in ipairs(vim.fn.getcompletion("", "filetype")) do
				table.insert(filetypes, { text = ft, name = ft })
			end

			Snacks.picker({
				title = "File Types",
				layout = "select",
				items = filetypes,
				format = function(item)
					local icon, icon_hl = require("snacks.util").icon(item.text, "filetype")
					return {
						{ icon .. " ", icon_hl },
						{ item.text },
					}
				end,
				confirm = function(picker, item)
					picker:close()
					vim.cmd.set("ft=" .. item.text)
				end,
			})
		end,
	},
	{
		name = "Explorer",
		action = "<leader>e",
	},
	{
		name = "File: New",
		action = function()
			Snacks.input({
				prompt = "File Name",
				default = "untitled",
			}, function(value)
				vim.cmd("e " .. value .. " | startinsert")
			end)
		end,
	},
	{
		name = "File: Save",
		action = ":w",
	},
	{
		name = "File: Save (Without Formatting)",
		action = ":noa w",
	},
	{
		name = "Find: Buffers",
		action = "<leader>fb",
	},
	{
		name = "Find: Diagnostics (Buffer)",
		action = "<leader>fd",
	},
	{
		name = "Find: Diagnostics (Workspace)",
		action = "<leader>fD",
	},
	{
		name = "Find: Files",
		action = "<leader>f",
	},
	{
		name = "Find: Keymaps",
		action = "<leader>fk",
	},
	{
		name = "Find: Quickfix List",
		action = "<leader>fq",
	},
	{
		name = "Find: Recent",
		action = "<leader>fr",
	},
	{
		name = "Find: Todo Comments",
		action = "<leader>ft",
	},
	{
		name = "Find: Undo",
		action = "<leader>fu",
	},
	{
		name = "Git: Blame (Full)",
		action = "<leader>hb",
	},
	{
		name = "Git: Browse",
		action = function()
			Snacks.gitbrowse()
		end,
	},
	{
		name = "Git: Diff",
		action = "<leader>gdo",
	},
	{
		name = "Git: Diff (HEAD)",
		action = "<leader>gdO",
	},
	{
		name = "Git: History (Branch)",
		action = "<leader>gdhb",
	},
	{
		name = "Git: History (File)",
		action = "<leader>gdhf",
	},
	{
		name = "Git: Hunk (Quickfix List)",
		action = "<leader>gsq",
	},
	{
		name = "Git: Hunk (Location List)",
		action = "<leader>gsl",
	},
	{
		name = "Git: Hunk (Preview)",
		action = "<leader>hp",
	},
	{
		name = "Git: Hunk (Reset)",
		action = "<leader>hr",
	},
	{
		name = "Git: Hunk (Reset Buffer)",
		action = "<leader>hR",
	},
	{
		name = "Git: Hunk (Stage)",
		action = "<leader>hs",
	},
	{
		name = "Indent Guides: Toggle",
		action = function()
			local snacks_indent = require("snacks").indent
			if snacks_indent.enabled then
				snacks_indent.disable()
			else
				snacks_indent.enable()
			end
		end,
	},
	{
		name = "LSP: Rename",
		action = "<leader>r",
	},
	{
		name = "LSP: Actions",
		action = "<leader>a",
	},
	{
		name = "LSP: Format",
		action = "<leader>fr",
	},
	{
		name = "LSP: Format (Async)",
		action = function()
			require("conform").format({ async = true, lsp_fallback = true })
		end,
	},
	{
		name = "LSP: Diagnostics (Quickfix List)",
		action = "<leader>lq",
	},
	{
		name = "LSP: Diagnostics (Location List)",
		action = "<leader>lL",
	},
	{
		name = "LSP: Hover Documentation",
		action = "K",
	},
	{
		name = "LSP: Hover Diagnostics",
		action = "<leader>o",
	},
	{
		name = "LSP: Hover Signature Documentation",
		action = function()
			vim.lsp.buf.signature_help()
		end,
	},
	{
		name = "LSP: Go to Declaration",
		action = "gD",
	},
	{
		name = "LSP: Go to Definitions",
		action = "gd",
	},
	{
		name = "LSP: Go to References",
		action = "gr",
	},
	{
		name = "LSP: Go to Implementation",
		action = "gI",
	},
	{
		name = "LSP: Go to Type Definition",
		action = "gy",
	},
	{
		name = "Marks: Find",
		action = "<leader>fm",
	},
	{
		name = "Marks: New",
		action = ":NewMark",
	},
	{
		name = "Replace: Buffer",
		action = "<leader>rr",
	},
	{
		name = "Replace: Buffer (Word)",
		action = "<leader>rw",
	},
	{
		name = "Replace: Quickfix List",
		action = "<leader>rR",
	},
	{
		name = "Replace: Quickfix List (Word)",
		action = "<leader>rW",
	},
	{
		name = "Tab: Close",
		action = ":tabclose",
	},
	{
		name = "Tab: New",
		action = ":tabnew",
	},
	{
		name = "Tab: New Split",
		action = ":tab split",
	},
	{
		name = "Tab: Next",
		action = ":tabnext",
	},
	{
		name = "Tab: Previous",
		action = ":tabprevious",
	},
	{
		name = "Todo Comments: Quickfix List",
		action = ":TodoQuickFix",
	},
	{
		name = "Todo Comments: Location List",
		action = ":TodoLocList",
	},
	{
		name = "Words: Toggle",
		action = function()
			local snacks_words = require("snacks").words
			if snacks_words.enabled then
				snacks_words.disable()
			else
				snacks_words.enable()
			end
		end,
	},
}

function M.show_commands()
	local items = {}

	for idx, command in ipairs(M.commands) do
		local item = {
			idx = idx,
			name = command.name,
			text = command.name,
			action = command.action,
		}
		table.insert(items, item)
	end

	Snacks.picker({
		title = "Command Palette",
		layout = "select",
		items = items,
		format = function(item, _)
			return {
				{ item.text, item.text_hl },
			}
		end,
		confirm = function(picker, item)
			if type(item.action) == "string" then
				if item.action:find("^:") then
					picker:close()
					return picker:norm(function()
						picker:close()
						vim.cmd(item.action:sub(2))
					end)
				else
					return picker:norm(function()
						picker:close()
						local keys = vim.api.nvim_replace_termcodes(item.action, true, true, true)
						vim.api.nvim_input(keys)
					end)
				end
			end

			return picker:norm(function()
				picker:close()
				item.action()
			end)
		end,
	})
end

return M
