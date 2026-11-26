-- Which TypeScript server a project gets.
-- tsc (TypeScript 7) removed tsconfig options that older projects still use,
-- such as "baseUrl" (imports like `from 'types'` then fail with "Cannot find
-- module"). Projects whose tsconfig.json/jsconfig.json uses a removed option
-- get ts_ls (typescript-language-server with the project's own TypeScript);
-- every other project gets tsc.
local M = {}

-- Patterns for options TypeScript 7 removed.
local removed = {
	'"baseUrl"%s*:',
	'"moduleResolution"%s*:%s*"[Nn]ode"',
	'"moduleResolution"%s*:%s*"[Nn]ode10"',
	'"moduleResolution"%s*:%s*"[Cc]lassic"',
	'"target"%s*:%s*"[Ee][Ss][35]"',
	'"outFile"%s*:',
}

local cache = {} ---@type table<string, boolean>

--- True when the nearest tsconfig.json/jsconfig.json above the buffer uses
--- an option TypeScript 7 removed.
---@param bufnr integer
---@return boolean
function M.is_legacy(bufnr)
	local file = vim.fs.find({ "tsconfig.json", "jsconfig.json" }, {
		upward = true,
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
	})[1]
	if not file then
		return false
	end
	if cache[file] == nil then
		local ok, lines = pcall(vim.fn.readfile, file)
		local text = ok and table.concat(lines, "\n") or ""
		cache[file] = false
		for _, pattern in ipairs(removed) do
			if text:find(pattern) then
				cache[file] = true
				break
			end
		end
	end
	return cache[file]
end

--- Wrap a server's root_dir so it only attaches when want(bufnr) is true.
---@param name string
---@param want fun(bufnr: integer): boolean
function M.only_when(name, want)
	local default = vim.lsp.config[name].root_dir
	vim.lsp.config(name, {
		root_dir = function(bufnr, on_dir)
			if want(bufnr) then
				default(bufnr, on_dir)
			end
		end,
	})
end

return M
