local M = {}

local function jump_to_location(item)
	local uri = item.uri
	local filename = item.filename or (uri and vim.uri_to_fname(uri))
	if not filename then
		return
	end

	-- Fallback to line/col if range isn't available
	local range = item.range
	local lnum = 0
	local col = 0

	if range then
		lnum = range.start and range.start.line or 0
		col = range.start and range.start.character or 0
	elseif item.lnum then
		lnum = item.lnum - 1
		col = (item.col or 1) - 1
	end

	-- Open the file
	vim.cmd("keepalt edit " .. vim.fn.fnameescape(filename))

	-- Move the cursor (convert to 1-based indexing)
	vim.api.nvim_win_set_cursor(0, { lnum + 1, col })

	-- Reveal the location
	vim.cmd("normal! zvzz")
end

local filterDTS = function(item)
	local filename = item.filename or (item.uri and vim.uri_to_fname(item.uri)) or ""
	return not string.match(filename, "%.d%.ts$")
end

local on_list = function(options)
	if not options or not options.items or #options.items == 0 then
		vim.notify("No definitions found", vim.log.levels.INFO)
		return
	end

	-- Filter out .d.ts files if we have mixed results
	local items = options.items
	local has_dts = false
	local has_non_dts = false

	for _, item in ipairs(items) do
		if filterDTS(item) then
			has_non_dts = true
		else
			has_dts = true
		end
	end

	if has_non_dts and has_dts then
		items = vim.tbl_filter(filterDTS, items)
	end

	-- Single result - jump directly
	if #items == 1 then
		jump_to_location(items[1])
		return
	end

	-- Multiple results - show in quickfix
	vim.fn.setqflist({}, " ", {
		title = options.title or "Definitions",
		items = items,
		context = options.context,
	})
	vim.cmd("botright copen")
end

M.definition = function()
	vim.lsp.buf.definition({ on_list = on_list })
end

return M
