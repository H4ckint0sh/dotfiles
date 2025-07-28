local custom_lsp_definitions = require("custom.custom-lsp-definitions")
-- stylua: ignore
return {
		{ "<leader>e", function() Snacks.explorer.open() end, desc = "File Explorer", },
		{ '<leader>N', function() Snacks.notifier.hide() end },
		{ "<c-t>", function() Snacks.terminal.toggle() end },
		{ "<leader>x", function() Snacks.bufdelete() end },
		{"<leader>fr", function() Snacks.rename.rename_file() end},
		{ "<leader>X", function() Snacks.bufdelete.all() end, desc = "Delete all buffer" },
		{ "<leader>gb", function() Snacks.gitbrowse() end, desc = "Git Browse" },
		{ "<leader>fh", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
		{ "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
		{ "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
		{ "<leader>t", function() Snacks.picker.grep({ layout = { preset = "ivy" } , hidden = true }) end, desc = "Grep" },
		{ "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
		{ "<leader>s", function() Snacks.picker.smart() end, desc = "Command History" },
		{ "<leader>n", function() Snacks.picker.notifications({
			-- I always want my notification History picker to start in normal mode
			on_show = function()
				vim.cmd.stopinsert()
			end,
		}) end, desc = "Notification History" },
		{ "<leader>f", function() Snacks.picker.files({
            finder = "files",
            format = "file",
			hidden = true,
            show_empty = true,
            supports_live = true,
            -- In case you want to override the layout for this keymap
            layout = "custom",
          }) end, desc = "Find Files" },
		-- find
		{ "<leader>b", function() Snacks.picker.buffers({
            -- I always want my buffers picker to start in normal mode
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = "buffers",
            format = "buffer",
            hidden = false,
            unloaded = true,
            current = true,
            sort_lastused = true,
            win = {
              input = {
                keys = {
                  ["d"] = "bufdelete",
                },
              },
              list = { keys = { ["d"] = "bufdelete" } },
            },
            -- In case you want to override the layout for this keymap
            -- layout = "ivy",
          }) end, desc = "Buffers" },
		{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
		{ "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
		{ "<leader>fh", function() Snacks.picker.recent({ hidden = true, filter = { cwd = true } }) end, desc = "Recent", },
		-- git
		{ "<leader>g", function() Snacks.lazygit() end, desc = "Lazygit" },
		{ "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git Log" },
		{ "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
		-- Grep
		{ "<leader>sb", function() Snacks.picker.lines({ layout = { preset = "ivy" } }) end, desc = "Buffer Lines" },
		{ "<leader>sB", function() Snacks.picker.grep_buffers({ layout = { preset = "ivy" } }) end, desc = "Grep Open Buffers" },
		{ "<leader>sg", function() Snacks.picker.grep({ layout = { preset = "ivy" } }) end, desc = "Grep" },
		{ "<leader>sw", function() Snacks.picker.grep_word({layout = { preset = "ivy" } }) end, desc = "Visual selection or word", mode = { "n", "x" } },
		-- search
		{ '<leader>sr', function() Snacks.picker.registers() end, desc = "Registers" },
		{ "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
		{ "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
		{ "<leader>sC", function() Snacks.picker.commands({ layout = { preset = "vscode" } }) end, desc = "Commands" },
		{ "<leader>d", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
		{ "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
		{ "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
		{ "<leader>j", function() Snacks.picker.jumps() end, desc = "Jumps" },
		{ "<leader>k", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
		{ "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
		{ "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
		{ "<leader>m", function() Snacks.picker.marks() end, desc = "Marks" },
		{ "<leader>`", function() Snacks.picker.resume() end, desc = "Resume" },
		{ "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
		{ "<leader>u", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
		{ "<leader>qp", function() Snacks.picker.projects() end, desc = "Projects" },
		-- LSP
		{ "gd", function() custom_lsp_definitions.definition() end, desc = "Custom Goto Definition" },
		{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
		{ "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
		{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
		{ "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
		{ '<space>sg', function()
		  Snacks.picker.pick {
			format = 'file',
			notify = false, -- Also prevents error when searching with additional arguments
			show_empty = true,
			live = true,
			supports_live = true,
			-- hidden = true,
			-- ignored = true,
			---@param opts snacks.picker.grep.Config
			finder = function(opts, ctx)
			  local cmd = 'ast-grep'
			  local args = { 'run', '--color=never', '--json=stream' }
			  if vim.fn.has 'win32' == 1 then
				cmd = 'sg'
			  end
			  if opts.hidden then
				table.insert(args, '--no-ignore=hidden')
			  end
			  if opts.ignored then
				table.insert(args, '--no-ignore=vcs')
			  end
			  local pattern, pargs = Snacks.picker.util.parse(ctx.filter.search)
			  table.insert(args, string.format('--pattern=%s', pattern))
			  vim.list_extend(args, pargs)
			  return require('snacks.picker.source.proc').proc({
				opts,
				{
				  cmd = cmd,
				  args = args,
				  transform = function(item)
					local entry = vim.json.decode(item.text)
					if vim.tbl_isempty(entry) then
					  return false
					else
					  local start = entry.range.start
					  item.cwd = svim.fs.normalize(opts and opts.cwd or vim.uv.cwd() or '.') or nil
					  item.file = entry.file
					  item.line = entry.text
					  item.pos = { tonumber(start.line) + 1, tonumber(start.column) }
					end
				  end,
				},
			  }, ctx)
			end,
		  }
		end, desc = "Search AST Grep" },
	}
