local M = {}

local filter = function(arr, fn)
	if type(arr) ~= "table" then
		return arr
	end

	local filtered = {}
	for k, v in pairs(arr) do
		if fn(v, k, arr) then
			table.insert(filtered, v)
		end
	end

	return filtered
end

local filterDTS = function(value)
	return string.match(value.filename, "%.d.ts") == nil
end

local on_list = function(options)
	-- https://github.com/typescript-language-server/typescript-language-server/issues/216
	local items = options.items
	if #items > 0 then
		local all_dts = true
		for _, item in ipairs(items) do
			if filterDTS(item) then
				all_dts = false
				break
			end
		end

		if not all_dts and #items > 1 then -- Filter ONLY if not all are d.ts AND more than one item
			items = filter(items, filterDTS)
		end
	end

	vim.fn.setqflist({}, " ", { title = options.title, items = items, context = options.context })
	vim.api.nvim_command("cfirst")
end

M.definition = function()
	vim.lsp.buf.definition({ on_list = on_list })
end

return M
